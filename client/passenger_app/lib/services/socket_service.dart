import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import 'package:passenger_app/app/app.dart';
import 'package:passenger_app/screens/call_screen.dart';
import 'webrtc_service.dart';

class SocketService {
  static final SocketService _instance = SocketService._internal();

  factory SocketService() => _instance;

  SocketService._internal();

  IO.Socket? socket;

  final WebRTCService _webrtc = WebRTCService();

  String? _currentCallId;

  void initiateCall({
    required String agentId,
    required String deviceId,
    required String stationId,
    required String block,
  }) {
    socket?.emit('call:initiate', {
      'targetAgentId': agentId,
      'deviceId': deviceId,
      'stationId': stationId,
      'block': block,
    });
  }

  Future<void> connect() async {
    if (socket != null && socket!.connected) return;

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

    socket!.onError((err) {
      print('Socket error: $err');
    });

    socket!.on('call:alerting', (data) {
      print('🔔 Alert delivered');
      _currentCallId = data['callId'];
    });

    socket!.on('call:accepted', (data) async {
      print('✅ Call accepted');

      _currentCallId = data['callId'];

      Navigator.push(
        navigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (_) => const CallScreen(),
        ),
      );

      await _webrtc.initialize();

      _webrtc.onIceCandidate((candidate) {
        socket?.emit('webrtc:ice-candidate', {
          'callId': _currentCallId,
          'candidate': candidate.candidate,
          'sdpMid': candidate.sdpMid,
          'sdpMLineIndex': candidate.sdpMLineIndex,
        });
      });

      final offer = await _webrtc.createOffer();

      socket?.emit('webrtc:offer', {
        'callId': _currentCallId,
        'sdp': offer.sdp,
        'type': offer.type,
      });

      print('📡 Offer sent');
    });

    socket!.on('webrtc:answer', (data) async {
      print('📡 Answer received');

      await _webrtc.setRemoteDescription(
        RTCSessionDescription(
          data['sdp'],
          data['type'],
        ),
      );
    });

    socket!.on('webrtc:ice-candidate', (data) async {
      final candidate = RTCIceCandidate(
        data['candidate'],
        data['sdpMid'],
        data['sdpMLineIndex'],
      );

      await _webrtc.addIceCandidate(candidate);
    });

    socket!.on('call:ended', (_) async {
      print('☎️ Call ended');

      _currentCallId = null;

      await _webrtc.dispose();

      Navigator.of(
        navigatorKey.currentContext!,
      ).popUntil((route) => route.isFirst);
    });

    socket!.connect();

    return completer.future;
  }

  // ---------------------------
  // HANG UP CURRENT CALL
  // ---------------------------
  void endCurrentCall() {
    if (_currentCallId == null) return;

    socket?.emit('call:end', {
      'callId': _currentCallId,
    });

    _currentCallId = null;
  }

  void disconnect() {
    socket?.disconnect();
  }
}