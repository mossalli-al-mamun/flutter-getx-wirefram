import 'dart:async';
import 'dart:ui';

class TimerUtils {
  final int initialSeconds;
  final VoidCallback? onTimerComplete;
  late int _secondsRemaining;
  Timer? _timer;

  final StreamController<int> _controller = StreamController<int>.broadcast();
  Stream<int> get stream => _controller.stream;

  TimerUtils({this.initialSeconds = 60, this.onTimerComplete}) {
    _secondsRemaining = initialSeconds;
  }

  void start() {
    _secondsRemaining = initialSeconds;
    _controller.add(_secondsRemaining);

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _secondsRemaining--;
      _controller.add(_secondsRemaining);

      if (_secondsRemaining <= 0) {
        stop();
        if (onTimerComplete != null) {
          onTimerComplete!();
        }
      }
    });
  }

  void stop() {
    _timer?.cancel();
    if (!_controller.isClosed) {
      _controller.close();
    }
  }

  void reset() {
    stop();
    _secondsRemaining = initialSeconds;
  }

  int get secondsRemaining => _secondsRemaining;
}