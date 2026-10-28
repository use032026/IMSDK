/// Server-controlled presentation mode for a release channel.
///
/// Unknown values and request failures must resolve to [isA] so optional
/// release-gated actions remain unavailable until the server explicitly
/// enables the full face.
enum AppReleaseFace { isA, isB }
