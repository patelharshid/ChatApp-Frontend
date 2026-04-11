import 'dart:io';

import 'package:chatapp/app/UI/auth/homePage.dart';
import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:chatapp/app/core/widget/ch_button.dart';
import 'package:chatapp/app/data/model/user_detail_model.dart';
import 'package:chatapp/app/data/repository/group_repo.dart';
import 'package:chatapp/app/data/repository/login_repo.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final LoginRepo _repo = LoginRepo();
  final GroupRepo _groupRepo = GroupRepo();

  final TextEditingController _groupNameController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  File? selectedImage;

  bool isLoading = true;
  bool isSaving = false;
  String? errorMessage;

  List<UserDetailModel> users = [];
  Set<int> selectedIndexes = {};

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    try {
      final res = await _repo.getAllUser();

      setState(() {
        users = res;
        isLoading = false;
      });
    } catch (_) {
      setState(() => isLoading = false);
    }
  }

  List<int> getSelectedUserIds() {
    return selectedIndexes.map((i) => users[i].userId).toList();
  }

  Future<void> _createGroup() async {
    try {
      setState(() {
        isSaving = true;
        errorMessage = null;
      });

      String groupImage = selectedImage != null
          ? selectedImage!.path
          : "https://cdn-icons-png.flaticon.com/512/681/681494.png";

      await _groupRepo.createGroup(
        _groupNameController.text.trim(),
        groupImage,
        getSelectedUserIds(),
      );

      Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Homepage()),
      );
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() => isSaving = false);
    }
  }

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  void _showCreateGroupDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 5,
                      width: 50,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade600,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Create New Group",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),

                    const SizedBox(height: 25),

                    GestureDetector(
                      onTap: () async {
                        final XFile? image = await _picker.pickImage(
                          source: ImageSource.gallery,
                        );

                        if (image != null) {
                          setModalState(() {
                            selectedImage = File(image.path);
                          });
                        }
                      },
                      child: Stack(
                        alignment: Alignment.bottomRight,
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundColor: AppColors.primary.withOpacity(0.2),
                            backgroundImage: selectedImage != null
                                ? FileImage(selectedImage!)
                                : null,
                            child: selectedImage == null
                                ? const Icon(
                                    Icons.groups,
                                    size: 40,
                                    color: AppColors.primary,
                                  )
                                : null,
                          ),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: const BoxDecoration(
                              color: AppColors.primary,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 25),
                    _fieldContainer(
                      child: TextField(
                        controller: _groupNameController,
                        style: const TextStyle(color: AppColors.white),
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Enter group name",
                          hintStyle: TextStyle(color: AppColors.lightText),
                        ),
                      ),
                    ),

                    const SizedBox(height: 15),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.people, color: AppColors.primary),
                        const SizedBox(width: 8),
                        Text(
                          "${selectedIndexes.length} members selected",
                          style: const TextStyle(
                            color: AppColors.lightText,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),

                    if (errorMessage != null) ...[
                      const SizedBox(height: 10),
                      Text(
                        errorMessage!,
                        style: const TextStyle(
                          color: Colors.redAccent,
                          fontSize: 13,
                        ),
                      ),
                    ],

                    const SizedBox(height: 25),

                    SizedBox(
                      width: double.infinity,
                      child: ChButton(
                        title: "Create Group",
                        isLoading: isSaving,
                        onPressed: () async {
                          if (_groupNameController.text.trim().isEmpty) {
                            setModalState(() {
                              errorMessage = "Group name required";
                            });
                            return;
                          }

                          await _createGroup();
                        },
                        backgroundColor: AppColors.primary,
                        textColor: AppColors.black,
                        radius: 14,
                      ),
                    ),
                    const SizedBox(height: 15),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        iconTheme: const IconThemeData(color: AppColors.white),
        title: Text(
          selectedIndexes.isEmpty
              ? "Add participants"
              : "${selectedIndexes.length} selected",
          style: const TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            )
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final isSelected = selectedIndexes.contains(index);

                return Container(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withOpacity(0.15)
                        : AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: Stack(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: user.profileUrl != null
                              ? (user.profileUrl!.startsWith("http")
                                        ? NetworkImage(user.profileUrl!)
                                        : FileImage(File(user.profileUrl!)))
                                    as ImageProvider
                              : null,
                          backgroundColor: AppColors.grey,
                          child: user.profileUrl == null
                              ? const Icon(
                                  Icons.person,
                                  color: AppColors.white,
                                )
                              : null,
                        ),
                        if (isSelected)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: AppColors.primary,
                              child: const Icon(
                                Icons.check,
                                size: 14,
                                color: Colors.white,
                              ),
                            ),
                          ),
                      ],
                    ),
                    title: Text(
                      user.username ?? "",
                      style: const TextStyle(
                        color: AppColors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      user.about ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(color: AppColors.lightText),
                    ),
                    onTap: () {
                      setState(() {
                        isSelected
                            ? selectedIndexes.remove(index)
                            : selectedIndexes.add(index);
                      });
                    },
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: selectedIndexes.isEmpty
            ? AppColors.grey
            : AppColors.primary,
        onPressed: selectedIndexes.isEmpty ? null : _showCreateGroupDialog,
        child: const Icon(Icons.arrow_forward),
      ),
    );
  }

  Widget _fieldContainer({
    required Widget child,
    EdgeInsets padding = const EdgeInsets.symmetric(horizontal: 14),
  }) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.primary),
      ),
      child: child,
    );
  }
}
