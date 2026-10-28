class SiteLineCandidate {
  final String id;
  final double weight;
  const SiteLineCandidate(this.id, this.weight);
}

class SiteLineProbeResult {
  final bool available;
  final int? latencyMs;
  const SiteLineProbeResult({required this.available, this.latencyMs});
}

/// Manual preference, then weighted/latency/server order with a sticky current
/// line. This is a transport decision, not an account or workspace scope.
String? chooseSiteLine(
  List<SiteLineCandidate> lines,
  Map<String, SiteLineProbeResult> probes, {
  String? manualId,
  String? currentId,
}) {
  final available =
      lines.where((line) => probes[line.id]?.available == true).toList();
  if (available.isEmpty) return null;
  if (manualId != null && available.any((line) => line.id == manualId)) {
    return manualId;
  }
  final ranked = [...available]..sort((left, right) {
      final weight = right.weight.compareTo(left.weight);
      if (weight != 0) return weight;
      final latency =
          _latency(probes[left.id]).compareTo(_latency(probes[right.id]));
      if (latency != 0) return latency;
      return lines.indexOf(left).compareTo(lines.indexOf(right));
    });
  final best = ranked.first;
  final current = available.where((line) => line.id == currentId).firstOrNull;
  if (current == null || current.id == best.id) return best.id;
  final currentLatency = probes[current.id]?.latencyMs;
  final bestLatency = probes[best.id]?.latencyMs;
  if (currentLatency == null ||
      bestLatency == null ||
      currentLatency <= bestLatency * 1.5 + 50) {
    return current.id;
  }
  return best.id;
}

int _latency(SiteLineProbeResult? probe) =>
    probe?.latencyMs != null && probe!.latencyMs! >= 0
        ? probe.latencyMs!
        : 1 << 30;
