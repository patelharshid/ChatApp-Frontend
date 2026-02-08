import 'package:flutter/material.dart';
import 'package:chatapp/app/core/values/app_colors.dart';

class ChTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final TextInputType keyboardType;
  final int? maxLength;
  final Widget? prefix;
  final bool showDivider;

  const ChTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.keyboardType = TextInputType.text,
    this.maxLength,
    this.prefix,
    this.showDivider = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF121212),
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: AppColors.colorBlack.withOpacity(0.4),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          if (prefix != null) prefix!,
          if (showDivider && prefix != null) ...[
            const SizedBox(width: 12),
            Container(height: 22, width: 1.2, color: AppColors.colorGrey),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: keyboardType,
              maxLength: maxLength,
              cursorColor: AppColors.primary,
              style: const TextStyle(color: AppColors.colorWhite),
              decoration: InputDecoration(
                counterText: "",
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: const TextStyle(color: AppColors.colorGrey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
