import 'package:agent_app/app/app.dart';
import 'package:agent_app/screens/incoming_call_dialog.dart';
import 'package:agent_app/services/webrtc_service.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:flutter/material.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() => _instance;

  SocketService._internal();

  IO.Socket? socket;

  final WebRTCService _webrtc = WebRTCService();

  String? _currentCallId;

  void connect(String agentId) {
    if (socket != null && socket!.connected) {
      return;
    }

    socket = IO.io(
      'http://172.17.76.30:3000',
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .disableAutoConnect()
          .build(),
    );

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

      _currentCallId = data['callId'];

      showDialog(
        context: navigatorKey.currentContext!,
        barrierDismissible: false,
        builder: (_) => IncomingCallDialog(call: data),
      );
    });

    socket!.on('call:accepted', (data) {
      print('✅ Call accepted: $data');
    });

    socket!.on('call:rejected', (data) {
      print('❌ Call rejected: $data');
    });

    // ==========================
    // Receive Offer
    // ==========================
    socket!.on('webrtc:offer', (data) async {
      print('📡 Offer received');

      final callId = data['callId'];
      _currentCallId = callId;

      await _webrtc.initialize();

      await _webrtc.setRemoteDescription(
        RTCSessionDescription(
          data['sdp'],
          data['type'],
        ),
      );

      // Send ICE candidates to passenger
      _webrtc.onIceCandidate((candidate) {
        socket?.emit('webrtc:ice-candidate', {
          'callId': callId,
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        });

        print('🧊 Agent ICE sent');
      });

      final answer = await _webrtc.createAnswer();

      socket?.emit('webrtc:answer', {
        'callId': callId,
        'sdp': answer.sdp,
        'type': answer.type,
      });

      print('📡 Answer sent');
    });

    // Agent should never receive an answer
    socket!.on('webrtc:answer', (data) {
      print('⚠️ Unexpected Answer received');
    });

    // Receive ICE candidate
    socket!.on('webrtc:ice-candidate', (data) async {
      print('🧊 ICE Candidate received');

      final candidate = RTCIceCandidate(
        data['candidate'],
        data['sdpMid'],
        data['sdpMLineIndex'],
      );

      await _webrtc.addIceCandidate(candidate);

      print('🧊 Agent ICE Added');
    });

    socket!.on('call:ended', (data) async {
      print('☎️ Call ended');

      _currentCallId = null;

      await _webrtc.dispose();
    });

    socket!.onDisconnect((_) {
      print('❌ Socket disconnected');
    });

    socket!.onError((error) {
      print('Socket error: $error');
    });

    // ACTUALLY CONNECT
    socket!.connect();
  }

  void acceptCurrentCall() {
    if (_currentCallId == null) return;

    socket?.emit('call:accepted', {
      'callId': _currentCallId,
    });
  }

  void rejectCurrentCall() {
    if (_currentCallId == null) return;

    socket?.emit('call:rejected', {
      'callId': _currentCallId,
    });
  }

  void disconnect() {
    socket?.disconnect();
  }
}