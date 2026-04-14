import 'dart:io';
import 'package:chatapp/app/data/repository/status_repo.dart';
import 'package:flutter/material.dart';
import 'package:chatapp/app/data/model/status_detail_model.dart';
import 'package:chatapp/app/core/helper/date_util.dart';

class StatusViewScreen extends StatefulWidget {
  final List<StatusDetailModel> statusList;

  const StatusViewScreen({super.key, required this.statusList});

  @override
  State<StatusViewScreen> createState() => _StatusViewScreenState();
}

class _StatusViewScreenState extends State<StatusViewScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int currentIndex = 0;
  final StatusRepo _repo = StatusRepo();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    )..forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _next();
      }
    });
    _markViewed();
  }

  void _markViewed() {
    final status = widget.statusList[currentIndex];

    _repo.markAsViewed(statusId: status.statusId);
  }

  void _next() {
    if (currentIndex < widget.statusList.length - 1) {
      setState(() {
        currentIndex++;
        _controller.forward(from: 0);
      });
      _markViewed();
    } else {
      Navigator.pop(context);
    }
  }

  void _previous() {
    if (currentIndex > 0) {
      setState(() {
        currentIndex--;
        _controller.forward(from: 0);
      });
    }
    _markViewed();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final status = widget.statusList[currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTapDown: (details) {
          final width = MediaQuery.of(context).size.width;

          if (details.globalPosition.dx < width / 2) {
            _previous();
          } else {
            _next();
          }
        },
        child: Stack(
          children: [
            Positioned.fill(
              child: status.contentUrl.startsWith("http")
                  ? Image.network(status.contentUrl, fit: BoxFit.cover)
                  : Image.file(File(status.contentUrl), fit: BoxFit.cover),
            ),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 140,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.black87, Colors.transparent],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            ),

            Positioned(
              top: 45,
              left: 10,
              right: 10,
              child: Row(
                children: List.generate(widget.statusList.length, (index) {
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      child: Stack(
                        children: [
                          Container(
                            height: 3,
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          AnimatedBuilder(
                            animation: _controller,
                            builder: (context, child) {
                              double value = 0;

                              if (index < currentIndex) {
                                value = 1;
                              } else if (index == currentIndex) {
                                value = _controller.value;
                              }

                              return FractionallySizedBox(
                                widthFactor: value,
                                child: Container(
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                }),
              ),
            ),

            Positioned(
              top: 60,
              left: 12,
              right: 12,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: Colors.grey.shade800,
                    backgroundImage: status.userProfileUrl.isNotEmpty
                        ? (status.userProfileUrl.startsWith("http")
                              ? NetworkImage(status.userProfileUrl)
                              : FileImage(File(status.userProfileUrl))
                                    as ImageProvider)
                        : null,
                    child: status.userProfileUrl.isEmpty
                        ? Text(
                            status.userName.isNotEmpty
                                ? status.userName[0].toUpperCase()
                                : "U",
                            style: const TextStyle(color: Colors.white),
                          )
                        : null,
                  ),

                  const SizedBox(width: 10),

                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        status.userName,
                        style: const TextStyle(color: Colors.white),
                      ),
                      Text(
                        DateUtil.formatTime(status.createdDate),
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),

                  const Spacer(),

                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            if (status.caption.isNotEmpty)
              Positioned(
                left: 20,
                right: 20,
                bottom: 40,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status.caption,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
