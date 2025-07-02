import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

ScaffoldFeatureController<SnackBar, SnackBarClosedReason> showMsg(
    BuildContext context, String text) {
  return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    content: Text(text, style: Theme.of(context).textTheme.bodyMedium),
    backgroundColor: AppColors.primary,
  ));
}
