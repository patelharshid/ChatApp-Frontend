import 'dart:convert';
import 'package:socket_io_client/socket_io_client.dart';

class SocketService {
  late Socket socket;

  void connect(int userId) {
    socket = io(
      'http://192.168.157.76:9000',
      OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket.connect();

    socket.onConnect((_) {
      print('Connected to server');
      socket.emit('join', userId);
    });

    socket.onDisconnect((_) {
      print('Disconnected');
    });
  }

  void sendMessage(Map<String, dynamic> data) {
    socket.emit('message', jsonEncode(data));
  }

  void onMessage(Function(Map<String, dynamic>) callback) {
    socket.on('message', (data) {
      final decoded = jsonDecode(data);
      callback(Map<String, dynamic>.from(decoded));
    });
  }

  void disconnect() {
    socket.disconnect();
  }
}
