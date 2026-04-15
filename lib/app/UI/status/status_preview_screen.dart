import 'dart:io';
import 'package:chatapp/app/core/widget/profile_avatar.dart';
import 'package:chatapp/app/data/repository/status_repo.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/app/core/services/common_service.dart';
import 'package:chatapp/app/core/values/app_colors.dart';

class StatusPreviewScreen extends StatefulWidget {
  final File imageFile;

  const StatusPreviewScreen({super.key, required this.imageFile});

  @override
  State<StatusPreviewScreen> createState() => _StatusPreviewScreenState();
}

class _StatusPreviewScreenState extends State<StatusPreviewScreen> {
  final TextEditingController _captionController = TextEditingController();
  final StatusRepo _repo = StatusRepo();

  String? profileUrl;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    final url = await CommonService.getProfileUrl();

    if (!mounted) return;

    setState(() {
      profileUrl = url;
    });
  }

  Future<void> _sendStatus() async {
    final caption = _captionController.text.trim();
    try {
      await _repo.saveStatus(
        contentUrl: widget.imageFile.path,
        caption: caption,
      );

      Navigator.pop(context, true);
    } catch (e) {
      print("Error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      body: Stack(
        children: [
          Center(child: Image.file(widget.imageFile, fit: BoxFit.contain)),

          Positioned(
            top: 40,
            left: 10,
            right: 10,
            child: Row(
              children: [
                ProfileAvatar(imageUrl: profileUrl),

                const SizedBox(width: 10),

                const Expanded(
                  child: Text(
                    "My Status",
                    style: TextStyle(
                      color: AppColors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                IconButton(
                  icon: const Icon(Icons.close, color: AppColors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 20,
            left: 10,
            right: 10,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: TextField(
                      controller: _captionController,
                      style: const TextStyle(color: AppColors.white),
                      decoration: const InputDecoration(
                        hintText: "Add a caption...",
                        hintStyle: TextStyle(color: AppColors.lightText),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 10),

                CircleAvatar(
                  radius: 26,
                  backgroundColor: AppColors.primary,
                  child: IconButton(
                    icon: const Icon(Icons.send, color: AppColors.black),
                    onPressed: _sendStatus,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
