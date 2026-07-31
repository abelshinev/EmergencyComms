import 'package:socket_io_client/socket_io_client.dart' as IO;

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() => _instance;

  SocketService._internal();

  IO.Socket? socket;

  void connect(String agentId) {
    if (socket != null && socket!.connected) {
      return;
    }

    socket = IO.io(
      'http://172.17.76.99:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket!.connect();

    socket!.onConnect((_) {
      print('✅ Socket connected');

      socket!.emit('agent:register', {
        'agentId': agentId,
      });
    });

    socket!.on('agent:registered', (data) {
      print('✅ Agent registered: $data');
    });

    socket!.on('call:incoming', (data) {
      print('📞 Incoming call: $data');
    });

    socket!.on('call:accepted', (data) {
      print('✅ Call accepted: $data');
    });

    socket!.on('call:rejected', (data) {
      print('❌ Call rejected: $data');
    });

    socket!.on('webrtc:offer', (data) {
      print('📡 WebRTC Offer received');
    });

    socket!.on('webrtc:answer', (data) {
      print('📡 WebRTC Answer received');
    });

    socket!.on('webrtc:ice-candidate', (data) {
      print('🧊 ICE Candidate received');
    });

    socket!.on('call:ended', (data) {
      print('☎️ Call ended');
    });

    socket!.onDisconnect((_) {
      print('❌ Socket disconnected');
    });

    socket!.onError((error) {
      print('Socket error: $error');
    });
  }

  void disconnect() {
    socket?.disconnect();
  }
}