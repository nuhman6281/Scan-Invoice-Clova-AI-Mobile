import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import '../models/scan_result.dart';
import '../utils/logger.dart';
import '../config/api_config.dart';

class ScanService {
  /// Scan an invoice image and get extracted items with better offers
  static Future<ScanApiResponse> scanInvoice({
    required File imageFile,
    required String timestamp,
    required String device,
  }) async {
    try {
      // Validate file exists and is readable
      if (!await imageFile.exists()) {
        throw Exception('Image file does not exist: ${imageFile.path}');
      }

      // Check file size (max 10MB)
      final fileSize = await imageFile.length();
      if (fileSize > 10 * 1024 * 1024) {
        throw Exception(
            'Image file is too large: ${(fileSize / 1024 / 1024).toStringAsFixed(2)}MB');
      }

      Logger.info('File size: ${(fileSize / 1024).toStringAsFixed(2)}KB');
      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConfig.scanUrl),
      );

      // Add image file with proper content type
      final fileName = imageFile.path.split('/').last;
      final fileExtension = fileName.split('.').last.toLowerCase();

      // Determine content type based on file extension
      MediaType? contentType;
      switch (fileExtension) {
        case 'jpg':
        case 'jpeg':
          contentType = MediaType('image', 'jpeg');
          break;
        case 'png':
          contentType = MediaType('image', 'png');
          break;
        case 'gif':
          contentType = MediaType('image', 'gif');
          break;
        case 'webp':
          contentType = MediaType('image', 'webp');
          break;
        default:
          contentType = MediaType('image', 'jpeg'); // Default fallback
      }

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
          contentType: contentType,
        ),
      );

      // Add metadata - matching the working curl example
      request.fields['timestamp'] = timestamp;
      request.fields['device'] = device;

      // Add additional headers that might be required
      request.headers['Accept'] = 'application/json';
      request.headers['User-Agent'] = 'Flutter/1.0';

      // Log file information for debugging
      Logger.info('File path: ${imageFile.path}');
      Logger.info('File name: $fileName');
      Logger.info('File extension: $fileExtension');
      Logger.info('Content type: $contentType');

      // Log curl equivalent for testing
      final curlCommand = '''curl --location '${ApiConfig.scanUrl}' \\
--form 'image=@"${imageFile.path}"' \\
--form 'timestamp="$timestamp"' \\
--form 'device="$device"''';

      Logger.info('Curl equivalent command:');
      Logger.info(curlCommand);
      print('=== CURL COMMAND FOR TESTING ===');
      print(curlCommand);
      print('================================');

      // Send request
      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      Logger.info('Raw API Response: $responseData');

      if (response.statusCode == 200) {
        // Parse the response using the new models
        final jsonResponse = json.decode(responseData);
        return ScanApiResponse.fromJson(jsonResponse);
      } else {
        throw Exception('API Error: ${response.statusCode} - $responseData');
      }
    } catch (e) {
      Logger.error('Error in scanInvoice: $e');
      rethrow;
    }
  }

  /// Test API connection
  static Future<Map<String, dynamic>> testConnection() async {
    try {
      final response = await http.get(
        Uri.parse(ApiConfig.healthUrl),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Health check failed: ${response.statusCode}');
      }
    } catch (e) {
      Logger.error('Error in testConnection: $e');
      rethrow;
    }
  }

  /// Test file upload with a simple text file to verify the endpoint works
  static Future<Map<String, dynamic>> testFileUpload() async {
    try {
      // Create a simple test file
      final testFile = File('/tmp/test_image.txt');
      await testFile.writeAsString('This is a test file for API validation');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse(ApiConfig.scanUrl),
      );

      // Add test file
      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          testFile.path,
          contentType: MediaType('text', 'plain'),
        ),
      );

      // Add metadata
      request.fields['timestamp'] = DateTime.now().toIso8601String();
      request.fields['device'] = 'Test Device';

      Logger.info('Testing file upload with text file...');

      var response = await request.send();
      var responseData = await response.stream.bytesToString();

      Logger.info('Test upload response: $responseData');

      if (response.statusCode == 200) {
        return json.decode(responseData);
      } else {
        throw Exception(
            'Test upload failed: ${response.statusCode} - $responseData');
      }
    } catch (e) {
      Logger.error('Error in testFileUpload: $e');
      rethrow;
    }
  }

  /// Convert ScanApiResponse to a display-friendly format
  static Map<String, dynamic> toDisplayFormat(ScanApiResponse response) {
    return {
      'success': response.success,
      'data': {
        'extractedItems': response.data.extractedItems
            .map((item) => {
                  'name': item.name,
                  'price': item.price,
                  'quantity': item.quantity,
                  'total': item.total,
                })
            .toList(),
        'total': response.data.total,
        'merchant': response.data.merchant,
        'betterOffers': response.data.betterOffers
            .map((offer) => {
                  'originalItem': {
                    'name': offer.originalItem.name,
                    'price': offer.originalItem.price,
                    'quantity': offer.originalItem.quantity,
                    'total': offer.originalItem.total,
                  },
                  'betterOffers': offer.betterOffers
                      .map((detail) => {
                            'productId': detail.productId,
                            'productName': detail.productName,
                            'shopName': detail.shopName,
                            'shopAddress': detail.shopAddress,
                            'shopRating': detail.shopRating,
                            'price': detail.price,
                            'savings': detail.savings,
                            'savingsPercentage': detail.savingsPercentage,
                          })
                      .toList(),
                })
            .toList(),
        'processingTime': response.data.processingTime,
        'accuracy': response.data.accuracy,
      },
    };
  }
}
