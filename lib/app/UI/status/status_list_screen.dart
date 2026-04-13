import 'dart:io';
import 'package:chatapp/app/core/helper/date_util.dart';
import 'package:chatapp/app/data/model/status_detail_model.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:chatapp/app/UI/status/status_preview_screen.dart';
import 'package:chatapp/app/core/widget/profile_avatar.dart';
import 'package:chatapp/app/data/repository/status_repo.dart';
import 'package:chatapp/app/core/services/common_service.dart';
import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:chatapp/app/core/values/app_constants.dart';

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
  @override
  Widget build(BuildContext context) {
    final myStatus = statusList.where((e) => e.isMe).toList();
    final otherStatus = statusList.where((e) => !e.isMe).toList();

    return isLoading
        ? const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          )
        : ListView(
            children: [
              ListTile(
                leading: Stack(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: myStatus.isNotEmpty && !myStatus.first.isViewed
                              ? AppColors.primary
                              : AppColors.background,
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
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
                  final myStatus = statusList.where((e) => e.isMe).toList();

                  if (myStatus.isNotEmpty) {
                    // 👁 View my status
                  } else {
                    _showStatusOptions();
                  }
                },
              ),

              const SizedBox(height: AppConstants.heightSM),

              if (otherStatus.isNotEmpty)
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

              ...otherStatus.map((status) {
                return ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: status.isViewed
                            ? AppColors.grey
                            : AppColors.primary,
                        width: 2,
                      ),
                    ),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundImage: status.contentUrl.startsWith("http")
                          ? NetworkImage(status.contentUrl)
                          : FileImage(File(status.contentUrl)) as ImageProvider,
                    ),
                  ),
                  title: Text(
                    status.userName,
                    style: const TextStyle(color: AppColors.white),
                  ),
                  subtitle: Text(
                    DateUtil.formatTime(status.createdDate),
                    style: const TextStyle(color: AppColors.lightText),
                  ),
                  onTap: () {},
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
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

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
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

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
