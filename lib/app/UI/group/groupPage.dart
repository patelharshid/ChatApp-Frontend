import 'package:chatapp/app/UI/auth/homePage.dart';
import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:chatapp/app/data/model/user_detail_model.dart';
import 'package:chatapp/app/data/repository/login_repo.dart';
import 'package:flutter/material.dart';

class GroupPage extends StatefulWidget {
  const GroupPage({super.key});

  @override
  State<GroupPage> createState() => _GroupPageState();
}

class _GroupPageState extends State<GroupPage> {
  final LoginRepo _repo = LoginRepo();

  bool isLoading = true;
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
                              ? const Icon(
                                  Icons.person,
                                  color: AppColors.colorWhite,
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
                      user.name ?? "",
                      style: const TextStyle(
                        color: AppColors.colorWhite,
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
            ? AppColors.colorGrey
            : AppColors.primary,
        elevation: 3,

        onPressed: selectedIndexes.isEmpty
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Homepage()),
                );
              },

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
