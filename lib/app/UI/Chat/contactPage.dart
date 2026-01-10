import 'package:chatapp/app/UI/group/groupPage.dart';
import 'package:chatapp/app/core/values/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/app/data/model/user_detail_model.dart';
import 'package:chatapp/app/data/repository/login_repo.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({super.key});

  @override
  State<ContactPage> createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> {
  final LoginRepo _repo = LoginRepo();

  bool isLoading = true;
  List<UserDetailModel> users = [];

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

        iconTheme: const IconThemeData(
          color: AppColors.colorWhite,
        ),

        title: const Text(
          "Select contact",
          style: TextStyle(
            color: AppColors.colorWhite,
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
              itemCount: users.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return _newGroupTile();
                }

                if (index == 1) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    child: Text(
                      "Contacts on WhatsApp",
                      style: TextStyle(
                        color: AppColors.lightText,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  );
                }

                final user = users[index - 2];
                return _contactTile(user);
              },
            ),
    );
  }

  Widget _newGroupTile() {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const GroupPage()),
        );
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.primary,
              child: const Icon(Icons.group_add, color: AppColors.colorBlack),
            ),
            const SizedBox(width: 16),
            const Text(
              "New group",
              style: TextStyle(
                color: AppColors.colorWhite,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactTile(UserDetailModel user) {
    return InkWell(
      onTap: () {
        debugPrint("Open chat with ${user.name}");
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.colorGrey, width: 0.3),
          ),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: AppColors.colorGrey,
              backgroundImage: user.profileUrl != null
                  ? NetworkImage(user.profileUrl!)
                  : null,
              child: user.profileUrl == null
                  ? const Icon(Icons.person, color: AppColors.lightText)
                  : null,
            ),

            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    user.name ?? "",
                    style: const TextStyle(
                      color: AppColors.colorWhite,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    user.about ?? "",
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: AppColors.lightText,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
