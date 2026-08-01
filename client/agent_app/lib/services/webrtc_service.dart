import 'package:flutter_webrtc/flutter_webrtc.dart';

class WebRTCService {
  RTCPeerConnection? _peerConnection;
  MediaStream? _localStream;

  RTCPeerConnection? get peerConnection => _peerConnection;
  MediaStream? get localStream => _localStream;

  Future<void> initialize() async {
    final configuration = {
      'iceServers': [
        {
          'urls': 'stun:stun.l.google.com:19302',
        },
      ],
    };

    _peerConnection = await createPeerConnection(configuration);

    _localStream = await navigator.mediaDevices.getUserMedia({
      'audio': true,
      'video': false,
    });

    for (var track in _localStream!.getTracks()) {
      _peerConnection!.addTrack(track, _localStream!);
    }

    print('✅ WebRTC initialized');
  }

  Future<RTCSessionDescription> createOffer() async {
    final offer = await _peerConnection!.createOffer();

    await _peerConnection!.setLocalDescription(offer);

    print('📡 Local Offer Created');

    return offer;
  }

  Future<RTCSessionDescription> createAnswer() async {
    final answer = await _peerConnection!.createAnswer();

    await _peerConnection!.setLocalDescription(answer);

    print('📡 Local Answer Created');

    return answer;
  }

  Future<void> setRemoteDescription(
      RTCSessionDescription description) async {
    await _peerConnection!.setRemoteDescription(description);

    print('✅ Remote Description Set');
  }

  Future<void> addIceCandidate(
      RTCIceCandidate candidate) async {
    await _peerConnection!.addCandidate(candidate);

    print('🧊 ICE Candidate Added');
  }

  void onIceCandidate(
      Function(RTCIceCandidate candidate) callback) {
    _peerConnection!.onIceCandidate = callback;
  }

  void onTrack(Function(MediaStream stream) callback) {
    _peerConnection!.onTrack = (RTCTrackEvent event) {
      if (event.streams.isNotEmpty) {
        callback(event.streams.first);
      }
    };
  }

  Future<void> dispose() async {
    await _localStream?.dispose();
    await _peerConnection?.close();

    _localStream = null;
    _peerConnection = null;
  }
}