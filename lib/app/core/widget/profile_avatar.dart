import 'dart:io';
import 'package:flutter/material.dart';
import 'package:chatapp/app/core/values/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double radius;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.radius = 22,
  });

  @override
  Widget build(BuildContext context) {
    if (imageUrl == null || imageUrl!.isEmpty) {
      return CircleAvatar(
        radius: radius,
        backgroundColor: AppColors.grey,
        child: const Icon(Icons.person, color: AppColors.white),
      );
    }

    final ImageProvider imageProvider =
        imageUrl!.startsWith("http")
            ? NetworkImage(imageUrl!)
            : FileImage(File(imageUrl!));

    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.grey,
      backgroundImage: imageProvider,
    );
  }
}