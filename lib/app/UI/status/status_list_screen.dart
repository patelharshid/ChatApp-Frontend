import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'package:chatapp/app/UI/status/status_view_screen.dart';
import 'package:chatapp/app/UI/status/status_preview_screen.dart';
import 'package:chatapp/app/core/helper/date_util.dart';
import 'package:chatapp/app/core/services/common_service.dart';
import 'package:chatapp/app/core/widget/profile_avatar.dart';
import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:chatapp/app/core/values/app_constants.dart';
import 'package:chatapp/app/data/model/status_detail_model.dart';
import 'package:chatapp/app/data/repository/status_repo.dart';

class StatusListScreen extends StatefulWidget {
  const StatusListScreen({super.key});

  @override
  State<StatusListScreen> createState() => _StatusListScreenState();
}

class _StatusListScreenState extends State<StatusListScreen> {
  String? profileUrl;

  final StatusRepo _repo = StatusRepo();
  final ImagePicker _picker = ImagePicker();

  List<StatusDetailModel> statusList = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _loadStatus();
  }

  Future<void> _loadStatus() async {
    try {
      final res = await _repo.getAllStatus();

      if (!mounted) return;

      setState(() {
        statusList = res;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Future<void> _loadProfile() async {
    final url = await CommonService.getProfileUrl();
    setState(() {
      profileUrl = url;
    });
  }

  @override
  Widget build(BuildContext context) {
    final myStatus = statusList.where((e) => e.isMe).toList();
    final otherStatus = statusList.where((e) => !e.isMe).toList();

    Map<int, List<StatusDetailModel>> groupedStatus = {};
    for (var status in otherStatus) {
      groupedStatus.putIfAbsent(status.userId, () => []);
      groupedStatus[status.userId]!.add(status);
    }

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          )
        : ListView(
            children: [
              ListTile(
                leading: Stack(
                  alignment: Alignment.center,
                  children: [
                    if (myStatus.isNotEmpty)
                      CustomPaint(
                        size: const Size(50, 50),
                        painter: StatusBorderPainter(
                          total: myStatus.length,
                          viewedCount: myStatus.where((e) => e.isViewed).length,
                        ),
                      ),

                    CircleAvatar(
                      radius: 22,
                      backgroundImage: myStatus.isNotEmpty
                          ? (myStatus.first.contentUrl.startsWith("http")
                                ? NetworkImage(myStatus.first.contentUrl)
                                : FileImage(File(myStatus.first.contentUrl))
                                      as ImageProvider)
                          : null,
                      child: myStatus.isEmpty
                          ? ProfileAvatar(imageUrl: profileUrl)
                          : null,
                    ),

                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.add,
                          size: 14,
                          color: AppColors.black,
                        ),
                      ),
                    ),
                  ],
                ),
                title: const Text(
                  "My Status",
                  style: TextStyle(color: AppColors.white),
                ),
                subtitle: Text(
                  myStatus.isNotEmpty
                      ? DateUtil.formatTime(myStatus.first.createdDate)
                      : "Tap to add status update",
                  style: const TextStyle(color: AppColors.lightText),
                ),
                onTap: () {
                  if (myStatus.isNotEmpty) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => StatusViewScreen(statusList: myStatus),
                      ),
                    );
                  } else {
                    _showStatusOptions();
                  }
                },
              ),

              const SizedBox(height: AppConstants.heightSM),

              if (groupedStatus.isNotEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingMD,
                  ),
                  child: Text(
                    "Recent updates",
                    style: TextStyle(
                      color: AppColors.lightText,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

              const SizedBox(height: 10),

              ...groupedStatus.entries.map((entry) {
                final userStatuses = entry.value;
                final firstStatus = userStatuses.first;

                return ListTile(
                  leading: Stack(
                    alignment: Alignment.center,
                    children: [
                      CustomPaint(
                        size: const Size(50, 50),
                        painter: StatusBorderPainter(
                          total: userStatuses.length,
                          viewedCount: userStatuses
                              .where((e) => e.isViewed)
                              .length,
                        ),
                      ),

                      CircleAvatar(
                        radius: 22,
                        backgroundImage:
                            firstStatus.contentUrl.startsWith("http")
                            ? NetworkImage(firstStatus.contentUrl)
                            : FileImage(File(firstStatus.contentUrl))
                                  as ImageProvider,
                      ),
                    ],
                  ),
                  title: Text(
                    firstStatus.userName,
                    style: const TextStyle(color: AppColors.white),
                  ),
                  subtitle: Text(
                    DateUtil.formatTime(firstStatus.createdDate),
                    style: const TextStyle(color: AppColors.lightText),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            StatusViewScreen(statusList: userStatuses),
                      ),
                    );
                  },
                );
              }),
            ],
          );
  }

  void _showStatusOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusMD),
        ),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 10),

              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColors.white),
                title: const Text(
                  "Camera",
                  style: TextStyle(color: AppColors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _openCamera();
                },
              ),

              ListTile(
                leading: const Icon(Icons.photo, color: AppColors.white),
                title: const Text(
                  "Gallery",
                  style: TextStyle(color: AppColors.white),
                ),
                onTap: () {
                  Navigator.pop(context);
                  _openGallery();
                },
              ),

              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openCamera() async {
    final image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StatusPreviewScreen(imageFile: File(image.path)),
        ),
      );
    }
  }

  Future<void> _openGallery() async {
    final image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => StatusPreviewScreen(imageFile: File(image.path)),
        ),
      );
    }
  }
}

class StatusBorderPainter extends CustomPainter {
  final int total;
  final int viewedCount;

  StatusBorderPainter({required this.total, required this.viewedCount});

  @override
  void paint(Canvas canvas, Size size) {
    final strokeWidth = 2.0;
    final radius = size.width / 2;

    final rect = Rect.fromCircle(
      center: Offset(radius, radius),
      radius: radius,
    );

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    if (total == 1) {
      paint.color = viewedCount == 1 ? Colors.grey : Colors.green;

      canvas.drawArc(rect, 0, 2 * 3.14, false, paint);
      return;
    }

    double startAngle = -90 * (3.14 / 180);
    final sweep = (2 * 3.14) / total;

    for (int i = 0; i < total; i++) {
      paint.color = i < viewedCount ? Colors.grey : Colors.green;

      canvas.drawArc(rect, startAngle, sweep - 0.1, false, paint);

      startAngle += sweep;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
