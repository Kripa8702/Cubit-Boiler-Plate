import 'dart:math';

import 'package:cubit_boiler_plate/features/widgets/base_screen.dart';
import 'package:cubit_boiler_plate/services/webrtc_signaling.dart';
import 'package:cubit_boiler_plate/theme/styles.dart';
import 'package:cubit_boiler_plate/utils/colored_logs.dart';
import 'package:cubit_boiler_plate/utils/size_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  Signaling signaling = Signaling();
  MediaStream? _localStream;
  final _localRenderer = RTCVideoRenderer();
  final _remoteRenderer = RTCVideoRenderer();
  bool _inCalling = false;
  bool _isTorchOn = false;

  String roomId = '';
  final textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
    initRenderers();
    signaling.onAddRemoteStream = ((stream) {
      ColoredLogs.success('Add remote stream');
      _remoteRenderer.srcObject = stream;
      setState(() {});
    });

    _makeCall();
  }

  @override
  void deactivate() {
    super.deactivate();
    if (_inCalling) {
      _hangUp();
    }

    _localRenderer.dispose();
    _remoteRenderer.dispose();
    navigator.mediaDevices.ondevicechange = null;
  }

  @override
  void dispose() {
    super.dispose();

    _localRenderer.dispose();
    _remoteRenderer.dispose();
  }

  void initRenderers() async {
    await _localRenderer.initialize();
    await _remoteRenderer.initialize();
  }

  void _makeCall() async {
    final mediaConstraints = <String, dynamic>{
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth':
              '640', // Provide your own width, height and frame rate here
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'environment',
        'optional': [],
      }
    };

    setState(() {
      _inCalling = true;
    });

    /// Open user media
    final stream = await signaling.openUserMedia(
      localVideo: _localRenderer,
      remoteVideo: _remoteRenderer,
      mediaConstraints: mediaConstraints,
    );

    setState(() {
      _localStream = stream;
    });

    /// Create room
    final id = await signaling.createRoom(_remoteRenderer);

    /// Send join notification to all or specific user logic goes here
    // await videoCallRepository.sendNotificationToAllVolunteers(roomId: id);

    if(mounted) {
      signaling.startListeningForRoom(
      roomId: id,
      onRoomDoesNotExists: () {
        ColoredLogs.error('Room does not exists');
        _hangUp();
      },
    );
    }

    setState(() {
      roomId = id;
      textEditingController.text = id;
    });
  }

  void _joinRoom(String roomId) async {
    if (roomId.isEmpty) {
      ColoredLogs.error('Room ID cannot be empty');
      return;
    }

    final mediaConstraints = {
      'audio': true,
      'video': {
        'mandatory': {
          'minWidth':
          '640', // Provide your own width, height and frame rate here
          'minHeight': '480',
          'minFrameRate': '30',
        },
        'facingMode': 'environment',
        'optional': [],
      }
    };

    setState(() {
      _inCalling = true;
    });

    /// Open user media

    final stream = await signaling.openUserMedia(
      localVideo: _localRenderer,
      remoteVideo: _remoteRenderer,
      mediaConstraints: mediaConstraints,
    );
    setState(() {
      _localStream = stream;
    });

    /// Join room
    await signaling.joinRoom(
      roomId: roomId,
      remoteVideo: _remoteRenderer,
    );

    setState(() {
      _inCalling = true;
    });

    if (mounted) {
      signaling.startListeningForRoom(
        roomId: roomId,
        onRoomDoesNotExists: () {
          ColoredLogs.error('Room does not exists');
          _hangUp();
        },
      );
    }
  }


  void _hangUp() async {
    try {
      await _remoteRenderer.dispose();

      await _localRenderer.dispose();

      await signaling.hangUp(_localRenderer, roomId);


      if(mounted) {
        Navigator.of(context).pop();
      }
    } catch (e) {
      ColoredLogs.error(e.toString());
      if(mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  void _toggleTorch() async {
    if (_localStream == null) throw Exception('Stream is not initialized');

    final videoTrack = _localStream!
        .getVideoTracks()
        .firstWhere((track) => track.kind == 'video');
    final has = await videoTrack.hasTorch();
    if (has) {
      ColoredLogs.debug('[TORCH] Current camera supports torch mode');
      setState(() => _isTorchOn = !_isTorchOn);
      await videoTrack.setTorch(_isTorchOn);
      ColoredLogs.debug(
          '[TORCH] Torch state is now ${_isTorchOn ? 'on' : 'off'}');
    } else {
      ColoredLogs.debug('[TORCH] Current camera does not support torch mode');
    }
  }

  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    final point = Point<double>(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    Helper.setFocusPoint(_localStream!.getVideoTracks().first, point);
    Helper.setExposurePoint(_localStream!.getVideoTracks().first, point);
  }

  void setZoom(double zoomLevel) async {
    if (_localStream == null) throw Exception('Stream is not initialized');
    // await videoTrack.setZoom(zoomLevel); //Use it after published webrtc_interface 1.1.1

    // before the release, use can just call native method directly.
    final videoTrack = _localStream!
        .getVideoTracks()
        .firstWhere((track) => track.kind == 'video');
    await Helper.setZoom(videoTrack, zoomLevel);
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      horizontalPadding: 0.0,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          OrientationBuilder(
            builder: (context, orientation) {
              return Center(
                child: Container(
                  margin: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  decoration: const BoxDecoration(color: Color(0xFF000000)),
                  child: LayoutBuilder(
                    builder:
                        (BuildContext context, BoxConstraints constraints) {
                      return (_inCalling && (_remoteRenderer.srcObject != null && _remoteRenderer.srcObject!.getTracks().isNotEmpty))
                          ? GestureDetector(
                              onScaleStart: (details) {},
                              onScaleUpdate: (details) {
                                if (details.scale != 1.0) {
                                  setZoom(details.scale);
                                }
                              },
                              onTapDown: (TapDownDetails details) =>
                                  onViewFinderTap(details, constraints),
                              child: RTCVideoView(
                                _remoteRenderer,
                                mirror: false,
                                objectFit: RTCVideoViewObjectFit
                                    .RTCVideoViewObjectFitCover,
                                placeholderBuilder: (context) {
                                  return const Center(
                                    child: Icon(
                                      Icons.videocam_off,
                                      color: Colors.white,
                                      size: 100,
                                    ),
                                  );
                                },
                              ),
                            )
                          : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 40.h,
                              ),
                              Icon(
                                Icons.access_time_filled_rounded,
                                color: Colors.white,
                                size: 50.h,
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Text(
                                'Waiting for user to join...',
                                style: Styles.bodyMedium
                                    .copyWith(color: Colors.white),
                              ),
                            ],
                          );
                    },
                  ),
                ),
              );
            },
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 350),
            top: (_remoteRenderer.srcObject != null && _remoteRenderer.srcObject!.getTracks().isNotEmpty) ? 50.h : 0.h,
            right: (_remoteRenderer.srcObject != null && _remoteRenderer.srcObject!.getTracks().isNotEmpty) ? 20.w: 0.h,
            left: (_remoteRenderer.srcObject != null && _remoteRenderer.srcObject!.getTracks().isNotEmpty) ? 180.w: 0.h,
            bottom: (_remoteRenderer.srcObject != null && _remoteRenderer.srcObject!.getTracks().isNotEmpty) ? 530.h: 0.h,
            curve: Curves.easeInOut,
            child: Container(
              width: 180.w,
              height: 250.h,
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: RTCVideoView(
                  _localRenderer,
                  mirror: false,
                  objectFit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
                  placeholderBuilder: (context) {
                    return const Center(
                      child: Icon(
                        Icons.videocam_off,
                        color: Colors.white,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          if (_remoteRenderer.srcObject == null || _remoteRenderer.srcObject!.getTracks().isEmpty)
            Positioned(
              top: 0.h,
              left: 0.h,
              right: 0.h,
              bottom: 0.h,
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Waiting for volunteer to join...',
                        style: Styles.bodyMedium.copyWith(color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          Positioned(
            bottom: 50.w,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                SizedBox(
                  width: 30.w,
                ),
                SizedBox(
                  width: 70.h,
                  height: 70.h,
                  child: FloatingActionButton(
                    onPressed: _hangUp,
                    tooltip: 'Hangup',
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: const CircleBorder(),
                    child: Icon(
                      Icons.call_end ,
                      size: 32.h,
                    ),
                  ),
                ),
                SizedBox(
                  width: 30.w,
                ),
                GestureDetector(
                  onTap: _toggleTorch,
                  child: Container(
                    height: 55.w,
                    width: 55.w,
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isTorchOn ? Icons.flash_off : Icons.flash_on,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
