#!/usr/bin/env python3
"""Stage private test input for the debug native host, without invoking the SDK."""
import argparse
import json
import os
from pathlib import Path
import re
import shlex
import stat
import subprocess


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("input", type=Path, help="Local owner-only JSON file; never bundled in the APK")
    parser.add_argument("--kind", choices=("direct", "customer"), required=True)
    parser.add_argument("--serial", required=True)
    parser.add_argument("--adb", default="adb")
    parser.add_argument("--package", default="com.example.imsdkhost")
    parser.add_argument("--dry-run", action="store_true", help="Validate locally without touching a device")
    args = parser.parse_args()
    try:
        source = args.input
        info = source.stat()
        if source.is_symlink() or not stat.S_ISREG(info.st_mode):
            raise ValueError()
        if info.st_uid != os.getuid() or stat.S_IMODE(info.st_mode) & 0o077:
            raise ValueError()
        value = json.loads(source.read_text())
        target_key = "directTarget" if args.kind == "direct" else "customerServiceTarget"
        configuration = value.get("configuration", value.get("config"))
        payload = {
            "configuration": configuration,
            "credentials": value.get("credentials"),
            target_key: value.get(target_key),
        }
        if not all(isinstance(item, dict) and item for item in payload.values()):
            raise ValueError()
        encoded = json.dumps(payload, separators=(",", ":")).encode()
        if len(encoded) > 65536 or not re.fullmatch(r"[A-Za-z][A-Za-z0-9_.]*", args.package):
            raise ValueError()
        if args.dry_run:
            print("Private QA input validated. Only configuration, credentials and the selected target are staged.")
            return
        command = "run-as " + shlex.quote(args.package) + " sh -c " + shlex.quote(
            "umask 077; mkdir -p files; cat > files/im-sdk-qa-input.json"
        )
        result = subprocess.run(
            [args.adb, "-s", args.serial, "shell", command],
            input=encoded, capture_output=True, timeout=30,
        )
        if result.returncode:
            raise RuntimeError()
    except Exception:
        parser.exit(1, "Private QA input could not be validated or staged; sensitive details are suppressed.\n")
    print("Input staged in the debug host's private files directory. Tap Import private QA input, then use the public SDK buttons.")


if __name__ == "__main__":
    main()
