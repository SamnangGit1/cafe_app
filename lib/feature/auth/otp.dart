import 'package:cafe_app/shared/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:async';

import 'package:google_fonts/google_fonts.dart';

class OtpDialog extends StatefulWidget {
  const OtpDialog({super.key, required this.phone, required this.onResend});

  final String phone;
  final Future<void> Function() onResend;

  @override
  State<OtpDialog> createState() => _OtpDialogState();
}

class _OtpDialogState extends State<OtpDialog> {
  static const _length = 6;
  static const _resendSeconds = 60;

  late final List<TextEditingController> _controllers =
      List.generate(_length, (_) => TextEditingController());
  late final List<FocusNode> _focusNodes =
      List.generate(_length, (_) => FocusNode());

  Timer? _timer;
  int _secondsLeft = _resendSeconds;
  bool _resending = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _secondsLeft = _resendSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_secondsLeft == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  String get _code => _controllers.map((c) => c.text).join();

  void _onChanged(int index, String value) {
    if (value.isNotEmpty && index < _length - 1) {
      _focusNodes[index + 1].requestFocus();
    }
    if (_error != null) {
      setState(() => _error = null);
    } else {
      setState(() {});
    }
    if (_code.length == _length) {
      FocusScope.of(context).unfocus();
    }
  }

  void _onBackspace(int index) {
    if (index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
      setState(() {});
    }
  }

  Future<void> _resend() async {
    if (_secondsLeft > 0 || _resending) return;
    setState(() => _resending = true);
    try {
      await widget.onResend();
      _startTimer();
      for (final c in _controllers) {
        c.clear();
      }
      _focusNodes.first.requestFocus();
    } catch (_) {
      setState(() => _error = 'Could not resend code. Try again.');
    } finally {
      if (mounted) setState(() => _resending = false);
    }
  }

  void _submit() {
    if (_code.length < _length) {
      setState(() => _error = 'Enter the full 6-digit code.');
      return;
    }
    Navigator.pop(context, _code);
  }

  String _maskedPhone(String phone) {
    if (phone.length <= 4) return phone;
    final visible = phone.substring(phone.length - 4);
    return '••• ••• $visible';
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
        decoration: BoxDecoration(
          color: AppColors.cream,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: AppColors.espresso.withOpacity(0.15),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.caramel,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.sms_outlined, color: AppColors.espresso, size: 30),
            ),
            const SizedBox(height: 20),
            Text(
              'Verify your phone',
              style: GoogleFonts.fraunces(
                color: AppColors.espresso,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Enter the 6-digit code sent to\n${_maskedPhone(widget.phone)}',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: AppColors.clay, fontSize: 14, height: 1.4),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_length, (index) {
                return Padding(
                  padding: EdgeInsets.only(right: index == _length - 1 ? 0 : 8),
                  child: _otpBox(index),
                );
              }),
            ),
            if (_error != null) ...[
              const SizedBox(height: 12),
              Text(_error!, style: GoogleFonts.inter(color: AppColors.danger, fontSize: 13)),
            ],
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.espresso,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(
                  'Verify',
                  style: GoogleFonts.inter(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Didn't get the code? ", style: GoogleFonts.inter(color: AppColors.clay, fontSize: 13)),
                GestureDetector(
                  onTap: _secondsLeft == 0 && !_resending ? _resend : null,
                  child: Text(
                    _resending
                        ? 'Sending...'
                        : (_secondsLeft > 0 ? 'Resend in ${_secondsLeft}s' : 'Resend'),
                    style: GoogleFonts.inter(
                      color: _secondsLeft == 0 ? AppColors.mocha : AppColors.clay.withOpacity(0.5),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      decoration: _secondsLeft == 0 ? TextDecoration.underline : null,
                      decorationColor: AppColors.mocha,
                    ),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: GoogleFonts.inter(color: AppColors.clay, fontSize: 14)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _otpBox(int index) {
    final filled = _controllers[index].text.isNotEmpty;
    return SizedBox(
      width: 44,
      height: 52,
      child: Focus(
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.backspace &&
              _controllers[index].text.isEmpty) {
            _onBackspace(index);
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
        },
        child: TextField(
          controller: _controllers[index],
          focusNode: _focusNodes[index],
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: GoogleFonts.inter(
            color: AppColors.espresso,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: AppColors.white,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.sand, width: 1.2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: filled ? AppColors.caramel : AppColors.sand,
                width: 1.4,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.caramel, width: 1.8),
            ),
          ),
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChanged: (value) => _onChanged(index, value),
        ),
      ),
    );
  }
}