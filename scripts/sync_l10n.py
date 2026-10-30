#!/usr/bin/env python3
"""Fetch the pinned remote catalog and regenerate SDK language resources.

Normal SDK builds consume the checked-in generated files and do not require
the catalog checkout. This command is for maintainers updating translations.
"""
import argparse
import json
import os
import shutil
import subprocess
import sys
from pathlib import Path

sys.dont_write_bytecode = True
from l10n_source import SourceError, add_source_arguments, ensure_dart_dependencies, resolve_catalog


def require_executable(value, label):
    resolved = shutil.which(str(Path(value).expanduser()))
    if not resolved:
        raise SourceError(f"{label} executable not found: {value}")
    return str(Path(resolved).resolve())


def flutter_tool(root, override):
    expected = (root / ".flutter-version").read_text().strip()
    configured = override or os.environ.get("FLUTTER_BIN")
    if configured:
        executable = str(configured)
    else:
        candidates = [root / ".fvm/flutter_sdk/bin/flutter",
                      Path.home() / f"fvm/versions/{expected}/bin/flutter"]
        executable = next((str(path) for path in candidates if path.is_file()),
                          shutil.which("flutter"))
    if not executable:
        raise SourceError(f"Flutter {expected} is required; set FLUTTER_BIN or --flutter.")
    executable = require_executable(executable, "Flutter")
    result = subprocess.run([executable, "--no-version-check", "--version", "--machine"],
                            check=True, capture_output=True, text=True)
    actual = json.loads(result.stdout).get("frameworkVersion")
    if actual != expected:
        raise SourceError(f"Flutter version mismatch: expected {expected}, found {actual}.")
    return executable


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    add_source_arguments(parser)
    parser.add_argument("--check", action="store_true", help="Check committed outputs without changing files")
    parser.add_argument("--dart", help="Dart executable used by the shared ARB selector")
    parser.add_argument("--flutter", help="Flutter executable; must match .flutter-version")
    args = parser.parse_args()
    root = Path(__file__).resolve().parents[1]
    flutter = flutter_tool(root, args.flutter)
    dart = require_executable(args.dart or str(Path(flutter).parent / ("dart.bat" if os.name == "nt" else "dart")), "Dart")
    catalog = resolve_catalog(root, args.catalog_root, cache_dir=args.cache_dir, offline=args.offline)
    ensure_dart_dependencies(catalog, dart, offline=args.offline)
    command = [sys.executable, str(catalog / "tools/sync.py"), "--consumer-root", str(root), "--dart", dart]
    if args.check:
        command.append("--check")
    subprocess.run(command, check=True)
    if not args.check:
        subprocess.run([flutter, "--no-version-check", "gen-l10n"], cwd=root / "packages/im_sdk", check=True)


if __name__ == "__main__":
    try:
        main()
    except (SourceError, OSError, ValueError, subprocess.CalledProcessError) as error:
        print(f"SDK language sync failed: {error}", file=sys.stderr)
        raise SystemExit(1)
