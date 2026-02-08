import 'package:chatapp/app/UI/auth/homePage.dart';
import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:chatapp/app/data/model/user_detail_model.dart';
import 'package:chatapp/app/data/repository/group_repo.dart';
import 'package:chatapp/app/data/repository/login_repo.dart';
import 'package:flutter/material.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final LoginRepo _repo = LoginRepo();
  final GroupRepo _groupRepo = GroupRepo();
  final TextEditingController _groupNameController = TextEditingController();

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

      await _groupRepo.createGroup(
        _groupNameController.text.trim(),
        getSelectedUserIds(),
      );

      Navigator.pop(context);

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Homepage()),
      );
    } catch (e) {
      setState(() {
        errorMessage =
            e.toString().replaceAll('Exception:', '').trim();
      });
    } finally {
      setState(() => isSaving = false);
    }
  }

  void _showCreateGroupDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return AlertDialog(
          backgroundColor: AppColors.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            "Create Group",
            style: TextStyle(
              color: AppColors.colorWhite,
              fontWeight: FontWeight.w600,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _groupNameController,
                style: const TextStyle(color: AppColors.colorWhite),
                decoration: const InputDecoration(
                  hintText: "Enter group name",
                  hintStyle: TextStyle(color: AppColors.lightText),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.lightText),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              if (errorMessage != null) ...[
                const SizedBox(height: 8),
                Text(
                  errorMessage!,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 13,
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: isSaving
                  ? null
                  : () {
                      _groupNameController.clear();
                      errorMessage = null;
                      Navigator.pop(context);
                    },
              child: const Text(
                "Cancel",
                style: TextStyle(color: AppColors.lightText),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
              ),
              onPressed: isSaving
                  ? null
                  : () async {
                      if (_groupNameController.text.trim().isEmpty) {
                        setState(() {
                          errorMessage = "Group name is required";
                        });
                        return;
                      }
                      await _createGroup();
                    },
              child: isSaving
                  ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text("Save"),
            ),
          ],
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
        iconTheme: const IconThemeData(color: AppColors.colorWhite),
        title: Text(
          selectedIndexes.isEmpty
              ? "Add participants"
              : "${selectedIndexes.length} selected",
          style: const TextStyle(
            color: AppColors.colorWhite,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const Homepage()),
            );
          },
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
                              ? NetworkImage(user.profileUrl!)
                              : null,
                          backgroundColor: AppColors.colorGrey,
                          child: user.profileUrl == null
                              ? const Icon(Icons.person,
                                  color: AppColors.colorWhite)
                              : null,
                        ),
                        if (isSelected)
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: CircleAvatar(
                              radius: 10,
                              backgroundColor: AppColors.primary,
                              child: const Icon(Icons.check,
                                  size: 14, color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                    title: Text(
                      user.username ?? "",
                      style: const TextStyle(
                        color: AppColors.colorWhite,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      user.about ?? "",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(color: AppColors.lightText),
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
            ? AppColors.colorGrey
            : AppColors.primary,
        elevation: 3,
        onPressed:
            selectedIndexes.isEmpty ? null : _showCreateGroupDialog,
        child: Icon(
          Icons.arrow_forward,
          color: selectedIndexes.isEmpty
              ? AppColors.colorBlack12
              : AppColors.colorWhite,
        ),
      ),
    );
  }
}
