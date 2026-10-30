"""Guard unpublished language drafts; shared unchanged by all consumers."""
import hashlib
import json
import os
from pathlib import Path


class PendingChangeError(RuntimeError):
    pass


def _object(path):
    try:
        value = json.loads(path.read_text(encoding="utf-8"))
    except (OSError, ValueError) as error:
        raise PendingChangeError(f"Cannot read language update input {path}: {error}") from error
    if not isinstance(value, dict):
        raise PendingChangeError(f"Language update input must be an object: {path}")
    return value


def check_pending(consumer_root):
    """Return True only for a target of the exact, unchanged in-progress plan."""
    root = Path(consumer_root).resolve()
    draft = root / "l10n.changes.json"
    pending = False
    if draft.exists():
        document = _object(draft)
        if document.get("schemaVersion") != 1 or not isinstance(document.get("entries"), list):
            raise PendingChangeError(f"Invalid language draft schema: {draft}")
        pending = bool(document["entries"])
    plan_name = os.environ.get("L10N_UPDATE_PLAN")
    authorized = False
    change_path = None
    if plan_name:
        plan = _object(Path(plan_name).expanduser().resolve())
        if plan.get("schemaVersion") != 1 or not isinstance(plan.get("targets"), list):
            raise PendingChangeError("Invalid L10N_UPDATE_PLAN; no language files were regenerated.")
        try:
            change_path = Path(plan["changesPath"]).resolve()
            unchanged = hashlib.sha256(change_path.read_bytes()).hexdigest() == plan["changesSha256"]
            authorized = any(Path(target["root"]).resolve() == root for target in plan["targets"])
        except (KeyError, TypeError, OSError) as error:
            raise PendingChangeError(f"Incomplete language update plan: {error}") from error
        if not unchanged:
            raise PendingChangeError("Language draft changed after prepare. Prepare a new plan; the draft was preserved.")
        if not authorized:
            raise PendingChangeError("This project is not a target of L10N_UPDATE_PLAN.")
    if pending and (not authorized or change_path != draft.resolve()):
        raise PendingChangeError(
            f"Unpublished language entries in {draft}. Run l10n_update.py prepare, "
            "have Codex present the change scope and pause for your confirmation, then publish Ln18 and continue with adopt. "
            "Existing generated resources were preserved."
        )
    return authorized
