import 'package:chatapp/app/UI/group/groupPage.dart';
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
      appBar: AppBar(title: const Text("Select Contact")),

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
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const GroupPage()),
                      );
                    },
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

                return ListTile(
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
                    ],
                  ),

                  title: Text(user.name ?? ""),
                  subtitle: Text(user.about ?? ""),

                  onTap: () {
                    print("hello");
                  },
                );
              },
            ),
    );
  }
}
