"""Prepare a reviewable Ln18 update for Codex to publish after user confirmation."""
import copy
import hashlib
import json
import os
from pathlib import Path, PurePosixPath
import re
import shutil
import subprocess
import sys
import tempfile
from urllib.parse import urljoin, urlparse
from urllib.request import url2pathname

from l10n_source import SourceError, ensure_dart_dependencies, resolve_catalog

sys.dont_write_bytecode = True
_VERSION = re.compile(r"(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)")


def _json(path):
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, ValueError) as error:
        raise SourceError(f"Cannot read {path}: {error}") from error
    if not isinstance(value, dict):
        raise SourceError(f"Expected a JSON object: {path}")
    return value


def _write(path, value):
    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_text(json.dumps(value, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")


def _sha(path):
    return hashlib.sha256(path.read_bytes()).hexdigest()


def _version(value):
    if not isinstance(value, str) or not _VERSION.fullmatch(value):
        raise SourceError("Catalog versions must be stable major.minor.patch versions.")
    return tuple(int(part) for part in value.split("."))


def _request(path, renderer):
    request = _json(path)
    if type(request.get("schemaVersion")) is not int or request["schemaVersion"] != 1:
        raise SourceError("Unsupported l10n.changes.json schemaVersion.")
    if set(request) - {"schemaVersion", "version", "entries"}:
        raise SourceError("Unexpected l10n.changes.json fields.")
    entries = request.get("entries")
    if not isinstance(entries, list) or not entries:
        raise SourceError("No pending language changes. Add entries to l10n.changes.json first.")
    if "version" in request:
        _version(request["version"])
    seen = set()
    for entry in entries:
        if not isinstance(entry, dict):
            raise SourceError("Each language change must be an object.")
        allowed = {"module", "path", "values"} if renderer == "pc" else {"module", "key", "values", "metadata", "sdk"}
        if set(entry) - allowed:
            raise SourceError("Unexpected language entry fields.")
        module = entry.get("module")
        pattern = r"[a-z][A-Za-z0-9_]*" if renderer == "pc" else r"[a-z][a-z0-9_]*"
        if not isinstance(module, str) or not re.fullmatch(pattern, module):
            raise SourceError(f"Invalid language module: {module!r}")
        values = entry.get("values")
        if not isinstance(values, dict) or not values or any(not isinstance(k, str) or not isinstance(v, str) or not v.strip() for k, v in values.items()):
            raise SourceError("values must contain nonempty translations keyed by locale.")
        if renderer == "pc":
            path_parts = entry.get("path")
            if not isinstance(path_parts, list) or not path_parts or any(not isinstance(p, str) or not p or p in {"__proto__", "prototype", "constructor"} for p in path_parts):
                raise SourceError("PC path must be a nonempty array of safe JSON object keys.")
            identity = (module, tuple(path_parts))
        else:
            key = entry.get("key")
            if not isinstance(key, str) or not re.fullmatch(r"[a-z][A-Za-z0-9]*", key):
                raise SourceError(f"Invalid ARB key: {key!r}")
            if "sdk" in entry and type(entry["sdk"]) is not bool:
                raise SourceError("sdk must be true or false.")
            if "metadata" in entry and not isinstance(entry["metadata"], dict):
                raise SourceError("metadata must be an ARB metadata object.")
            identity = key
        if identity in seen:
            raise SourceError(f"Duplicate language change: {identity!r}")
        seen.add(identity)
    return request


def _source_files(package):
    result = {}
    for path in package.rglob("*"):
        relative = path.relative_to(package)
        if any(part in {".dart_tool", "__pycache__"} for part in relative.parts) or path.name == ".DS_Store":
            continue
        if path.is_symlink():
            raise SourceError(f"Refusing a symbolic link in language sources: {path}")
        if path.is_file():
            result[relative.as_posix()] = path.read_bytes()
    return result


def _same_base(base, current):
    if not current.is_dir() or _source_files(base) != _source_files(current):
        raise SourceError("The remote maintenance source differs from this consumer's pinned base. Adopt the current published version first; no source changes were applied.")


def _safe_package(checkout, relative):
    path = PurePosixPath(str(relative))
    if path.is_absolute() or "\\" in str(relative) or not path.parts or path.parts[0] != "packages" or any(part in {"", ".", "..", ".git"} for part in path.parts):
        raise SourceError("package_directory must be a safe path below Ln18/packages.")
    target = checkout.joinpath(*path.parts)
    if any(p.is_symlink() for p in [target, *target.parents] if p != checkout.parent):
        raise SourceError("Refusing a symbolic link in the package path.")
    return target


def _target(root, expected_renderer=None):
    root = Path(root).expanduser().resolve()
    resources = _json(root / "l10n.resources.json")
    renderer = resources.get("renderer")
    if renderer not in {"mobile", "sdk", "pc"} or (expected_renderer and renderer != expected_renderer):
        raise SourceError(f"Unexpected language renderer at {root}.")
    source = _json(root / "l10n.source.json")
    if source.get("catalogVersion") != resources.get("catalogVersion"):
        raise SourceError(f"Consumer source/resource version mismatch: {root}")
    result = {"root": str(root), "renderer": renderer, "oldSource": source, "oldResources": resources, "modules": []}
    if resources.get("flutterBundle"):
        bundle = PurePosixPath(resources["flutterBundle"])
        if bundle.is_absolute() or ".." in bundle.parts:
            raise SourceError("Unsafe Flutter bundle configuration path.")
        result["oldBundle"] = _json(root.joinpath(*bundle.parts))
        if result["oldBundle"].get("catalogVersion") != resources.get("catalogVersion"):
            raise SourceError(f"Consumer bundle/resource version mismatch: {root}")
    return result


def _complete(values, locales, is_new):
    if set(values) - set(locales):
        raise SourceError(f"Unknown translation locales: {', '.join(sorted(set(values) - set(locales)))}")
    missing = set(locales) - set(values)
    if is_new and missing:
        raise SourceError(f"New words require every catalog locale; missing: {', '.join(sorted(missing))}")


def _preflight_changes(package, renderer, entries):
    """Check locale completeness and key ownership before making a checkout."""
    index = _json(package / ("catalog/pc/index.json" if renderer == "pc" else "catalog/index.json"))
    if renderer == "pc":
        for entry in entries:
            docs = []
            for locale in index["locales"]:
                path = package / f"catalog/pc/{locale}/{entry['module']}.json"
                docs.append(_json(path) if path.exists() else {})
            _complete(entry["values"], index["locales"], any(_leaf(doc, entry["path"]) is None for doc in docs))
    else:
        owners = {key: module for module, keys in index["modules"].items() for key in keys}
        sdk = _json(package / "catalog/profiles/im_sdk.json")
        for entry in entries:
            key = entry["key"]
            if key in owners and owners[key] != entry["module"]:
                raise SourceError(f"{key} already belongs to module {owners[key]}.")
            _complete(entry["values"], index["locales"], key not in owners)
            if renderer == "sdk":
                for locale in entry["values"]:
                    fallback = sdk.get("overrideFallbackLocaleByLocale", {}).get(locale, locale)
                    if key in sdk.get("overrides", {}).get(locale, {}) or key in sdk.get("overrides", {}).get(fallback, {}):
                        raise SourceError(f"{key}/{locale} is owned by an SDK-specific override. Maintain that explicit override source rather than silently changing the shared word.")


def _profile_key(profile, key, locales, translations, previous_metadata, metadata_supplied):
    added = key not in profile["keys"]
    if added:
        profile["keys"].append(key)
    # A profile without a metadata map intentionally inherits canonical metadata.
    if "metadata" not in profile:
        return
    for locale in profile["locales"]:
        if locale not in locales:
            raise SourceError(f"Profile locale is absent from the catalog: {locale}")
        per_locale = profile["metadata"].setdefault(locale, {})
        meta_key = "@" + key
        existing = per_locale.get(meta_key)
        inherited = previous_metadata.get(locale)
        canonical = translations[locale].get(meta_key)
        if metadata_supplied and not added and existing is not None and existing != inherited:
            raise SourceError(f"{key}/{locale} has profile-specific metadata; update its explicit source separately.")
        if added or metadata_supplied:
            if canonical is None:
                per_locale.pop(meta_key, None)
            else:
                per_locale[meta_key] = copy.deepcopy(canonical)


def _apply_flutter(package, renderer, entries):
    index_path = package / "catalog/index.json"
    index = _json(index_path)
    locales = index["locales"]
    modules = index["modules"]
    profiles = {name: _json(package / f"catalog/profiles/{name}.json") for name in ["chat_mobile", "im_sdk"]}
    owners = {key: module for module, keys in modules.items() for key in keys}
    needed = {"mobile": set(), "sdk": set()}
    documents = {}
    for entry in entries:
        module, key, values = entry["module"], entry["key"], entry["values"]
        if key in owners and owners[key] != module:
            raise SourceError(f"{key} already belongs to module {owners[key]}.")
        is_new = key not in owners
        _complete(values, locales, is_new)
        if module not in modules:
            modules[module] = []
        if is_new:
            modules[module].append(key)
            owners[key] = module
        translations = {}
        previous_metadata = {}
        for locale in locales:
            path = package / f"catalog/{module}/app_{locale}.arb"
            document = documents.setdefault(path, _json(path) if path.exists() else {"@@locale": locale})
            previous_metadata[locale] = copy.deepcopy(document.get("@" + key))
            if locale in values:
                document[key] = values[locale]
            if "metadata" in entry:
                document["@" + key] = copy.deepcopy(entry["metadata"])
            translations[locale] = document
        selected = ["im_sdk"] if renderer == "sdk" else ["chat_mobile"]
        if entry.get("sdk") and "im_sdk" not in selected:
            selected.append("im_sdk")
        for name in selected:
            _profile_key(profiles[name], key, locales, translations, previous_metadata, "metadata" in entry)
        if renderer == "mobile":
            needed["mobile"].add(module)
        if key in profiles["im_sdk"]["keys"]:
            needed["sdk"].add(module)
    for path, document in documents.items():
        _write(path, document)
    _write(index_path, index)
    for name, profile in profiles.items():
        _write(package / f"catalog/profiles/{name}.json", profile)
    return needed


def _leaf(tree, path):
    current = tree
    for part in path:
        if not isinstance(current, dict) or part not in current:
            return None
        current = current[part]
    return current


def _set_leaf(tree, path, value):
    current = tree
    for part in path[:-1]:
        current = current.setdefault(part, {})
        if not isinstance(current, dict):
            raise SourceError(f"PC path crosses an existing non-object: {'.'.join(path)}")
    if path[-1] in current and not isinstance(current[path[-1]], str):
        raise SourceError(f"PC path would replace an object or array: {'.'.join(path)}")
    current[path[-1]] = value


def _apply_pc(package, entries):
    index_path = package / "catalog/pc/index.json"
    index = _json(index_path)
    locales = index["locales"]
    documents = {}
    for entry in entries:
        module, path, values = entry["module"], entry["path"], entry["values"]
        for locale in locales:
            target = package / f"catalog/pc/{locale}/{module}.json"
            documents.setdefault(target, _json(target) if target.exists() else {})
        is_new = any(_leaf(documents[package / f"catalog/pc/{locale}/{module}.json"], path) is None for locale in locales)
        _complete(values, locales, is_new)
        if module not in index["modules"]:
            index["modules"].append(module)
            for locale in locales:
                index["moduleOrder"][locale].append(module)
        for locale, text in values.items():
            _set_leaf(documents[package / f"catalog/pc/{locale}/{module}.json"], path, text)
    for path, document in documents.items():
        _write(path, document)
    _write(index_path, index)
    return {"pc": {entry["module"] for entry in entries}}


def _relative(value):
    path = PurePosixPath(str(value))
    if path.is_absolute() or "\\" in str(value) or any(part in {".", ".."} for part in path.parts):
        raise SourceError(f"Unsafe preview input path: {value}")
    return path


def _copy_preview_file(source_root, destination_root, relative):
    relative = _relative(relative)
    source = source_root.joinpath(*relative.parts)
    if not source.exists():
        return
    if source.is_symlink() or not source.is_file():
        raise SourceError(f"Preview input is not a regular file: {source}")
    output = destination_root.joinpath(*relative.parts)
    output.parent.mkdir(parents=True, exist_ok=True)
    shutil.copy2(source, output)


def _package_config(source, destination, original_package, preview_package):
    config = _json(source)
    for package in config.get("packages", []):
        uri = urljoin(source.as_uri(), package["rootUri"])
        parsed = urlparse(uri)
        if parsed.scheme != "file":
            raise SourceError(f"Preview dependencies must resolve to local files: {package.get('name')}")
        local = Path(url2pathname(parsed.path)).resolve()
        package["rootUri"] = (preview_package if local == original_package.resolve() else local).as_uri() + "/"
    _write(destination, config)


def _tools(target):
    root = Path(target["root"])
    if target["renderer"] == "mobile":
        candidates = [root / ".fvm/flutter_sdk/bin/flutter"]
        expected = None
    else:
        expected = (root / ".flutter-version").read_text(encoding="utf-8").strip()
        configured = os.environ.get("FLUTTER_BIN")
        candidates = ([Path(configured).expanduser()] if configured else []) + [root / ".fvm/flutter_sdk/bin/flutter", Path.home() / f"fvm/versions/{expected}/bin/flutter"]
    found = next((shutil.which(str(path)) for path in candidates if shutil.which(str(path))), None)
    if not found:
        raise SourceError(f"The fixed Flutter toolchain is required for a preview: {root}")
    flutter = str(Path(found).resolve())
    dart = shutil.which(str(Path(flutter).with_name("dart.bat" if os.name == "nt" else "dart")))
    if not dart:
        raise SourceError(f"Dart executable is missing beside {flutter}")
    if expected:
        result = subprocess.run([flutter, "--no-version-check", "--version", "--machine"], capture_output=True, text=True, check=True)
        if json.loads(result.stdout).get("frameworkVersion") != expected:
            raise SourceError(f"SDK preview requires Flutter {expected}.")
    return flutter, str(Path(dart).resolve())


def _run_preview(command, cwd, log):
    result = subprocess.run(command, cwd=cwd, capture_output=True, text=True)
    log.write_text(result.stdout + result.stderr, encoding="utf-8")
    if result.returncode:
        raise SourceError(f"Preview generation/check failed (exit {result.returncode}); inspect {log}.")


def _validate_previews(package, base, targets, job):
    """Run the real generators against isolated copies before an archive exists."""
    version = _json(package / "catalog/index.json")["packageVersion"]
    reports = []
    for target in targets:
        source = Path(target["root"])
        preview = job / "preview" / target["renderer"]
        preview.mkdir(parents=True, exist_ok=False)
        resources = copy.deepcopy(target["oldResources"])
        resources["catalogVersion"] = version
        if "modules" in resources:
            resources["modules"] += [module for module in target["modules"] if module not in resources["modules"]]
        _write(preview / "l10n.resources.json", resources)
        receipt_path = source / "l10n.resources.lock.json"
        if receipt_path.is_file():
            for name in _json(receipt_path).get("outputs", {}):
                _copy_preview_file(source, preview, name)
            _copy_preview_file(source, preview, "l10n.resources.lock.json")
        command = [sys.executable, str(package / "tools/sync.py"), "--consumer-root", str(preview)]
        flutter = None
        if resources.get("flutterBundle"):
            relative = _relative(resources["flutterBundle"])
            original_bundle_root = source.joinpath(*relative.parts).parent
            preview_bundle_root = preview.joinpath(*relative.parts).parent
            bundle = copy.deepcopy(target["oldBundle"])
            bundle["catalogVersion"] = version
            bundle["modules"] += [module for module in target["modules"] if module not in bundle["modules"]]
            _write(preview.joinpath(*relative.parts), bundle)
            for name in ["pubspec.yaml", "pubspec.lock", "l10n.yaml", "l10n.bundle.lock.json"]:
                _copy_preview_file(original_bundle_root, preview_bundle_root, name)
            output = _relative(bundle["outputDir"])
            original_output = original_bundle_root.joinpath(*output.parts)
            if original_output.exists():
                for path in original_output.rglob("*"):
                    if path.is_file() or path.is_symlink():
                        _copy_preview_file(original_bundle_root, preview_bundle_root, path.relative_to(original_bundle_root))
            config = original_bundle_root / ".dart_tool/package_config.json"
            if not config.is_file():
                raise SourceError(f"Prepare the project's dependencies before preview generation: {original_bundle_root}")
            _package_config(config, preview_bundle_root / ".dart_tool/package_config.json", original_bundle_root, preview_bundle_root)
            flutter, dart = _tools(target)
            ensure_dart_dependencies(base, dart, offline=True)
            _package_config(base / ".dart_tool/package_config.json", package / ".dart_tool/package_config.json", base, package)
            command += ["--dart", dart]
        _run_preview(command, preview, preview / "sync.log")
        if flutter:
            _run_preview([flutter, "--no-version-check", "gen-l10n"], preview_bundle_root, preview / "gen-l10n.log")
        _run_preview([*command, "--check"], preview, preview / "check.log")
        reports.append({"renderer": target["renderer"], "previewRoot": str(preview), "generation": "passed", "check": "passed", "flutterGenL10n": bool(flutter)})
    return reports


def prepare_update(consumer_root, *, changes_path=None, workspace=None, sdk_root=None, package_directory=None):
    """Create an uncommitted Ln18 checkout, version archive, and adoption plan."""
    root = Path(consumer_root).expanduser().resolve()
    target = _target(root)
    renderer = target["renderer"]
    changes = Path(changes_path).expanduser().resolve() if changes_path else root / "l10n.changes.json"
    request = _request(changes, renderer)
    source = target["oldSource"]
    base_version = source["catalogVersion"]
    major, minor, patch = _version(base_version)
    version = request.get("version", f"{major}.{minor}.{patch + 1}")
    if _version(version) <= (major, minor, patch):
        raise SourceError("The prepared catalog version must be newer than the pinned version.")
    if os.environ.get("IM_L10N_CATALOG_ROOT"):
        raise SourceError("prepare requires the fixed remote baseline. Unset IM_L10N_CATALOG_ROOT before preparing an update.")
    if renderer == "mobile" and any(entry.get("sdk") for entry in request["entries"]) and sdk_root is None:
        raise SourceError("SDK words were selected. Pass --sdk-root to include its version pin and generation in the plan.")
    targets = [target]
    if sdk_root is not None:
        if renderer != "mobile":
            raise SourceError("--sdk-root is only for a mobile update that also targets the SDK.")
        sdk = _target(sdk_root, "sdk")
        if sdk["oldSource"] != source:
            raise SourceError("Mobile and SDK must have the same pinned catalog before a joint update.")
        targets.append(sdk)
    base = resolve_catalog(root)
    _preflight_changes(base, renderer, request["entries"])
    if renderer == "mobile" and sdk_root is None:
        selected_sdk_keys = set(_json(base / "catalog/profiles/im_sdk.json")["keys"])
        if any(entry["key"] in selected_sdk_keys for entry in request["entries"]):
            raise SourceError("This update changes shared words already selected by the SDK. Pass --sdk-root so its language update is not forgotten.")
    relative = package_directory or (f"packages/im_l10n_catalog-{base_version}" if renderer == "pc" else "packages/im_l10n_catalog")
    # Validate the supplied path before creating a checkout or altering any source.
    _safe_package(Path("/Ln18"), relative)
    if workspace is None:
        repository_root = Path(subprocess.check_output(["git", "rev-parse", "--show-toplevel"], cwd=root, text=True).strip())
        parent = repository_root / (".work" if renderer == "sdk" else ".local") / "l10n-updates"
        parent.mkdir(parents=True, exist_ok=True)
        job = Path(tempfile.mkdtemp(prefix=f"{renderer}-{version}-", dir=parent))
    else:
        job = Path(workspace).expanduser().resolve()
        if job.exists():
            raise SourceError(f"Workspace already exists; select a new directory: {job}")
        job.mkdir(parents=True)
    checkout = job / "Ln18"
    try:
        repository_url = source["repository"].rstrip("/").removesuffix(".git") + ".git"
        subprocess.run(["git", "clone", "--depth", "1", "--branch", "main", "--", repository_url, str(checkout)], check=True)
        upstream = _safe_package(checkout, relative)
        _same_base(base, upstream)
        archive_relative = f"deliverables/im_l10n_catalog-{version}.zip"
        if (checkout / archive_relative).exists():
            raise SourceError("This catalog version is already archived. Adopt that published version or choose a newer version.")
        package = upstream
        if renderer == "pc":
            package = checkout / f"packages/im_l10n_catalog-{version}"
            if package.exists():
                raise SourceError(f"The new PC maintenance source already exists: {package}")
            shutil.copytree(upstream, package, ignore=shutil.ignore_patterns(".dart_tool", "__pycache__", ".DS_Store"))
        needed = _apply_pc(package, request["entries"]) if renderer == "pc" else _apply_flutter(package, renderer, request["entries"])
        index = _json(package / "catalog/index.json")
        index["packageVersion"] = version
        _write(package / "catalog/index.json", index)
        pubspec = package / "pubspec.yaml"
        text, count = re.subn(r"(?m)^version:\s*[^\s#]+", f"version: {version}", pubspec.read_text(encoding="utf-8"))
        if count != 1:
            raise SourceError("Catalog pubspec must contain exactly one version.")
        pubspec.write_text(text, encoding="utf-8")
        if renderer == "pc":
            pc_renderer = package / "renderers/pc.py"
            old = pc_renderer.read_text(encoding="utf-8")
            pc_renderer.write_text(old.replace(f"Generated from im_l10n_catalog {base_version}.", f"Generated from im_l10n_catalog {version}."), encoding="utf-8")
        for item in targets:
            item["modules"] = sorted(needed.get(item["renderer"], set()))
        preview_validation = _validate_previews(package, base, targets, job)
        subprocess.run([sys.executable, str(checkout / "tool/package_catalog.py"), "--package-root", str(package)], cwd=checkout, check=True)
        archive = checkout / archive_relative
        if not archive.is_file():
            raise SourceError("The archive command did not produce the prepared version.")
        plan = {"schemaVersion": 1, "repository": source["repository"], "version": version,
                "archive": archive_relative, "sha256": _sha(archive), "checkout": str(checkout),
                "packageDirectory": str(package.relative_to(checkout)), "changesPath": str(changes),
                "changesSha256": _sha(changes), "baseRevision": source["revision"], "targets": targets,
                "previewValidation": preview_validation}
        path = job / "plan.json"
        _write(path, plan)
        return path
    except (OSError, ValueError, subprocess.CalledProcessError, SourceError) as error:
        raise SourceError(f"Cannot prepare language update: {error}. Workspace retained at {job}; no consumer source pins were changed.") from error
