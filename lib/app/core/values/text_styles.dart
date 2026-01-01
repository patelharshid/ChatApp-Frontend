import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:flutter/material.dart';

const errorTextStyle = TextStyle(
  fontSize: 15,
  fontWeight: FontWeight.w400,
  color: AppColors.errorColor,
);

const labelStyle = TextStyle(
  fontSize: 22,
  fontWeight: FontWeight.w500,
  height: 1.8,
  color: AppColors.colorWhite,
);

const whiteStyleThirtyFive = TextStyle(
  fontSize: 35,
  fontWeight: FontWeight.bold,
  height: 1,
  color: AppColors.colorWhite,
);

const whiteStyleFourteen = TextStyle(
  fontSize: 14,
  height: 1.5,
  color: AppColors.lightText,
);

final labelStyleLetterSpacing = labelStyle.copyWith(letterSpacing: 2);
