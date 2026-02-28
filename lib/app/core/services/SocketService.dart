import 'package:socket_io_client/socket_io_client.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  Socket? socket;
  bool isConnected = false;

  int? currentUserId;
  Set<int> joinedGroups = {};

  void _connect() {
    if (socket != null && isConnected) return;

    socket = io(
      'http://192.168.242.76:9000',
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      isConnected = true;
      print("✅ Socket Connected");

      if (currentUserId != null) {
        socket!.emit('join', currentUserId);
      }

      for (var groupId in joinedGroups) {
        socket!.emit('Group', groupId);
      }
    });

    socket!.onDisconnect((_) {
      isConnected = false;
      print("❌ Socket Disconnected");
    });
  }

  void connectUser(int userId) {
    currentUserId = userId;
    _connect();
  }

  void connectGroup(int userId, int groupId) {
    currentUserId = userId;
    joinedGroups.add(groupId);

    _connect();

    if (isConnected) {
      socket!.emit('join', userId);
      socket!.emit('Group', groupId);
    }
  }

  void sendMessage(Map<String, dynamic> data) {
    socket?.emit('message', data);
  }

  void sendGroupMessage(Map<String, dynamic> data) {
    socket?.emit('group-message', data);
  }

  void onMessage(Function(Map<String, dynamic>) callback) {
    socket?.off('message');

    socket?.on('message', (data) {
      callback(Map<String, dynamic>.from(data));
    });
  }

  void onGroupMessage(Function(Map<String, dynamic>) callback) {
    socket?.off('group-message');

    socket?.on('group-message', (data) {
      print("📩 Group message received: $data");
      callback(Map<String, dynamic>.from(data));
    });
  }

  void disconnect() {
    socket?.disconnect();
    socket?.dispose();

    socket = null;
    isConnected = false;
    joinedGroups.clear();
  }
}