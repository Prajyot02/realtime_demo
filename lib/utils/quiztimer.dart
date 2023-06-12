import 'dart:async';

class QuizTimer {
  late Timer _timer;
  late int _secondsRemaining;

  void startTimer(int durationInSeconds, Function onTimerFinished) {
    _secondsRemaining = durationInSeconds;

    // Start the timer
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      _secondsRemaining--;

      // Check if the timer has finished
      if (_secondsRemaining <= 0) {
        // Cancel the timer
        _timer.cancel();

        // Execute the callback function when the timer finishes
        onTimerFinished();
      }
    });
  }

  void cancelTimer() {
    // Cancel the timer if it is running
    if (_timer.isActive) {
      _timer.cancel();
    }
  }

  int get secondsRemaining => _secondsRemaining;
}
