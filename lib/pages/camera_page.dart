import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart'; // go this from https://pub.dev/packages/permission_handler


class CameraPage extends StatefulWidget { 
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    try {
      final status = await Permission.camera.request();
      if (status.isPermanentlyDenied) {
        _showPermissionOptions();
        return;
      }
      if (status.isDenied) {
        final result = await Permission.camera.request();
        if (!result.isGranted) {
          _showPermissionOptions();
          return;
        }
      }
      _cameras = await availableCameras();
      if (_cameras != null && _cameras!.isNotEmpty) {
          _controller = CameraController(
          _cameras!.first,
          ResolutionPreset.medium,
          );
        await _controller!.initialize();
        setState(() {
          _isInitialized = true;
        });
      }
    } catch (e) {
      _showPermissionOptions();
    }
  }


  // If user denies permission, all them to change that from settings or go back to the form 
  void _showPermissionOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Camera Permission Denied'),
        content: const Text('Please allow camera access to take pictures.'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
              openAppSettings();

            },
            child: const Text('Open Settings'),
          ),
          TextButton(
            onPressed: () {
              // Close dialog and go back to form page
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _takePicture() async {
    if (_controller == null && _controller!.value.isInitialized) {
      Navigator.of(context).pop();
    }

    try {
      final image = await _controller!.takePicture();

      // save to app directory and return the file path
      final Directory appDir = Directory.systemTemp;
      final String imagePath = '${appDir.path}/${DateTime.now().millisecondsSinceEpoch}.png';
      await image.saveTo(imagePath);

      if (mounted) {
        Navigator.of(context).pop(File(imagePath));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error taking picture: $e'), backgroundColor: Colors.red,),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camera'),
      ),
      body: Center(
        child: _isInitialized
            ? CameraPreview(_controller!)
            : const CircularProgressIndicator(),
        ),
      floatingActionButton: _isInitialized
          ? FloatingActionButton.large(
              onPressed: _takePicture,
              child: const Icon(Icons.camera),
            )
          : null,
    );
  }
}