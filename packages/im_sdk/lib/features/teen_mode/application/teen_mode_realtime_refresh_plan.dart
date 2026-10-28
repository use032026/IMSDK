class TeenModeRealtimeRefreshPlan {
  const TeenModeRealtimeRefreshPlan({
    this.refreshProfile = false,
    this.refreshSession = false,
    this.refreshGuardianCenter = false,
    this.refreshGuardianMinorSnapshots = false,
    this.refreshRequests = false,
    this.refreshFriendsAfterApprovedReplay = false,
  });

  final bool refreshProfile;
  final bool refreshSession;
  final bool refreshGuardianCenter;
  final bool refreshGuardianMinorSnapshots;
  final bool refreshRequests;
  final bool refreshFriendsAfterApprovedReplay;

  static TeenModeRealtimeRefreshPlan forEvent(
    String name, {
    required bool approved,
  }) =>
      switch (name) {
        'guardian.approval.created' => const TeenModeRealtimeRefreshPlan(
            refreshGuardianCenter: true,
          ),
        'guardian.approval.decided' => TeenModeRealtimeRefreshPlan(
            refreshProfile: true,
            refreshGuardianCenter: true,
            refreshRequests: true,
            refreshFriendsAfterApprovedReplay: approved,
          ),
        'guardian.link.changed' => const TeenModeRealtimeRefreshPlan(
            refreshProfile: true,
            refreshGuardianCenter: true,
            refreshGuardianMinorSnapshots: true,
          ),
        'teen.mode.changed' => const TeenModeRealtimeRefreshPlan(
            refreshProfile: true,
            refreshGuardianCenter: true,
            refreshGuardianMinorSnapshots: true,
          ),
        'teen.policy.changed' => const TeenModeRealtimeRefreshPlan(
            refreshProfile: true,
            refreshGuardianCenter: true,
            refreshGuardianMinorSnapshots: true,
          ),
        'teen.time.extended' => const TeenModeRealtimeRefreshPlan(
            refreshSession: true,
          ),
        _ => const TeenModeRealtimeRefreshPlan(),
      };
}
