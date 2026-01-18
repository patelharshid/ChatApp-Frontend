import 'package:socket_io_client/socket_io_client.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();
  factory SocketService() => _instance;
  SocketService._internal();

  late Socket socket;
  bool isConnected = false;

  void connect(int userId) {
    if (isConnected) return;

    socket = io(
      'http://192.168.157.76:9000',
      OptionBuilder().setTransports(['websocket']).disableAutoConnect().build(),
    );

    socket.connect();

    socket.onConnect((_) {
      isConnected = true;
      print("Socket connected");
      socket.emit('join', userId);
    });

    socket.onDisconnect((_) {
      isConnected = false;
      print("Socket disconnected");
    });
  }

  void sendMessage(Map<String, dynamic> data) {
    socket.emit('message', data);
  }

  void onMessage(Function(Map<String, dynamic>) callback) {
    socket.off('message');
    socket.on('message', (data) {
      callback(Map<String, dynamic>.from(data));
    });
  }
}
