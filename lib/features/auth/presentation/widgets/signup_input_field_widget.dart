import 'package:attend/global/constants/colors.dart';
import 'package:attend/global/constants/text_styles.dart';
import 'package:flutter/material.dart';

class SignupInputFieldWidget extends StatefulWidget {
  final String label;
  final String hint;
  final TextInputType? keyboardType;
  final bool isPassword;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final TextEditingController? controller;

  const SignupInputFieldWidget({
    super.key,
    required this.label,
    required this.hint,
    this.keyboardType,
    this.isPassword = false,
    this.validator,
    this.onChanged,
    this.controller,
  });

  @override
  State<SignupInputFieldWidget> createState() => SignupInputFieldWidgetState();
}

class SignupInputFieldWidgetState extends State<SignupInputFieldWidget> {
  bool _obscure = true; // initial hidden state
  String? _errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label, style: AppTextStyles.inputLabel),
        SizedBox(height: 8),
        TextFormField(
          keyboardType: widget.keyboardType,
          obscureText: widget.isPassword ? _obscure : false,

          onChanged: (value) {
            setState(() {
              _errorText = widget.validator?.call(value);
            });
            widget.onChanged?.call(value);
          },
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTextStyles.inputHint,
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: AppColors.primary.withOpacity(0.3),
                width: 2,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.accent, width: 3),
            ),
            errorText: _errorText,
            errorStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.error,
              fontSize: 13,
            ),
            focusedErrorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.error, width: 3),
            ),
            errorBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),

            contentPadding: EdgeInsets.symmetric(vertical: 12),

            suffixIcon:
                widget.isPassword
                    ? IconButton(
                      icon: Icon(
                        _obscure
                            ? Icons.visibility_off_rounded
                            : Icons.visibility_rounded,
                        color: AppColors.textPrimary.withOpacity(0.6),
                      ),
                      onPressed: () {
                        setState(() => _obscure = !_obscure);
                      },
                    )
                    : null,
          ),
          controller: widget.controller,
        ),
      ],
    );
  }
}
