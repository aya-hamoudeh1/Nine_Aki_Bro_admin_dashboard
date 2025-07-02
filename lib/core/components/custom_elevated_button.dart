import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

class CustomElevatedButton extends StatelessWidget {
  const CustomElevatedButton({
    super.key,
    this.width,
    this.height,
    required this.child,
    required this.onPressed,
  });

  final double? width;
  final double? height;
  final Widget child;
  final VoidCallback? onPressed;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.white,
        ),
        onPressed: onPressed,
        child: child,
      ),
    );
  }
}
