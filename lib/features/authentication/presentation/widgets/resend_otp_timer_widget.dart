import 'dart:async';
import 'package:flutter/material.dart';

class ResendOtpTimer extends StatefulWidget {
  final int initialTime;
  final VoidCallback onResend;

  const ResendOtpTimer({
    super.key,
    required this.initialTime,
    required this.onResend,
  });

  @override
  ResendOtpTimerState createState() => ResendOtpTimerState();
}

class ResendOtpTimerState extends State<ResendOtpTimer> {
  late Timer _timer;
  late int _remainingTime;
  bool _isResendButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _remainingTime = widget.initialTime;
    _startTimer();
  }

  void _startTimer() {
    setState(() {
      _isResendButtonEnabled = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingTime > 0) {
          _remainingTime--;
        } else {
          _isResendButtonEnabled = true;
          _timer.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _handleResend() {
    widget.onResend();
    _remainingTime = widget.initialTime;
    _startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          _isResendButtonEnabled
              ? "You can resend OTP now"
              : "Resend OTP in $_remainingTime seconds",
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: _isResendButtonEnabled ? _handleResend : null,
          child: Text("Resend OTP"),
        ),
      ],
    );
  }
}
