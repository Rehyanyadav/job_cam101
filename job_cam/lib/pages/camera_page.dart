import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
// ignore: unused_import
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as path;
import 'package:permission_handler/permission_handler.dart';

class CamCompanyStyleCameraUI extends StatefulWidget {
  const CamCompanyStyleCameraUI({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _CamCompanyStyleCameraUIState createState() =>
      _CamCompanyStyleCameraUIState();
}

class _CamCompanyStyleCameraUIState extends State<CamCompanyStyleCameraUI> {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  bool _isRearCameraSelected = true;
  FlashMode _flashMode = FlashMode.off;
  bool _isVideoMode = false;
  bool _isRecording = false;
  bool _isWalkthroughRecording = false;
  bool _isSaving = false;
  String _debugInfo = '';
  List<String> _galleryMedia = [];

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
    _loadGalleryMedia();
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _updateDebugInfo('No cameras found');
        return;
      }
      final firstCamera = _isRearCameraSelected ? cameras.first : cameras.last;
      _controller = CameraController(
        firstCamera,
        ResolutionPreset.high,
        enableAudio: true,
      );
      _initializeControllerFuture = _controller!.initialize();
      await _initializeControllerFuture;
      _updateDebugInfo('Camera initialized');
      setState(() {});
    } catch (e) {
      _updateDebugInfo('Failed to initialize camera: $e');
    }
  }

  Future<void> _requestCameraPermission() async {
    final cameraStatus = await Permission.camera.request();
    final microphoneStatus = await Permission.microphone.request();
    if (cameraStatus.isGranted && microphoneStatus.isGranted) {
      _updateDebugInfo('Camera and microphone permissions granted');
      await _initializeCamera();
    } else {
      _updateDebugInfo('Camera or microphone permission denied');
      _showPermissionDeniedDialog();
    }
  }

  void _showPermissionDeniedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Permissions Required'),
        content: const Text(
            'Please grant camera and microphone permissions to use this feature.'),
        actions: <Widget>[
          TextButton(
            child: const Text('OK'),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: _initializeControllerFuture == null
                ? const Center(child: Text('Camera initialization failed'))
                : FutureBuilder<void>(
                    future: _initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return _buildCameraPreview();
                      } else if (snapshot.hasError) {
                        return Center(child: Text('Error: ${snapshot.error}'));
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    },
                  ),
          ),
          Container(
            padding: const EdgeInsets.all(8.0),
            color: Colors.black,
            child: Text(
              _debugInfo,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCameraPreview() {
    if (_controller == null || !_controller!.value.isInitialized) {
      return const Center(child: Text('Camera not available'));
    }
    return Stack(
      children: [
        CameraPreview(_controller!),
        _buildTopControls(),
        _buildBottomControls(),
        if (_isSaving)
          Container(
            color: Colors.black54,
            child: const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 20),
                  Text(
                    'Saving...',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildTopControls() {
    return Positioned(
      top: 20,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(
                _flashMode == FlashMode.off ? Icons.flash_off : Icons.flash_on),
            color: Colors.white,
            onPressed: _toggleFlash,
          ),
          IconButton(
            icon: const Icon(Icons.switch_camera),
            color: Colors.white,
            onPressed: _switchCamera,
          ),
          IconButton(
            icon: Icon(
                _isWalkthroughRecording ? Icons.stop : Icons.record_voice_over),
            color: Colors.white,
            onPressed: _toggleWalkthroughRecording,
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 20,
      left: 0,
      right: 0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: const Icon(Icons.photo_library),
            color: Colors.white,
            onPressed: _openGallery,
          ),
          IconButton(
            icon: Icon(_isVideoMode
                ? (_isRecording ? Icons.stop : Icons.fiber_manual_record)
                : Icons.camera),
            color: _isRecording ? Colors.red : Colors.white,
            iconSize: 72,
            onPressed: _isVideoMode ? _toggleRecording : _captureImage,
          ),
          IconButton(
            icon: Icon(_isVideoMode ? Icons.videocam : Icons.camera_alt),
            color: Colors.white,
            onPressed: _toggleCameraMode,
          ),
        ],
      ),
    );
  }

  void _toggleFlash() {
    setState(() {
      _flashMode =
          _flashMode == FlashMode.off ? FlashMode.torch : FlashMode.off;
      _controller?.setFlashMode(_flashMode);
      _updateDebugInfo('Flash mode: $_flashMode');
    });
  }

  void _switchCamera() async {
    _isRearCameraSelected = !_isRearCameraSelected;
    await _initializeCamera();
    _updateDebugInfo(
        'Camera switched: ${_isRearCameraSelected ? 'Rear' : 'Front'}');
  }

  void _toggleCameraMode() {
    setState(() {
      _isVideoMode = !_isVideoMode;
      _updateDebugInfo('Camera mode: ${_isVideoMode ? 'Video' : 'Photo'}');
    });
  }

  Future<void> _captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      _updateDebugInfo('Camera not ready');
      return;
    }
    try {
      _updateDebugInfo('Capturing image...');
      final image = await _controller!.takePicture();
      setState(() => _isSaving = true);
      await _saveMediaToGallery(image.path);
      setState(() => _isSaving = false);
      _updateDebugInfo('Image captured and saved successfully');
    } catch (e) {
      _updateDebugInfo('Error capturing image: $e');
      setState(() => _isSaving = false);
    }
  }

  Future<void> _toggleRecording() async {
    if (_controller == null || !_controller!.value.isInitialized) {
      _updateDebugInfo('Camera not ready');
      return;
    }
    if (_isRecording) {
      try {
        _updateDebugInfo('Stopping video recording...');
        final video = await _controller!.stopVideoRecording();
        setState(() => _isSaving = true);
        await _saveMediaToGallery(video.path);
        setState(() {
          _isRecording = false;
          _isSaving = false;
        });
        _updateDebugInfo('Video recorded and saved successfully');
      } catch (e) {
        _updateDebugInfo('Error stopping video recording: $e');
        setState(() => _isRecording = false);
      }
    } else {
      try {
        _updateDebugInfo('Starting video recording...');
        await _controller!.startVideoRecording();
        setState(() => _isRecording = true);
        _updateDebugInfo('Video recording started');
      } catch (e) {
        _updateDebugInfo('Error starting video recording: $e');
      }
    }
  }

  void _toggleWalkthroughRecording() {
    setState(() {
      _isWalkthroughRecording = !_isWalkthroughRecording;
      _updateDebugInfo(_isWalkthroughRecording
          ? 'Walkthrough recording started'
          : 'Walkthrough recording stopped');
    });
  }

  Future<void> _saveMediaToGallery(String filePath) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final fileName = path.basename(filePath);
      final savedFile =
          await File(filePath).copy('${directory.path}/$fileName');
      _galleryMedia.add(savedFile.path);
      _updateDebugInfo('Media saved to gallery: ${savedFile.path}');
    } catch (e) {
      _updateDebugInfo('Error saving media to gallery: $e');
    }
  }

  Future<void> _loadGalleryMedia() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync();
    _galleryMedia = files
        .where((file) =>
            file.path.endsWith('.jpg') ||
            file.path.endsWith('.png') ||
            file.path.endsWith('.mp4'))
        .map((file) => file.path)
        .toList();
  }

  void _openGallery() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => GalleryScreen(media: _galleryMedia),
      ),
    );
  }

  void _updateDebugInfo(String message) {
    setState(() {
      _debugInfo = message;
    });
    // ignore: avoid_print
    print(message);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }
}

class GalleryScreen extends StatelessWidget {
  final List<String> media;

  const GalleryScreen({super.key, required this.media});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Gallery')),
      body: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 4,
          mainAxisSpacing: 4,
        ),
        itemCount: media.length,
        itemBuilder: (context, index) {
          final filePath = media[index];
          if (filePath.endsWith('.mp4')) {
            return const Icon(Icons.video_library, size: 50);
          } else {
            return Image.file(
              File(filePath),
              fit: BoxFit.cover,
            );
          }
        },
      ),
    );
  }
}
