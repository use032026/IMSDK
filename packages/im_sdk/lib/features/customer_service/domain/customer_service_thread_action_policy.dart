enum CustomerServiceThreadPrimaryAction {
  claim,
  waitForAutomaticAssignment,
  takeover,
  open,
  view,
}

/// Resolves the primary workbench action without coupling business state to
/// button copy in the presentation layer.
CustomerServiceThreadPrimaryAction resolveCustomerServiceThreadPrimaryAction({
  required bool isTerminal,
  required bool isQueued,
  required bool isAiHandled,
  required bool automaticAssignmentEnabled,
}) {
  if (isTerminal) return CustomerServiceThreadPrimaryAction.view;
  if (isQueued) {
    return automaticAssignmentEnabled
        ? CustomerServiceThreadPrimaryAction.waitForAutomaticAssignment
        : CustomerServiceThreadPrimaryAction.claim;
  }
  if (isAiHandled) return CustomerServiceThreadPrimaryAction.takeover;
  return CustomerServiceThreadPrimaryAction.open;
}
