import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:chatapp/app/core/values/app_values.dart';
import 'package:flutter/material.dart';


class ChButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double verticalPadding;
  final double radius;

  const ChButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.backgroundColor = AppColors.primary,
    this.textColor = AppColors.colorWhite,
    this.fontSize = AppValues.fontSize_16,
    this.verticalPadding = AppValues.padding_10,
    this.radius = AppValues.radius_20,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          padding: EdgeInsets.symmetric(vertical: verticalPadding),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
