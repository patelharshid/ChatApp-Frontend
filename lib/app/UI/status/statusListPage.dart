import 'package:flutter/material.dart';

class StatusListPage extends StatefulWidget {
  const StatusListPage({super.key});

  @override
  State<StatusListPage> createState() => _StatusListPageState();
}

class _StatusListPageState extends State<StatusListPage> {
  final List<Map<String, dynamic>> statusList = [
    {
      "name": "John Doe",
      "time": "10 minutes ago",
      "image": "https://i.pravatar.cc/150?img=3",
      "statuses": [
        "https://picsum.photos/id/1011/800/1200",
        "https://picsum.photos/id/1015/800/1200",
      ],
    },
    {
      "name": "Emma Watson",
      "time": "20 minutes ago",
      "image": "https://i.pravatar.cc/150?img=5",
      "statuses": ["https://picsum.photos/id/1016/800/1200"],
    },
    {
      "name": "Robert",
      "time": "30 minutes ago",
      "image": "https://i.pravatar.cc/150?img=8",
      "statuses": [
        "https://picsum.photos/id/1020/800/1200",
        "https://picsum.photos/id/1024/800/1200",
        "https://picsum.photos/id/1025/800/1200",
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          _buildMyStatus(),

          const SizedBox(height: 10),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Text(
              "Recent updates",
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
          ),

          ...statusList.map((status) {
            return _buildStatusTile(status);
          }),
        ],
      ),
    );
  }

  Widget _buildMyStatus() {
    return ListTile(
      leading: Stack(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundImage: NetworkImage("https://i.pravatar.cc/150?img=1"),
          ),

          Positioned(
            bottom: 0,
            right: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.teal,
                shape: BoxShape.circle,
              ),
              padding: const EdgeInsets.all(3),
              child: const Icon(Icons.add, size: 16, color: Colors.white),
            ),
          ),
        ],
      ),
      title: const Text("My Status"),
      subtitle: const Text("Tap to add status update"),
      onTap: () {},
    );
  }

  Widget _buildStatusTile(Map<String, dynamic> status) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.green, width: 2),
        ),
        child: CircleAvatar(
          radius: 26,
          backgroundImage: NetworkImage(status["image"]),
        ),
      ),
      title: Text(status["name"]),
      subtitle: Text(status["time"]),
    );
  }
}
