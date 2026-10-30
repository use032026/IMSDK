#!/usr/bin/env python3
"""Prepare and adopt language updates locally; Codex publishes after user confirmation."""
import argparse
from contextlib import contextmanager
import hashlib
import importlib.util
import json
import os
from pathlib import Path, PurePosixPath
import re
import subprocess
import sys
import tempfile

sys.dont_write_bytecode = True

from l10n_source import SourceError, resolve_catalog


def _read(path):
    try:
        value = json.loads(Path(path).read_text(encoding="utf-8"))
    except (OSError, ValueError) as error:
        raise SourceError(f"Cannot read {path}: {error}") from error
    if not isinstance(value, dict):
        raise SourceError(f"Expected a JSON object: {path}")
    return value


def _write(path, value):
    path = Path(path)
    path.parent.mkdir(parents=True, exist_ok=True)
    with tempfile.NamedTemporaryFile(mode="w", encoding="utf-8", dir=path.parent,
                                     prefix=".l10n-update-", delete=False) as handle:
        temporary = Path(handle.name)
        json.dump(value, handle, ensure_ascii=False, indent=2)
        handle.write("\n")
    try:
        os.replace(temporary, path)
    finally:
        if temporary.exists():
            temporary.unlink()


def _target(root, relative):
    text = str(relative)
    path = PurePosixPath(text)
    if (path.is_absolute() or not path.parts or "\\" in text or ":" in text
            or any(part in {"", ".", ".."} for part in text.split("/"))):
        raise SourceError(f"Unsafe consumer resource path: {relative}")
    result = root.joinpath(*path.parts)
    current = root
    for part in path.parts:
        current = current / part
        if current.is_symlink():
            raise SourceError(f"Refusing symbolic link resource: {current}")
    return result


def _load_plan(path):
    plan = _read(path)
    if plan.get("schemaVersion") != 1:
        raise SourceError("Unsupported language update plan schema.")
    if not re.fullmatch(r"https://github\.com/[A-Za-z0-9_-]+/[A-Za-z0-9_.-]+(?:\.git)?", str(plan.get("repository", ""))):
        raise SourceError("Plan repository must be an HTTPS GitHub repository.")
    if not re.fullmatch(r"\d+\.\d+\.\d+(?:-[A-Za-z0-9.-]+)?", str(plan.get("version", ""))):
        raise SourceError("Plan has no valid catalog version.")
    if plan.get("archive") != f"deliverables/im_l10n_catalog-{plan['version']}.zip":
        raise SourceError("Plan archive does not match its catalog version.")
    if not re.fullmatch(r"[0-9a-f]{64}", str(plan.get("sha256", ""))):
        raise SourceError("Plan has no archive SHA256.")
    targets = plan.get("targets")
    if not isinstance(targets, list) or not targets:
        raise SourceError("Plan needs at least one consumer target.")
    seen = set()
    for target in targets:
        if not isinstance(target, dict) or target.get("renderer") not in {"mobile", "pc", "sdk"}:
            raise SourceError("Plan contains an invalid consumer target.")
        root = Path(target.get("root", "")).expanduser()
        if not root.is_absolute() or not root.is_dir() or root.resolve() in seen:
            raise SourceError("Consumer roots must be existing, distinct absolute directories.")
        target["root"] = str(root.resolve())
        seen.add(root.resolve())
        if not isinstance(target.get("oldSource"), dict):
            raise SourceError("Plan target is missing its original source pin.")
        for field in ["oldResources", "oldBundle"]:
            if field in target and not isinstance(target[field], dict):
                raise SourceError(f"Plan target {field} must be a configuration snapshot.")
        modules = target.get("modules", [])
        module_pattern = r"[a-z][A-Za-z0-9_]*" if target["renderer"] == "pc" else r"[a-z][a-z0-9_]*"
        if not isinstance(modules, list) or any(not isinstance(m, str) or not re.fullmatch(module_pattern, m) for m in modules):
            raise SourceError("Plan target modules must be explicit module names.")
    if not Path(str(plan.get("changesPath", ""))).is_absolute() or not re.fullmatch(r"[0-9a-f]{64}", str(plan.get("changesSha256", ""))):
        raise SourceError("Plan must record the absolute draft path and its checksum.")
    return plan


def _remote_revision(repository, revision):
    if revision is None:
        try:
            result = subprocess.run(["git", "ls-remote", repository, "HEAD"], check=True,
                                    capture_output=True, text=True)
        except (OSError, subprocess.CalledProcessError) as error:
            raise SourceError("Cannot read the remote Ln18 HEAD. Publish the prepared archive, then retry.") from error
        lines = result.stdout.strip().splitlines()
        if len(lines) != 1 or len(lines[0].split()) != 2:
            raise SourceError("Remote repository did not return one HEAD revision.")
        revision = lines[0].split()[0]
    if not isinstance(revision, str) or not re.fullmatch(r"[0-9a-f]{40}", revision):
        raise SourceError("Adopt requires a full lowercase 40-character remote commit SHA.")
    return revision


def _sync_entry(root, renderer):
    entry = root / ({"mobile": "tool/sync_l10n.py", "pc": "scripts/sync-l10n.py", "sdk": "scripts/sync_l10n.py"}[renderer])
    if not entry.is_file():
        raise SourceError(f"Consumer sync entry is missing: {entry}")
    return entry


def _sync(root, renderer, *, check=False, plan_path=None, offline=False, cache_dir=None):
    command = [sys.executable, str(_sync_entry(root, renderer))]
    if check:
        command.append("--check")
    if offline:
        command.append("--offline")
    if cache_dir is not None:
        command += ["--cache-dir", str(Path(cache_dir).expanduser().resolve())]
    environment = dict(os.environ)
    environment.pop("IM_L10N_CATALOG_ROOT", None)
    if plan_path is not None:
        environment["L10N_UPDATE_PLAN"] = str(Path(plan_path).resolve())
    else:
        environment.pop("L10N_UPDATE_PLAN", None)
    subprocess.run(command, cwd=root, env=environment, check=True)


@contextmanager
def _remote_catalog(plan, source, plan_path):
    """Use a fresh cache, so an unpublished local archive cannot pass adoption."""
    with tempfile.TemporaryDirectory(prefix=".adopt-remote-", dir=Path(plan_path).parent) as name:
        temporary = Path(name)
        _write(temporary / "l10n.source.json", source)
        _write(temporary / "l10n.resources.json", {"schemaVersion": 1, "catalogVersion": plan["version"]})
        old_override = os.environ.pop("IM_L10N_CATALOG_ROOT", None)
        try:
            catalog = resolve_catalog(temporary, cache_dir=temporary / "cache")
        finally:
            if old_override is not None:
                os.environ["IM_L10N_CATALOG_ROOT"] = old_override
        yield catalog


def _rendered_paths(catalog, root, config):
    renderer = config["renderer"]
    script = catalog / "renderers" / f"{renderer}.py"
    if not script.is_file():
        raise SourceError(f"Remote catalog renderer is missing: {script}")
    spec = importlib.util.spec_from_file_location(f"l10n_update_{renderer}", script)
    module = importlib.util.module_from_spec(spec)
    spec.loader.exec_module(module)
    outputs = module.render(catalog, root, config)
    if not isinstance(outputs, dict) or not outputs:
        raise SourceError("Remote catalog renderer produced no resources.")
    return [_target(root, name) for name in outputs]


class _Snapshot:
    """Only language-owned output paths; no Git state or unrelated code is restored."""
    def __init__(self):
        self.files = {}
        self.directories = {}
        self.absent_directories = set()

    def add_file(self, path):
        if path in self.files:
            return
        if path.is_symlink() or (path.exists() and not path.is_file()):
            raise SourceError(f"Cannot snapshot resource file: {path}")
        self.files[path] = (path.read_bytes(), path.stat().st_mode & 0o777) if path.exists() else None
        parent = path.parent
        while not parent.exists():
            self.absent_directories.add(parent)
            parent = parent.parent

    def add_directory(self, path):
        if path in self.directories:
            return
        if path.is_symlink() or (path.exists() and not path.is_dir()):
            raise SourceError(f"Cannot snapshot generated resource directory: {path}")
        members = set()
        if path.exists():
            for member in path.rglob("*"):
                if member.is_symlink():
                    raise SourceError(f"Cannot snapshot symbolic link resource: {member}")
                if member.is_file():
                    members.add(member)
                    self.add_file(member)
        self.directories[path] = members
        if not path.exists():
            self.absent_directories.add(path)

    def restore(self):
        for directory, members in self.directories.items():
            if directory.exists():
                for path in directory.rglob("*"):
                    if path.is_file() and path not in members:
                        path.unlink()
        for path, saved in self.files.items():
            if saved is None:
                if path.exists():
                    path.unlink()
            else:
                path.parent.mkdir(parents=True, exist_ok=True)
                path.write_bytes(saved[0])
                path.chmod(saved[1])
        for directory in sorted(self.absent_directories, key=lambda p: len(p.parts), reverse=True):
            if directory.is_dir() and not any(directory.iterdir()):
                directory.rmdir()


def _target_update(target, source, catalog, snapshot):
    root = Path(target["root"])
    resource_path = root / "l10n.resources.json"
    config = _read(resource_path)
    old_source = _read(root / "l10n.source.json")
    if old_source != target["oldSource"] or old_source.get("repository") != source["repository"]:
        raise SourceError(f"Consumer source pin changed since prepare: {root}")
    if "oldResources" in target and config != target["oldResources"]:
        raise SourceError(f"Consumer resource configuration changed since prepare: {resource_path}")
    if config.get("catalogVersion") != old_source.get("catalogVersion") or config.get("renderer") != target["renderer"]:
        raise SourceError(f"Consumer resource version/renderer does not match its plan: {root}")
    updated = dict(config, catalogVersion=source["catalogVersion"])
    writes = {root / "l10n.source.json": source, resource_path: updated}
    snapshot.add_file(root / "l10n.resources.lock.json")
    receipt = _read(root / "l10n.resources.lock.json")
    for relative in receipt.get("outputs", {}):
        snapshot.add_file(_target(root, relative))
    for path in _rendered_paths(catalog, root, updated):
        snapshot.add_file(path)
    bundle_name = config.get("flutterBundle")
    if bundle_name:
        bundle_path = _target(root, bundle_name)
        bundle = _read(bundle_path)
        if "oldBundle" in target and bundle != target["oldBundle"]:
            raise SourceError(f"Consumer Flutter bundle configuration changed since prepare: {bundle_path}")
        if bundle.get("catalogVersion") != old_source["catalogVersion"]:
            raise SourceError(f"Consumer Flutter bundle version differs: {bundle_path}")
        modules = list(bundle.get("modules", []))
        for module in target.get("modules", []):
            if module not in modules:
                modules.append(module)
        writes[bundle_path] = dict(bundle, catalogVersion=source["catalogVersion"], modules=modules)
        snapshot.add_file(bundle_path.parent / "l10n.bundle.lock.json")
        snapshot.add_file(bundle_path.parent / "l10n.yaml")
        snapshot.add_directory(_target(bundle_path.parent, bundle.get("outputDir", "lib/l10n")))
    for path in writes:
        snapshot.add_file(path)
    return writes


def adopt_update(plan_path, *, revision=None, dry_run=False):
    plan_path = Path(plan_path).expanduser().resolve()
    plan = _load_plan(plan_path)
    revision = _remote_revision(plan["repository"], revision)
    source = {"schemaVersion": 1, "repository": plan["repository"], "revision": revision,
              "catalogVersion": plan["version"], "archive": plan["archive"], "sha256": plan["sha256"]}
    snapshot = _Snapshot()
    writes = {}
    with _remote_catalog(plan, source, plan_path) as catalog:
        # Complete all remote/source/consumer checks before any config or output write.
        for target in plan["targets"]:
            writes.update(_target_update(target, source, catalog, snapshot))
        for target in plan["targets"]:
            _sync(Path(target["root"]), target["renderer"], check=True, plan_path=plan_path)
        if dry_run:
            return {"status": "verified", "revision": revision, "targets": len(plan["targets"]), "dryRun": True}
        try:
            for path, value in writes.items():
                _write(path, value)
            for target in plan["targets"]:
                _sync(Path(target["root"]), target["renderer"], plan_path=plan_path)
                _sync(Path(target["root"]), target["renderer"], check=True, plan_path=plan_path)
            changes_path = Path(plan["changesPath"])
            cleared = False
            if changes_path.is_file() and hashlib.sha256(changes_path.read_bytes()).hexdigest() == plan["changesSha256"]:
                draft = _read(changes_path)
                draft["entries"] = []
                draft.pop("version", None)
                snapshot.add_file(changes_path)
                _write(changes_path, draft)
                cleared = True
        except Exception as error:
            try:
                snapshot.restore()
            except Exception as restore_error:
                raise SourceError(f"Adoption failed ({error}); resource rollback also failed: {restore_error}. Preserve the workspace for repair.") from error
            raise SourceError(f"Adoption failed; original language files and pins were restored: {error}") from error
    return {"status": "adopted", "revision": revision, "targets": len(plan["targets"]),
            "draftCleared": cleared, "gitCommitted": False, "gitPushed": False}


def main(argv=None):
    parser = argparse.ArgumentParser(description=__doc__)
    actions = parser.add_subparsers(dest="action", required=True)
    prepare = actions.add_parser("prepare", help="Prepare a temporary Ln18 update and archive; do not publish")
    prepare.add_argument("--consumer-root", type=Path, default=Path.cwd())
    prepare.add_argument("--changes", type=Path)
    prepare.add_argument("--workspace", type=Path)
    prepare.add_argument("--sdk-root", type=Path)
    prepare.add_argument("--package-directory")
    adopt = actions.add_parser("adopt", help="Verify the published archive after user-confirmed publication, update pins, generate and check")
    adopt.add_argument("--plan", type=Path, required=True)
    adopt.add_argument("--revision", help="Full remote commit SHA; defaults to the currently published HEAD")
    adopt.add_argument("--dry-run", action="store_true")
    check = actions.add_parser("check", help="Verify this consumer against its existing pinned source")
    check.add_argument("--consumer-root", type=Path, default=Path.cwd())
    check.add_argument("--offline", action="store_true")
    check.add_argument("--cache-dir", type=Path)
    arguments = parser.parse_args(argv)
    if arguments.action == "prepare":
        from l10n_prepare import prepare_update
        plan_path = prepare_update(arguments.consumer_root, changes_path=arguments.changes,
                                   workspace=arguments.workspace, sdk_root=arguments.sdk_root,
                                   package_directory=arguments.package_directory)
        print(f"Prepared language update plan: {plan_path}")
        print("Next: Codex presents the prepared changes, validation results and repository publication scope, then pauses for your confirmation.")
        print("After confirmation, Codex commits/pushes Ln18, verifies the remote revision and continues with adopt --plan using this path. You do not need to operate Git.")
    elif arguments.action == "adopt":
        print(json.dumps(adopt_update(arguments.plan, revision=arguments.revision, dry_run=arguments.dry_run), ensure_ascii=False, indent=2))
    else:
        root = arguments.consumer_root.expanduser().resolve()
        renderer = _read(root / "l10n.resources.json").get("renderer")
        if renderer not in {"mobile", "pc", "sdk"}:
            raise SourceError("Unknown consumer renderer.")
        _sync(root, renderer, check=True, offline=arguments.offline, cache_dir=arguments.cache_dir)


if __name__ == "__main__":
    try:
        main()
    except (SourceError, OSError, ValueError, subprocess.CalledProcessError) as error:
        print(f"Language update failed: {error}", file=sys.stderr)
        raise SystemExit(1)
