import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cubit_boiler_plate/utils/colored_logs.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

typedef StreamStateCallback = void Function(MediaStream stream);

class Signaling {
  final _firebaseFirestore = FirebaseFirestore.instance;

  Map<String, dynamic> configuration = {
    'iceServers': [
      {
        'urls': [
          'stun:stun1.l.google.com:19302',
          'stun:stun2.l.google.com:19302'
        ]
      }
    ]
  };

  RTCPeerConnection? peerConnection;
  MediaStream? localStream;
  MediaStream? remoteStream;
  String? roomId;
  String? currentRoomText;
  StreamStateCallback? onAddRemoteStream;

  Future<String> createRoom(RTCVideoRenderer remoteRenderer) async {
    DocumentReference roomRef = _firebaseFirestore.collection('rooms').doc();

    ColoredLogs.debug(
        'SIGNALING: Create PeerConnection with configuration: $configuration');

    peerConnection = await createPeerConnection(configuration);

    registerPeerConnectionListeners();

    localStream?.getTracks().forEach((track) {
      peerConnection?.addTrack(track, localStream!);
    });

    // Code for collecting ICE candidates below
    var callerCandidatesCollection = roomRef.collection('callerCandidates');

    peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      ColoredLogs.debug('SIGNALING: Got candidate: ${candidate.toMap()}');
      callerCandidatesCollection.add(candidate.toMap());
    };
    // Finish Code for collecting ICE candidate

    // Add code for creating a room
    RTCSessionDescription offer = await peerConnection!.createOffer();
    await peerConnection!.setLocalDescription(offer);
    ColoredLogs.debug('SIGNALING: Created offer: $offer');

    Map<String, dynamic> roomWithOffer = {'offer': offer.toMap()};

    await roomRef.set(roomWithOffer);
    var roomId = roomRef.id;
    ColoredLogs.debug(
        'SIGNALING: New room created with SDK offer. Room ID: $roomId');
    currentRoomText = 'Current room is $roomId - You are the caller!';
    // Created a Room

    peerConnection?.onTrack = (RTCTrackEvent event) {
      ColoredLogs.debug('SIGNALING: Got remote track: ${event.streams[0]}');

      event.streams[0].getTracks().forEach((track) {
        ColoredLogs.debug('SIGNALING: Add a track to the remoteStream $track');
        remoteStream?.addTrack(track);
      });
    };

    // Listening for remote session description below
    roomRef.snapshots().listen((snapshot) async {
      ColoredLogs.debug('SIGNALING: Got updated room: ${snapshot.data()}');

      Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
      if (peerConnection?.getRemoteDescription() != null &&
          data['answer'] != null) {
        var answer = RTCSessionDescription(
          data['answer']['sdp'],
          data['answer']['type'],
        );

        ColoredLogs.debug("SIGNALING: Someone tried to connect");
        await peerConnection?.setRemoteDescription(answer);
      }
    });
    // Listening for remote session description above

    // Listen for remote Ice candidates below
    roomRef.collection('calleeCandidates').snapshots().listen((snapshot) {
      for (var change in snapshot.docChanges) {
        if (change.type == DocumentChangeType.added) {
          Map<String, dynamic> data = change.doc.data() as Map<String, dynamic>;
          ColoredLogs.debug(
              'SIGNALING: Got new remote ICE candidate: ${jsonEncode(data)}');
          peerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        }
      }
    });
    // Listen for remote ICE candidates above

    return roomId;
  }

  Future<bool> checkIfRoomExists(String roomId) async {
    ColoredLogs.debug('SIGNALING: Check if room exists $roomId');
    DocumentReference roomRef =
    _firebaseFirestore.collection('rooms').doc(roomId);

    var roomSnapshot = await roomRef.get();

    return roomSnapshot.exists && roomSnapshot.data() != null;
  }

  Future<bool> checkIfCallAlreadyAnswered(String roomId) async {
    ColoredLogs.debug('SIGNALING: Check if call already answered $roomId');
    DocumentReference roomRef =
    _firebaseFirestore.collection('rooms').doc(roomId);

    var roomSnapshot = await roomRef.get();

    if(!roomSnapshot.exists || roomSnapshot.data() == null) {
      ColoredLogs.debug('SIGNALING: Room does not exist');
      return true;
    }
    var data = roomSnapshot.data() as Map<String, dynamic>;

    ColoredLogs.success(data.toString());
    return data['answer'] != null;
  }

  Future<void> joinRoom({
    required String roomId,
    required RTCVideoRenderer remoteVideo,
  }) async {
    ColoredLogs.debug('SIGNALING: Join room $roomId');
    DocumentReference roomRef =
    _firebaseFirestore.collection('rooms').doc(roomId);
    var roomSnapshot = await roomRef.get();
    ColoredLogs.debug('SIGNALING: Got room ${roomSnapshot.exists}');

    if (roomSnapshot.exists) {
      ColoredLogs.debug(
          'SIGNALING: Create PeerConnection with configuration: $configuration');

      var data = roomSnapshot.data() as Map<String, dynamic>;

      peerConnection = await createPeerConnection(configuration);

      registerPeerConnectionListeners();

      localStream?.getTracks().forEach((track) {
        peerConnection?.addTrack(track, localStream!);
      });

      // Code for collecting ICE candidates below
      var calleeCandidatesCollection = roomRef.collection('calleeCandidates');
      peerConnection!.onIceCandidate = (RTCIceCandidate? candidate) {
        if (candidate == null) {
          ColoredLogs.debug('SIGNALING: onIceCandidate: complete!');
          return;
        }
        ColoredLogs.debug('SIGNALING: onIceCandidate: ${candidate.toMap()}');
        calleeCandidatesCollection.add(candidate.toMap());
      };
      // Code for collecting ICE candidate above

      peerConnection?.onTrack = (RTCTrackEvent event) {
        ColoredLogs.debug('SIGNALING: Got remote track: ${event.streams[0]}');
        event.streams[0].getTracks().forEach((track) {
          ColoredLogs.debug(
              'SIGNALING: Add a track to the remoteStream: $track');
          remoteStream?.addTrack(track);
        });
      };

      // Code for creating SDP answer below
      ColoredLogs.debug('SIGNALING: Got offer $data');
      var offer = data['offer'];
      await peerConnection?.setRemoteDescription(
        RTCSessionDescription(offer['sdp'], offer['type']),
      );
      var answer = await peerConnection!.createAnswer();
      ColoredLogs.debug('SIGNALING: Created Answer $answer');

      await peerConnection!.setLocalDescription(answer);

      Map<String, dynamic> roomWithAnswer = {
        'answer': {'type': answer.type, 'sdp': answer.sdp}
      };

      await roomRef.update(roomWithAnswer);
      // Finished creating SDP answer

      // Listening for remote ICE candidates below
      roomRef.collection('callerCandidates').snapshots().listen((snapshot) {
        for (var document in snapshot.docChanges) {
          var data = document.doc.data() as Map<String, dynamic>;
          ColoredLogs.debug('SIGNALING: Got new remote ICE candidate: $data');
          peerConnection!.addCandidate(
            RTCIceCandidate(
              data['candidate'],
              data['sdpMid'],
              data['sdpMLineIndex'],
            ),
          );
        }
      });
    }
  }

  Future<MediaStream> openUserMedia({
    required RTCVideoRenderer localVideo,
    required RTCVideoRenderer remoteVideo,
    required Map<String, dynamic> mediaConstraints,
  }) async {
    var stream = await navigator.mediaDevices.getUserMedia(mediaConstraints);

    localVideo.srcObject = stream;
    localStream = stream;

    remoteVideo.srcObject = await createLocalMediaStream('key');
    return stream;
  }

  Future<void> hangUp(RTCVideoRenderer localVideo, String? id) async {
    List<MediaStreamTrack> tracks = localVideo.srcObject!.getTracks();
    for (var track in tracks) {
      track.stop();
    }

    if (remoteStream != null) {
      remoteStream!.getTracks().forEach((track) => track.stop());
    }
    if (peerConnection != null) peerConnection!.close();

    ColoredLogs.debug("SIGNALING: DELETE ROOM: $id");
    if (id != null) {
      // FirebaseService.deleteDocument('rooms', id);

      //  delete callerCandidates and calleeCandidates collection
      try {
        await FirebaseFirestore.instance
            .collection('rooms')
            .doc(id)
            .collection('callerCandidates')
            .get()
            .then((snapshot) {
          for (DocumentSnapshot doc in snapshot.docs) {
            doc.reference.delete();
          }
        });


        await FirebaseFirestore.instance
            .collection('rooms')
            .doc(id)
            .collection('calleeCandidates')
            .get()
            .then((snapshot) {
          for (DocumentSnapshot doc in snapshot.docs) {
            doc.reference.delete();
          }
        });

        // delete room doc
        await FirebaseFirestore.instance.collection('rooms').doc(id).delete();
      } catch (e) {
        ColoredLogs.error('Error deleting room: $e');
      }
    }

    localStream!.dispose();
    remoteStream?.dispose();
  }

  void registerPeerConnectionListeners() {
    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      ColoredLogs.info('SIGNALING STATE: ICE gathering state changed: $state');
    };

    peerConnection?.onConnectionState = (RTCPeerConnectionState state) {
      ColoredLogs.info('SIGNALING STATE: Connection state change: $state');
    };

    peerConnection?.onSignalingState = (RTCSignalingState state) {
      ColoredLogs.info('SIGNALING STATE: Signaling state change: $state');
    };

    peerConnection?.onIceGatheringState = (RTCIceGatheringState state) {
      ColoredLogs.info('SIGNALING STATE: ICE connection state change: $state');
    };

    peerConnection?.onIceConnectionState = (RTCIceConnectionState state) {
      ColoredLogs.info('SIGNALING STATE: ICE connection state change: $state');
    };

    peerConnection?.onIceCandidate = (RTCIceCandidate candidate) {
      ColoredLogs.info('SIGNALING STATE: ICE candidate: $candidate');
    };

    peerConnection?.onAddTrack = (MediaStream stream, MediaStreamTrack track) {
      ColoredLogs.info("SIGNALING STATE: Add track");
      onAddRemoteStream?.call(stream);
      remoteStream = stream;
    };

    peerConnection?.onTrack = (RTCTrackEvent event) {
      ColoredLogs.info("SIGNALING STATE: Add track");
      onAddRemoteStream?.call(event.streams[0]);
      remoteStream = event.streams[0];
    };

    peerConnection?.onAddStream = (MediaStream stream) {
      ColoredLogs.info(
          "SIGNALING STATE: Add remote stream..  ${stream.getTracks()}");
      onAddRemoteStream?.call(stream);
      remoteStream = stream;
    };
  }

  Future<void> dispose() async {
    if (peerConnection != null) {}
  }

  /// State stream to listen if room id exists in collection
  static StreamSubscription<void>? _subscription;

  startListeningForRoom({
    required String roomId,
    required Function() onRoomDoesNotExists,
  }) {
    ColoredLogs.success('Listening for room: $roomId');
    _subscription =
        Stream.periodic(const Duration(seconds: 2)).listen((_) async {
          final room = await FirebaseFirestore.instance
              .collection('rooms')
              .doc(roomId)
              .get();
          if (!room.exists) {
            onRoomDoesNotExists();
            _subscription?.cancel();
            _subscription = null;
          }
        });
  }

  stopListeningForRoom() {
    ColoredLogs.success('Stopped listening for room');
    _subscription?.cancel();
  }
}
