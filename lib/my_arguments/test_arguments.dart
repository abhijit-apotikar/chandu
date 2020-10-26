class TestArguments {
  final testName;
  final List<Map<String, String>> testAttempt;
  final List<Map<String, bool>> reviewList;
  final int totalQue;
  final int hours;
  final int minutes;
  final int seconds;
  final int queAttempted;
  TestArguments(this.testName, this.testAttempt, this.reviewList, this.totalQue,
      this.hours, this.minutes, this.seconds, this.queAttempted);
}
