/// Utility methods for formatting durations into clean clock strings.
class TimeFormatter {
  TimeFormatter._();

  /// Formats total seconds into `mm:ss` format.
  static String formatMinutesSeconds(int totalSeconds) {
    final int minutes = totalSeconds ~/ 60;
    final int seconds = totalSeconds % 60;
    final String minutesStr = minutes.toString().padLeft(2, '0');
    final String secondsStr = seconds.toString().padLeft(2, '0');
    return '$minutesStr:$secondsStr';
  }
}
