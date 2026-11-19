const Duration minimumLoaderDuration = Duration(milliseconds: 500);

Future<void> waitForMinimumLoaderDuration(DateTime startedAt) async {
  final remaining =
      minimumLoaderDuration - DateTime.now().difference(startedAt);
  if (remaining > Duration.zero) {
    await Future<void>.delayed(remaining);
  }
}
