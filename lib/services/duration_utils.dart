class DurationUtils {
  static ago(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays > 365) {
      return "${diff.inDays ~/ 365} years ago";
    } else if (diff.inDays > 30) {
      return "${diff.inDays ~/ 30} months ago";
    } else if (diff.inDays > 7) {
      return "${diff.inDays ~/ 7} weeks ago";
    } else if (diff.inDays > 1) {
      return "${diff.inDays} days ago";
    } else if (diff.inHours > 1) {
      return "${diff.inHours} hours ago";
    } else if (diff.inMinutes > 1) {
      return "${diff.inMinutes} minutes ago";
    } else if (diff.inSeconds > 1) {
      return "${diff.inSeconds} seconds ago";
    } else {
      return "just now";
    }
  }
}
