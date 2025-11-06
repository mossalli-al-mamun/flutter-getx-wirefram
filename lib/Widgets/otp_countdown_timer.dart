import 'package:flutter/material.dart';
import '../Controller/locale/localization_service_controller.dart';
import '../Utils/timer_utils.dart';

class OtpCountdownTimer extends StatefulWidget {
  final int initialSeconds;
  final VoidCallback? onTimerComplete;

  const OtpCountdownTimer(
      {super.key, required this.initialSeconds, this.onTimerComplete});

  @override
  State<OtpCountdownTimer> createState() => _TimerDisplayState();
}

class _TimerDisplayState extends State<OtpCountdownTimer> {
  late TimerUtils _timerUtils;
  late Stream<int> _timerStream;

  @override
  void initState() {
    super.initState();
    _timerUtils = TimerUtils(
      initialSeconds: widget.initialSeconds,
      onTimerComplete: widget.onTimerComplete,
    );
    _timerStream = _timerUtils.stream;
    _timerUtils.start();
  }

  @override
  void dispose() {
    _timerUtils.stop();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final mins = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return "$mins:$secs";
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _timerStream,
      initialData: widget.initialSeconds,
      builder: (context, snapshot) {
        final remaining = snapshot.data ?? 0;
        return Text(
          tr.resendCodeIn(_formatTime(remaining)),
          style: const TextStyle(fontSize: 16, height: 3.0),
        );
      },
    );
  }
}
