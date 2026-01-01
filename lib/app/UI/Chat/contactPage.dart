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
      appBar: AppBar(
        title: selectedIndexes.isEmpty
            ? const Text("Select Contact")
            : Text("${selectedIndexes.length} selected"),

        leading: selectedIndexes.isEmpty
            ? null
            : IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    selectedIndexes.clear();
                  });
                },
              ),

        actions: selectedIndexes.isEmpty
            ? []
            : [
                IconButton(
                  icon: const Icon(Icons.group_add),
                  onPressed: selectedIndexes.length < 2
                      ? null
                      : () {
                          final selectedUsers = selectedIndexes
                              .map((i) => users[i])
                              .toList();

                          print("Create group with: $selectedUsers");
                        },
                ),
              ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length + 2,
              itemBuilder: (context, index) {
                if (index == 0) {
                  return ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Icon(Icons.group_add, color: Colors.white),
                    ),
                    title: const Text(
                      "New Group",
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    onTap: () {},
                  );
                }

                if (index == 1) {
                  return const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    child: Text(
                      "Contacts on WhatsApp",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey,
                      ),
                    ),
                  );
                }

                final userIndex = index - 2;
                final user = users[userIndex];
                final isSelected = selectedIndexes.contains(userIndex);

                return ListTile(
                  tileColor: isSelected ? Colors.green.withOpacity(0.15) : null,
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        backgroundImage: user.profileUrl != null
                            ? NetworkImage(user.profileUrl!)
                            : null,
                        child: user.profileUrl == null
                            ? const Icon(Icons.person)
                            : null,
                      ),

                      if (isSelected)
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.green,
                            child: const Icon(
                              Icons.check,
                              size: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                    ],
                  ),

                  title: Text(user.name ?? ""),
                  subtitle: Text(user.about ?? ""),

                  onTap: () {
                    if (selectedIndexes.isNotEmpty) {
                      setState(() {
                        if (isSelected) {
                          selectedIndexes.remove(userIndex);
                        } else {
                          selectedIndexes.add(userIndex);
                        }
                      });
                    } else {
                      print("Open chat with ${user.name}");
                    }
                  },

                  onLongPress: () {
                    setState(() {
                      selectedIndexes.add(userIndex);
                    });
                  },
                );
              },
            ),
    );
  }
}
