import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:chatapp/app/core/values/app_values.dart';
import 'package:flutter/material.dart';

class ChButton extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isDisabled;
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final double verticalPadding;
  final double radius;

  const ChButton({
    super.key,
    required this.title,
    required this.onPressed,
    this.isLoading = false,
    this.isDisabled = false,
    this.backgroundColor = AppColors.primary,
    this.textColor = AppColors.colorWhite,
    this.fontSize = AppValues.fontSize_16,
    this.verticalPadding = 14,
    this.radius = AppValues.radius_20,
  });

  @override
  Widget build(BuildContext context) {
    final bool disableButton = isDisabled || isLoading;

    return SizedBox(
      width: double.infinity,
      height: 55,
      child: ElevatedButton(
        onPressed: disableButton ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          disabledBackgroundColor: backgroundColor.withOpacity(0.6),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(radius),
          ),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: isLoading
              ? const SizedBox(
                  key: ValueKey("loader"),
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.colorBlack,
                  ),
                )
              : Text(
                  title,
                  key: const ValueKey("text"),
                  style: TextStyle(
                    fontSize: fontSize,
                    color: disableButton ? Colors.black54 : textColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
        ),
      ),
    );
  }
}
