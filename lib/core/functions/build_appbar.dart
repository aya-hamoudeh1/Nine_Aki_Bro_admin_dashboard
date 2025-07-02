import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

AppBar buildCustomAppBar(BuildContext context, String title,
    {bool isBackButton = true}) {
  return AppBar(
    centerTitle: true,
    title: Text(
      title,
      style: Theme.of(context).textTheme.headlineMedium,
    ),
    backgroundColor: AppColors.primary,
    leading: isBackButton
        ? IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new,
              color: AppColors.white,
            ),
          )
        : const SizedBox(),
  );
}
