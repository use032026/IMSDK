/// Coverage of the server sequence windows observed in this direct chat.
/// Sparse history pages can certify a range even when some seqs have no row.
class DirectHistoryCoverage {
  final List<({int first, int last})> _windows = [];

  ({int first, int last})? get firstGap {
    if (_windows.length < 2) return null;
    return (first: _windows[0].last + 1, last: _windows[1].first - 1);
  }

  void observe(int sequence) => cover(sequence, sequence);

  void discardThrough(int sequence) {
    if (_windows.isEmpty || _windows.first.first > sequence) return;
    _windows.removeWhere((window) => window.last <= sequence);
    if (_windows.isNotEmpty && _windows.first.first <= sequence) {
      _windows[0] = (first: sequence, last: _windows.first.last);
    } else {
      cover(sequence, sequence);
    }
  }

  void cover(int first, int last) {
    if (first <= 0 || first > last) return;
    var index = 0;
    while (index < _windows.length && _windows[index].last + 1 < first) {
      index++;
    }
    while (index < _windows.length && _windows[index].first <= last + 1) {
      final window = _windows.removeAt(index);
      if (window.first < first) first = window.first;
      if (window.last > last) last = window.last;
    }
    _windows.insert(index, (first: first, last: last));
  }

  int boundRead(int displayedSeq) {
    final gap = firstGap;
    return gap != null && displayedSeq >= gap.first
        ? gap.first - 1
        : displayedSeq;
  }
}
