import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:camera/camera.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'dart:io';

import '../bloc/scan_bloc.dart';
import '../widgets/scan_overlay.dart';
import '../widgets/scan_button.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> with WidgetsBindingObserver {
  CameraController? _controller;
  bool _isProcessing = false;
  bool _isCameraInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _initializeCamera();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return;
    }
    if (state == AppLifecycleState.inactive) {
      _controller?.dispose();
    } else if (state == AppLifecycleState.resumed) {
      _initializeCamera();
    }
  }

  Future<void> _initializeCamera() async {
    try {
      // Request camera permission
      final status = await Permission.camera.request();
      if (status != PermissionStatus.granted) {
        _showPermissionDialog('Camera permission is required to scan invoices.');
        return;
      }

      // Get available cameras
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        _showErrorDialog('No cameras found on this device.');
        return;
      }

      // Initialize camera controller
      _controller = CameraController(
        cameras.first,
        ResolutionPreset.high,
        enableAudio: false,
        imageFormatGroup: ImageFormatGroup.jpeg,
      );

      await _controller!.initialize();
      
      if (mounted) {
        setState(() {
          _isCameraInitialized = true;
        });
      }
    } catch (e) {
      _showErrorDialog('Failed to initialize camera: $e');
    }
  }

  Future<void> _scanInvoice() async {
    if (_controller == null || _isProcessing || !_isCameraInitialized) {
      return;
    }

    setState(() {
      _isProcessing = true;
    });

    try {
      // Request location permission
      final locationStatus = await Permission.location.request();
      if (locationStatus != PermissionStatus.granted) {
        _showPermissionDialog('Location permission is required to find nearby shops.');
        return;
      }

      // Capture image
      final image = await _controller!.takePicture();
      
      // Get current location
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Compress image
      final compressedFile = await FlutterImageCompress.compressAndGetFile(
        image.path,
        '${image.path}_compressed.jpg',
        quality: 80,
        minWidth: 800,
        minHeight: 600,
      );

      if (compressedFile == null) {
        throw Exception('Failed to compress image');
      }

      // Send scan request
      context.read<ScanBloc>().add(
        ScanInvoiceEvent(
          imageFile: File(compressedFile.path),
          latitude: position.latitude,
          longitude: position.longitude,
        ),
      );

    } catch (e) {
      _showErrorDialog('Scan failed: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }

  void _showPermissionDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Required'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<ScanBloc, ScanState>(
        listener: (context, state) {
          if (state is ScanSuccess) {
            // Navigate to results page
            Navigator.of(context).pushNamed('/results', arguments: state.result);
          } else if (state is ScanFailure) {
            _showErrorDialog(state.message);
          }
        },
        child: Stack(
          children: [
            // Camera preview
            if (_isCameraInitialized && _controller != null)
              CameraPreview(_controller!)
            else
              const Center(
                child: CircularProgressIndicator(),
              ),

            // Scanning overlay
            const ScanOverlay(),

            // Top app bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: EdgeInsets.only(
                  top: MediaQuery.of(context).padding.top + 16,
                  left: 16,
                  right: 16,
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const Expanded(
                      child: Text(
                        'Scan Invoice',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),
            ),

            // Scan button
            Positioned(
              bottom: 50,
              left: 0,
              right: 0,
              child: Center(
                child: ScanButton(
                  onPressed: _isProcessing ? null : _scanInvoice,
                  isProcessing: _isProcessing,
                ),
              ),
            ),

            // Loading indicator
            if (_isProcessing)
              Container(
                color: Colors.black54,
                child: const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: Colors.white,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'Processing Invoice...',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}