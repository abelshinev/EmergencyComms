import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'dart:async';

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() => _instance;

  SocketService._internal();

  IO.Socket? socket;

  void initiateCall({required String agentId, required String deviceId}) {
    
      socket?.emit('call:initiate', {
        'targetAgentId': agentId,
        'deviceId': deviceId,
      });

  }

  Future<void> connect() async {
    if (socket != null && socket!.connected) {
      return;
    }

    final completer = Completer<void>();

    socket = IO.io(
      'http://10.0.2.2:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

    socket!.onConnect((_) {
      print('✅ Socket connected');

      if (!completer.isCompleted) {
        completer.complete();
      }
    });

    socket!.onDisconnect((_) {
      print('❌ Socket disconnected');
    });

    socket!.onError((error) {
      print('Socket error: $error');
    });

    socket!.on('call:accepted', (data) {
      print('✅ Call accepted: $data');
    });

    socket!.on('call:alerting', (data) {
      print('🔔 Alert delivered: $data');
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

    socket!.connect();

    return completer.future;
  }

  void disconnect() {
    socket?.disconnect();
  }
}