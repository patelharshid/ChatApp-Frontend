import 'package:chatapp/app/UI/auth/homePage.dart';
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
      appBar: AppBar(
        title: selectedIndexes.isEmpty
            ? const Text("Group contact")
            : Text("${selectedIndexes.length} selected"),
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
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                final isSelected = selectedIndexes.contains(index);

                return ListTile(
                  tileColor: isSelected ? Colors.green.withOpacity(0.12) : null,

                  leading: CircleAvatar(
                    backgroundImage: user.profileUrl != null
                        ? NetworkImage(user.profileUrl!)
                        : null,
                    child: user.profileUrl == null
                        ? const Icon(Icons.person)
                        : null,
                  ),

                  title: Text(
                    user.name ?? "",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),

                  subtitle: Text(user.about ?? ""),

                  trailing: CircleAvatar(
                    radius: 12,
                    backgroundColor: isSelected
                        ? Colors.green
                        : Colors.grey.shade300,
                    child: isSelected
                        ? const Icon(Icons.check, size: 16, color: Colors.white)
                        : null,
                  ),

                  onTap: () {
                    setState(() {
                      if (isSelected) {
                        selectedIndexes.remove(index);
                      } else {
                        selectedIndexes.add(index);
                      }
                    });
                  },
                );
              },
            ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: selectedIndexes.isEmpty ? Colors.grey : Colors.blue,
        onPressed: selectedIndexes.isEmpty
            ? null
            : () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const Homepage()),
                );
              },
        child: Icon(
          Icons.send,
          color: selectedIndexes.isEmpty ? Colors.black38 : Colors.white,
        ),
      ),
    );
  }
}
