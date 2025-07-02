import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../constants/app_colors.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    required this.labelText,
    this.isPassword = false,
    this.obscureText = false,
    this.onPressed,
    this.onChanged,
    this.inputFormatters,
  });

  final String labelText;
  final TextEditingController? controller;
  final bool isPassword;
  final bool obscureText; // ✅ الحالة الحقيقية للإخفاء
  final void Function()? onPressed;
  final void Function(String)? onChanged;
  final List<TextInputFormatter>? inputFormatters;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      inputFormatters: inputFormatters,
      onChanged: onChanged,
      validator: (value) {
        if (value!.isEmpty) {
          return 'This field cannot be empty';
        }
        return null;
      },
      obscureText: obscureText, // ✅ بدل isPassword
      cursorColor: AppColors.borderPrimary,
      controller: controller,
      decoration: InputDecoration(
        suffixIcon: isPassword
            ? IconButton(
          onPressed: onPressed,
          icon: Icon(
            obscureText
                ? Icons.visibility_off_outlined
                : Icons.remove_red_eye_outlined,
          ),
        )
            : null,
        labelText: labelText,
        labelStyle: const TextStyle(color: AppColors.grey),
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.borderPrimary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.borderPrimary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: AppColors.borderPrimary,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
