import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';

import '../../../../core/utils/logger.dart';
import '../../../../core/models/scan_result.dart';
import '../../../../core/services/scan_service.dart';
import '../../bloc/scan_bloc.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  final ImagePicker _picker = ImagePicker();
  File? _selectedImage;
  bool _isProcessing = false;
  Map<String, dynamic>? _scanResult;
  String? _errorMessage;
  String? _imageQualityInfo;

  @override
  void initState() {
    super.initState();
    // Pre-request permissions to avoid issues during camera/gallery access
    _preRequestPermissions();
  }

  Future<void> _preRequestPermissions() async {
    try {
      // Pre-request camera and photo permissions
      // This helps iOS debug builds to properly register the app for permissions
      await Permission.camera.status;
      await Permission.photos.status;

      // Log permission status for debugging
      final cameraStatus = await Permission.camera.status;
      final photosStatus = await Permission.photos.status;

      Logger.info('Camera permission status: $cameraStatus');
      Logger.info('Photos permission status: $photosStatus');
    } catch (e) {
      Logger.error('Error pre-requesting permissions: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Invoice'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Theme.of(context).primaryColor,
              Theme.of(context).primaryColor.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Instructions
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          size: 48,
                          color: Colors.blue.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Scan Your Invoice',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Take a photo or select an image of your invoice to analyze and find better prices',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 16,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Image Preview
                if (_selectedImage != null) ...[
                  Container(
                    height: 220,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.image,
                                color: Colors.green.shade600,
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Selected Image',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.green.shade700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomLeft: Radius.circular(16),
                              bottomRight: Radius.circular(16),
                            ),
                            child: Image.file(
                              _selectedImage!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],

                // Action Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isProcessing ? null : _takePhoto,
                        icon: const Icon(Icons.camera_alt),
                        label: const Text('Camera'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isProcessing ? null : _pickImage,
                        icon: const Icon(Icons.photo_library),
                        label: const Text('Gallery'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Theme.of(context).primaryColor,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 16),

                // Demo Mode Button
                ElevatedButton(
                  onPressed: _isProcessing ? null : _demoMode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purple,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.play_arrow),
                      SizedBox(width: 8),
                      Text(
                        'Demo Mode (No Camera)',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Process Button
                if (_selectedImage != null)
                  ElevatedButton(
                    onPressed: _isProcessing ? null : _processImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isProcessing
                        ? const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                              SizedBox(width: 12),
                              Text('Processing...'),
                            ],
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search),
                              SizedBox(width: 8),
                              Text(
                                'Analyze Invoice',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                  ),

                const SizedBox(height: 16),

                // Results
                if (_scanResult != null) ...[
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          blurRadius: 20,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header Section
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.green.shade400,
                                Colors.green.shade600,
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Icon(
                                  _scanResult!['success']
                                      ? Icons.check_circle
                                      : Icons.error,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Invoice Scan Complete',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      _scanResult!['success']
                                          ? 'Successfully processed invoice'
                                          : 'Failed to process invoice',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white.withOpacity(0.9),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (_scanResult!['data'] != null) ...[
                          // Summary Cards Section
                          Container(
                            padding: const EdgeInsets.all(20),
                            child: Column(
                              children: [
                                // Summary Cards Row 1
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildSummaryCard(
                                        icon: Icons.store,
                                        title: 'Merchant',
                                        value: _scanResult!['data']
                                                ['merchant'] ??
                                            'Unknown',
                                        color: Colors.blue,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildSummaryCard(
                                        icon: Icons.shopping_cart,
                                        title: 'Items Found',
                                        value:
                                            '${_scanResult!['data']['extractedItems'].length}',
                                        color: Colors.orange,
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // Summary Cards Row 2
                                Row(
                                  children: [
                                    Expanded(
                                      child: _buildSummaryCard(
                                        icon: Icons.timer,
                                        title: 'Processing Time',
                                        value:
                                            '${_scanResult!['data']['processingTime']}ms',
                                        color: Colors.purple,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: _buildSummaryCard(
                                        icon: Icons.analytics,
                                        title: 'Accuracy',
                                        value:
                                            '${(_scanResult!['data']['accuracy'] * 100).toStringAsFixed(1)}%',
                                        color: Colors.green,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),

                          // Extracted Items Section
                          if (_scanResult!['data']['extractedItems']
                              .isNotEmpty) ...[
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: _buildSectionHeader(
                                'Extracted Items',
                                Icons.receipt_long,
                                Colors.indigo,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: _scanResult!['data']['extractedItems']
                                    .map<Widget>((item) => _buildItemCard(
                                        item,
                                        _scanResult!['data']['extractedItems']
                                            .indexOf(item)))
                                    .toList(),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],

                          // Better Offers Section
                          if (_scanResult!['data']['betterOffers']
                              .isNotEmpty) ...[
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: _buildSectionHeader(
                                'Better Offers Available',
                                Icons.local_offer,
                                Colors.green,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              child: Column(
                                children: _scanResult!['data']['betterOffers']
                                    .map<Widget>((offer) =>
                                        _buildBetterOfferCard(
                                            offer,
                                            _scanResult!['data']['betterOffers']
                                                .indexOf(offer)))
                                    .toList(),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],

                          // Total Savings Section
                          if (_scanResult!['data']['betterOffers']
                              .isNotEmpty) ...[
                            Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 20),
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Colors.green.shade400,
                                    Colors.green.shade600
                                  ],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: const Icon(
                                      Icons.savings,
                                      color: Colors.white,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'Potential Savings',
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          'Tap on offers above to see details',
                                          style: TextStyle(
                                            color:
                                                Colors.white.withOpacity(0.9),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ],
                      ],
                    ),
                  ),
                ],

                // Error Message
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.error, color: Colors.red.shade600),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: TextStyle(color: Colors.red.shade700),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // API Test Button
                ElevatedButton(
                  onPressed: _testApiConnection,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Test API Connection'),
                ),

                const SizedBox(height: 12),

                // Permission Check Button
                ElevatedButton(
                  onPressed: _checkPermissions,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Check Permissions'),
                ),

                // Bottom padding for safe area
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _takePhoto() async {
    try {
      // Let image_picker handle the permission request directly
      // This is more reliable for iOS debug builds
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 4096, // Increased to 4K resolution
        maxHeight: 4096, // Increased to 4K resolution
        imageQuality: 100, // Maximum quality to avoid compression
        preferredCameraDevice: CameraDevice.rear,
        requestFullMetadata: true, // Request full metadata for better quality
      );

      if (photo != null) {
        final imageFile = File(photo.path);
        final fileSize = await imageFile.length();
        final fileSizeKB = (fileSize / 1024).toStringAsFixed(2);

        Logger.info('Photo captured successfully: ${photo.path}');
        Logger.info('File size: ${fileSizeKB}KB');
        Logger.info('File name: ${photo.name}');
        Logger.info('File extension: ${photo.name.split('.').last}');

        setState(() {
          _selectedImage = imageFile;
          _scanResult = null;
          _errorMessage = null;
        });

        // Update image quality information
        await _updateImageQualityInfo(imageFile);
      } else {
        Logger.info('Photo capture cancelled by user');
      }
    } catch (e) {
      Logger.error('Error taking photo: $e');

      // Handle specific permission errors
      if (e.toString().contains('permission') ||
          e.toString().contains('denied')) {
        _showDebugPermissionDialog(
          'Camera Permission Required',
          'Camera access is required to scan invoices. In debug mode, you may need to:\n\n1. Go to Settings > Privacy & Security > Camera\n2. Find this app and enable camera access\n3. If the app is not listed, try running the app again after granting permission.',
          'Camera',
        );
      } else {
        _showError('Error taking photo: $e');
      }
    }
  }

  Future<void> _pickImage() async {
    try {
      // Let image_picker handle the permission request directly
      // This is more reliable for iOS debug builds
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 4096, // Increased to 4K resolution
        maxHeight: 4096, // Increased to 4K resolution
        imageQuality: 100, // Maximum quality to avoid compression
        requestFullMetadata: true, // Request full metadata for better quality
      );

      if (image != null) {
        final imageFile = File(image.path);
        final fileSize = await imageFile.length();
        final fileSizeKB = (fileSize / 1024).toStringAsFixed(2);

        Logger.info('Image selected successfully: ${image.path}');
        Logger.info('File size: ${fileSizeKB}KB');
        Logger.info('File name: ${image.name}');
        Logger.info('File extension: ${image.name.split('.').last}');

        setState(() {
          _selectedImage = imageFile;
          _scanResult = null;
          _errorMessage = null;
        });

        // Update image quality information
        await _updateImageQualityInfo(imageFile);
      } else {
        Logger.info('Image selection cancelled by user');
      }
    } catch (e) {
      Logger.error('Error picking image: $e');

      // Handle specific permission errors
      if (e.toString().contains('permission') ||
          e.toString().contains('denied')) {
        _showDebugPermissionDialog(
          'Photo Library Permission Required',
          'Photo library access is required to select images. In debug mode, you may need to:\n\n1. Go to Settings > Privacy & Security > Photos\n2. Find this app and enable photo library access\n3. If the app is not listed, try running the app again after granting permission.',
          'Photos',
        );
      } else {
        _showError('Error picking image: $e');
      }
    }
  }

  Future<void> _demoMode() async {
    setState(() {
      _isProcessing = true;
      _scanResult = null;
      _errorMessage = null;
    });

    try {
      // Simulate processing delay
      await Future.delayed(const Duration(seconds: 2));

      // Create a mock scan result
      final mockResult = {
        'status': 'success',
        'message': 'Demo mode - Invoice processed successfully',
        'data': {
          'invoice_number': 'INV-2024-001',
          'total_amount': 125.50,
          'currency': 'USD',
          'merchant': 'Demo Store',
          'date': DateTime.now().toIso8601String(),
          'items': [
            {'name': 'Product 1', 'price': 25.00, 'quantity': 2},
            {'name': 'Product 2', 'price': 75.50, 'quantity': 1},
          ],
          'nearby_shops': [
            {'name': 'Shop A', 'distance': '0.5km', 'price': 120.00},
            {'name': 'Shop B', 'distance': '1.2km', 'price': 115.00},
            {'name': 'Shop C', 'distance': '2.1km', 'price': 110.00},
          ]
        }
      };

      setState(() {
        _scanResult = mockResult;
        _isProcessing = false;
      });

      Logger.info('Demo mode completed successfully');
    } catch (e) {
      setState(() {
        _errorMessage = 'Demo mode error: $e';
        _isProcessing = false;
      });
      Logger.error('Demo mode error: $e');
    }
  }

  Future<void> _processImage() async {
    if (_selectedImage == null) return;

    setState(() {
      _isProcessing = true;
      _scanResult = null;
      _errorMessage = null;
    });

    try {
      // Log image details before processing
      final fileSize = await _selectedImage!.length();
      final fileSizeKB = (fileSize / 1024).toStringAsFixed(2);
      Logger.info('Processing image: ${_selectedImage!.path}');
      Logger.info('File size: ${fileSizeKB}KB');
      Logger.info('File name: ${_selectedImage!.path.split('/').last}');
      Logger.info('File extension: ${_selectedImage!.path.split('.').last}');

      // Optionally enhance image quality for better API results
      File imageToProcess = _selectedImage!;
      if (fileSize < 500 * 1024) {
        // If image is smaller than 500KB
        Logger.info('Attempting to enhance image quality...');
        final enhancedImage = await _enhanceImageQuality(_selectedImage!);
        if (enhancedImage != null) {
          imageToProcess = enhancedImage;
          Logger.info('Using enhanced image for processing');
        }
      }

      // Use the scan service to process the image
      final scanResponse = await ScanService.scanInvoice(
        imageFile: imageToProcess,
        timestamp: DateTime.now().toIso8601String(),
        device: 'iOS Device',
      );

      if (scanResponse.success) {
        setState(() {
          _scanResult = ScanService.toDisplayFormat(scanResponse);
          _isProcessing = false;
        });
        Logger.info(
            'Scan successful: ${scanResponse.data.extractedItems.length} items found');
      } else {
        setState(() {
          _errorMessage = 'API returned success=false: ${scanResponse.error}';
          _isProcessing = false;
        });
        Logger.error('Scan failed: ${scanResponse.error}');
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Error processing image: $e';
        _isProcessing = false;
      });
      Logger.error('Error processing image: $e');
    }
  }

  /// Calculate and display image quality information
  Future<void> _updateImageQualityInfo(File imageFile) async {
    try {
      final fileSize = await imageFile.length();
      final fileSizeKB = (fileSize / 1024).toStringAsFixed(2);

      String qualityLevel;
      Color qualityColor;

      if (fileSize > 1000 * 1024) {
        // > 1MB
        qualityLevel = 'Excellent';
        qualityColor = Colors.green;
      } else if (fileSize > 500 * 1024) {
        // > 500KB
        qualityLevel = 'Good';
        qualityColor = Colors.orange;
      } else if (fileSize > 200 * 1024) {
        // > 200KB
        qualityLevel = 'Fair';
        qualityColor = Colors.red;
      } else {
        qualityLevel = 'Poor';
        qualityColor = Colors.red;
      }

      setState(() {
        _imageQualityInfo = 'Size: ${fileSizeKB}KB | Quality: $qualityLevel';
      });

      Logger.info('Image quality: $qualityLevel (${fileSizeKB}KB)');
    } catch (e) {
      Logger.error('Error calculating image quality: $e');
    }
  }

  /// Enhance image quality if needed for better API results
  Future<File?> _enhanceImageQuality(File originalImage) async {
    try {
      final originalSize = await originalImage.length();
      final originalSizeKB = (originalSize / 1024).toStringAsFixed(2);

      Logger.info('Original image size: ${originalSizeKB}KB');

      // If image is already large enough (> 500KB), don't enhance
      if (originalSize > 500 * 1024) {
        Logger.info('Image is already high quality, skipping enhancement');
        return originalImage;
      }

      // Read the original image
      final bytes = await originalImage.readAsBytes();

      // Enhance image quality by compressing with high quality settings
      // This can sometimes improve image clarity for OCR
      final enhancedBytes = await FlutterImageCompress.compressWithList(
        bytes,
        quality: 95, // High quality
        minWidth: 1920, // Minimum width
        minHeight: 1080, // Minimum height
        rotate: 0, // No rotation
      );

      final enhancedSizeKB = (enhancedBytes.length / 1024).toStringAsFixed(2);
      Logger.info('Enhanced image size: ${enhancedSizeKB}KB');

      // Create a temporary file for the enhanced image
      final tempDir = Directory.systemTemp;
      final enhancedFile = File(
          '${tempDir.path}/enhanced_${DateTime.now().millisecondsSinceEpoch}.jpg');
      await enhancedFile.writeAsBytes(enhancedBytes);

      Logger.info('Image enhancement completed: ${enhancedFile.path}');
      return enhancedFile;
    } catch (e) {
      Logger.error('Error enhancing image quality: $e');
      // Return original image if enhancement fails
      return originalImage;
    }
  }

  Future<void> _testApiConnection() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      final data = await ScanService.testConnection();
      _showSuccess('API Connection Successful!\nStatus: ${data['status']}');
      Logger.info('API test successful: $data');
    } catch (e) {
      _showError('API Connection Error: $e');
      Logger.error('API test error: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  Future<void> _checkPermissions() async {
    setState(() {
      _isProcessing = true;
      _errorMessage = null;
    });

    try {
      final cameraStatus = await Permission.camera.status;
      final photosStatus = await Permission.photos.status;

      String message = 'Permission Status:\n\n';
      message += 'Camera: ${_getPermissionStatusText(cameraStatus)}\n';
      message += 'Photos: ${_getPermissionStatusText(photosStatus)}\n\n';

      if (cameraStatus.isDenied || photosStatus.isDenied) {
        message += 'To grant permissions:\n';
        message += '1. Tap "Request Permissions" below\n';
        message += '2. Or go to Settings > Privacy & Security\n';
        message += '3. Find this app and enable access';
      }

      _showPermissionStatusDialog(message, cameraStatus, photosStatus);

      Logger.info('Camera permission: $cameraStatus');
      Logger.info('Photos permission: $photosStatus');
    } catch (e) {
      _showError('Error checking permissions: $e');
      Logger.error('Permission check error: $e');
    } finally {
      setState(() {
        _isProcessing = false;
      });
    }
  }

  String _getPermissionStatusText(PermissionStatus status) {
    switch (status) {
      case PermissionStatus.granted:
        return '✅ Granted';
      case PermissionStatus.denied:
        return '❌ Denied';
      case PermissionStatus.permanentlyDenied:
        return '🚫 Permanently Denied';
      case PermissionStatus.restricted:
        return '🔒 Restricted';
      case PermissionStatus.limited:
        return '📱 Limited';
      case PermissionStatus.provisional:
        return '⏳ Provisional';
      default:
        return '❓ Unknown';
    }
  }

  void _showError(String message) {
    setState(() {
      _errorMessage = message;
    });
  }

  void _showSuccess(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPermissionDialog(String title, String message,
      String permissionName, Permission permission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final status = await permission.request();
              if (status.isGranted) {
                // Retry the action that was originally requested
                if (permission == Permission.camera) {
                  _takePhoto();
                } else if (permission == Permission.photos) {
                  _pickImage();
                }
              }
            },
            child: const Text('Grant Permission'),
          ),
        ],
      ),
    );
  }

  void _showSettingsDialog(
      String title, String message, String permissionName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  void _showDebugPermissionDialog(
      String title, String message, String permissionName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Debug Mode Note:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      '• Debug apps may not appear in Settings immediately\n'
                      '• Try restarting the app after granting permission\n'
                      '• Use the Demo Mode button to test without camera',
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _demoMode(); // Offer demo mode as alternative
            },
            child: const Text('Try Demo Mode'),
          ),
        ],
      ),
    );
  }

  void _showPermissionStatusDialog(String message,
      PermissionStatus cameraStatus, PermissionStatus photosStatus) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Permission Status'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(message),
              if (cameraStatus.isDenied || photosStatus.isDenied) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.orange.shade200),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Debug Build Note:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.orange,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        '• Debug apps may not appear in Settings immediately\n'
                        '• Try the "Request Permissions" button below\n'
                        '• Or restart the app and try again',
                        style: TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          if (cameraStatus.isDenied || photosStatus.isDenied)
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                await _requestAllPermissions();
              },
              child: const Text('Request Permissions'),
            ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Future<void> _requestAllPermissions() async {
    try {
      final cameraResult = await Permission.camera.request();
      final photosResult = await Permission.photos.request();

      Logger.info('Camera permission request result: $cameraResult');
      Logger.info('Photos permission request result: $photosResult');

      if (cameraResult.isGranted && photosResult.isGranted) {
        _showSuccess('All permissions granted successfully!');
      } else {
        _showError(
            'Some permissions were not granted. Please check the permission status again.');
      }
    } catch (e) {
      Logger.error('Error requesting permissions: $e');
      _showError('Error requesting permissions: $e');
    }
  }

  // UI Helper Methods
  Widget _buildSummaryCard({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade800,
          ),
        ),
      ],
    );
  }

  Widget _buildItemCard(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.indigo.shade400, Colors.indigo.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                '${index + 1}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['name'] ?? 'Unknown Item',
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        'Qty: ${item['quantity']}',
                        style: TextStyle(
                          color: Colors.orange.shade700,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${item['price']}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.green.shade700,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Total: ₹${item['total']}',
                  style: TextStyle(
                    color: Colors.green.shade700,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBetterOfferCard(Map<String, dynamic> offer, int index) {
    final originalItem = offer['originalItem'];
    final betterOffers = offer['betterOffers'] as List;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Original Item Header
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.orange.shade50, Colors.orange.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade500,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.shopping_bag,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        originalItem['name'] ?? 'Unknown Item',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black87,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Qty: ${originalItem['quantity']}',
                              style: TextStyle(
                                color: Colors.orange.shade800,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Current: ₹${originalItem['price']}',
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade500,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${betterOffers.length} offers',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Better Offers List
          ...betterOffers.take(3).map((betterOffer) => Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  border: Border(
                    top: BorderSide(color: Colors.grey.shade200),
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.green.shade500,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            betterOffer['productName'] ?? 'Unknown Product',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.black87,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.store,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  betterOffer['shopName'] ?? 'Unknown Shop',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.star,
                                size: 16,
                                color: Colors.amber.shade600,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${betterOffer['shopRating']} ★',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  betterOffer['shopAddress'] ??
                                      'Unknown Address',
                                  style: TextStyle(
                                    color: Colors.grey.shade600,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '₹${betterOffer['price']}',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: Colors.green.shade700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            'Save ₹${betterOffer['savings']}',
                            style: TextStyle(
                              color: Colors.green.shade700,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '${betterOffer['savingsPercentage']}% off',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              )),

          // Show more offers if available
          if (betterOffers.length > 3)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.expand_more,
                    color: Colors.grey.shade600,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${betterOffers.length - 3} more offers available',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
