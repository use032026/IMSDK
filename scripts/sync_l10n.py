#!/usr/bin/env python3
"""Regenerate language resources from the separately versioned private catalog.

Normal SDK builds consume the checked-in generated files and do not require
the catalog checkout. This command is for maintainers updating translations.
"""
import argparse
import os
import subprocess
import sys
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--catalog-root", type=Path, default=Path(os.environ.get(
        "IM_L10N_CATALOG_ROOT", str(Path.home() / "Desktop/Ln18/packages/im_l10n_catalog"))))
    parser.add_argument("--check", action="store_true", help="Check committed outputs without changing files")
    parser.add_argument("--dart", help="Dart executable used by the shared ARB selector")
    args = parser.parse_args()
    tool = args.catalog_root.expanduser().resolve() / "tools/sync.py"
    if not tool.is_file():
        parser.error("Catalog tools/sync.py not found; pass --catalog-root or IM_L10N_CATALOG_ROOT")
    command = [sys.executable, str(tool), "--consumer-root", str(Path(__file__).resolve().parents[1])]
    if args.check:
        command.append("--check")
    if args.dart:
        command += ["--dart", args.dart]
    raise SystemExit(subprocess.call(command))


if __name__ == "__main__":
    main()
