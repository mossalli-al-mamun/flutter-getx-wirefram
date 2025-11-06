import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_getx_wireframe/Config/themes/extensions/colors_ext.dart';
import 'package:pinput/pinput.dart';

import '../Controller/locale/localization_service_controller.dart';

class OTPField extends StatelessWidget {
  final TextEditingController pinController;
  final FocusNode focusNode;
  final ValueChanged<String>? onComplete;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final VoidCallback? onTap;
  final FormFieldValidator<String>? validator;
  final bool forceErrorState;
  final int length;

  const OTPField({
    super.key,
    required this.pinController,
    required this.focusNode,
    this.onComplete,
    this.validator,
    this.forceErrorState = false,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.length = 6,
  });

  PinTheme _buildPinTheme(BuildContext context) {
    final borderColor = Theme.of(context).brightness == Brightness.light
        ? context.disabledColor
        : Colors.white70;

    return PinTheme(
      width: 48,
      height: 48,
      textStyle: const TextStyle(fontSize: 22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: borderColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = _buildPinTheme(context);
    const focusedBorderColor = Color.fromRGBO(23, 171, 144, 1);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: AutofillGroup(
        child: Pinput(
          length: length,
          controller: pinController,
          focusNode: focusNode,
          defaultPinTheme: defaultPinTheme,
          forceErrorState: forceErrorState,
          errorText: tr.otpIncorrect,
          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
          separatorBuilder: (index) => const SizedBox(width: 8),
          validator: validator,
          hapticFeedbackType: HapticFeedbackType.lightImpact,

          // Enhanced autofill configuration
          autofillHints: const [
            AutofillHints.oneTimeCode,
          ],
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],

          // Enable clipboard monitoring for faster OTP detection
          enableIMEPersonalizedLearning: false,

          onCompleted: onComplete,
          onChanged: onChanged,
          onTap: onTap,
          onSubmitted: onSubmitted,

          cursor: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                margin: const EdgeInsets.only(bottom: 9),
                width: 22,
                height: 1,
                color: context.primary,
              ),
            ],
          ),
          focusedPinTheme: defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration!.copyWith(
              border: Border.all(color: context.primary),
            ),
          ),
          submittedPinTheme: defaultPinTheme.copyWith(
            decoration: defaultPinTheme.decoration!.copyWith(
              border: Border.all(color: focusedBorderColor),
            ),
          ),
          errorPinTheme: defaultPinTheme.copyBorderWith(
            border: Border.all(color: Colors.redAccent),
          ),
        ),
      ),
    );
  }
}