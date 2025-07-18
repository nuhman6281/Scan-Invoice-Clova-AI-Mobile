import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'scan_result.freezed.dart';
part 'scan_result.g.dart';

@freezed
class ScanApiResponse with _$ScanApiResponse {
  const factory ScanApiResponse({
    required bool success,
    required ScanData data,
    String? error,
  }) = _ScanApiResponse;

  factory ScanApiResponse.fromJson(Map<String, dynamic> json) =>
      _$ScanApiResponseFromJson(json);
}

@freezed
class ScanData with _$ScanData {
  const factory ScanData({
    @JsonKey(name: 'extractedItems')
    required List<ExtractedItem> extractedItems,
    required double total,
    required String merchant,
    @JsonKey(name: 'betterOffers') required List<BetterOffer> betterOffers,
    @JsonKey(name: 'processingTime') required int processingTime,
    required double accuracy,
  }) = _ScanData;

  factory ScanData.fromJson(Map<String, dynamic> json) =>
      _$ScanDataFromJson(json);
}

@freezed
class ExtractedItem with _$ExtractedItem {
  const factory ExtractedItem({
    required String name,
    required double price,
    required int quantity,
    required double total,
  }) = _ExtractedItem;

  factory ExtractedItem.fromJson(Map<String, dynamic> json) =>
      _$ExtractedItemFromJson(json);
}

@freezed
class BetterOffer with _$BetterOffer {
  const factory BetterOffer({
    @JsonKey(name: 'originalItem') required ExtractedItem originalItem,
    @JsonKey(name: 'betterOffers') required List<OfferDetail> betterOffers,
  }) = _BetterOffer;

  factory BetterOffer.fromJson(Map<String, dynamic> json) =>
      _$BetterOfferFromJson(json);
}

@freezed
class OfferDetail with _$OfferDetail {
  const factory OfferDetail({
    @JsonKey(name: 'productId') required String productId,
    @JsonKey(name: 'productName') required String productName,
    @JsonKey(name: 'shopName') required String shopName,
    @JsonKey(name: 'shopAddress') required String shopAddress,
    @JsonKey(name: 'shopRating') required String shopRating,
    required double price,
    required double savings,
    @JsonKey(name: 'savingsPercentage') required String savingsPercentage,
  }) = _OfferDetail;

  factory OfferDetail.fromJson(Map<String, dynamic> json) =>
      _$OfferDetailFromJson(json);
}

// Legacy models for backward compatibility
@freezed
class ScanResult with _$ScanResult {
  const factory ScanResult({
    required String scanId,
    required List<ScannedItem> scannedItems,
    required List<Alternative> alternatives,
    required ScanSummary summary,
    required int processingTimeMs,
    String? error,
    @JsonKey(name: 'model_used') String? modelUsed,
    Map<String, dynamic>? metadata,
  }) = _ScanResult;

  factory ScanResult.fromJson(Map<String, dynamic> json) =>
      _$ScanResultFromJson(json);
}

@freezed
class ScannedItem with _$ScannedItem {
  const factory ScannedItem({
    required String name,
    @JsonKey(name: 'normalized_name') required String normalizedName,
    required double price,
    required int quantity,
    String? category,
    double? confidence,
    String? brand,
    String? description,
  }) = _ScannedItem;

  factory ScannedItem.fromJson(Map<String, dynamic> json) =>
      _$ScannedItemFromJson(json);
}

@freezed
class Alternative with _$Alternative {
  const factory Alternative({
    @JsonKey(name: 'original_item') required String originalItem,
    required Shop shop,
    required Product product,
    required double savings,
    @JsonKey(name: 'savings_percentage') required double savingsPercentage,
    required double distance,
    @JsonKey(name: 'estimated_time') int? estimatedTime,
  }) = _Alternative;

  factory Alternative.fromJson(Map<String, dynamic> json) =>
      _$AlternativeFromJson(json);
}

@freezed
class Shop with _$Shop {
  const factory Shop({
    required String id,
    required String name,
    String? address,
    required double latitude,
    required double longitude,
    String? phone,
    double? rating,
    @JsonKey(name: 'is_premium') required bool isPremium,
    String? category,
    @JsonKey(name: 'image_url') String? imageUrl,
    String? description,
    @JsonKey(name: 'opening_hours') String? openingHours,
  }) = _Shop;

  factory Shop.fromJson(Map<String, dynamic> json) => _$ShopFromJson(json);
}

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    @JsonKey(name: 'shop_id') required String shopId,
    required String name,
    @JsonKey(name: 'normalized_name') required String normalizedName,
    String? category,
    required double price,
    @JsonKey(name: 'image_url') String? imageUrl,
    String? brand,
    String? description,
    required List<String> keywords,
    @JsonKey(name: 'is_available') required bool isAvailable,
    @JsonKey(name: 'stock_quantity') int? stockQuantity,
    String? barcode,
    double? weight,
    String? unit,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

@freezed
class ScanSummary with _$ScanSummary {
  const factory ScanSummary({
    @JsonKey(name: 'items_found') required int itemsFound,
    @JsonKey(name: 'alternatives_found') required int alternativesFound,
    @JsonKey(name: 'potential_savings') required double potentialSavings,
    @JsonKey(name: 'confidence_score') double? confidenceScore,
    @JsonKey(name: 'total_amount') required double totalAmount,
    @JsonKey(name: 'processing_time_ms') required int processingTimeMs,
  }) = _ScanSummary;

  factory ScanSummary.fromJson(Map<String, dynamic> json) =>
      _$ScanSummaryFromJson(json);
}

@freezed
class ScanRequest with _$ScanRequest {
  const factory ScanRequest({
    required String imagePath,
    required double latitude,
    required double longitude,
    double? radius,
    @JsonKey(name: 'premium_only') bool? premiumOnly,
    @JsonKey(name: 'confidence_threshold') double? confidenceThreshold,
    @JsonKey(name: 'use_fallback') bool? useFallback,
  }) = _ScanRequest;

  factory ScanRequest.fromJson(Map<String, dynamic> json) =>
      _$ScanRequestFromJson(json);
}

@freezed
class ScanHistory with _$ScanHistory {
  const factory ScanHistory({
    required String id,
    @JsonKey(name: 'image_path') String? imagePath,
    @JsonKey(name: 'scan_result') ScanResult? scanResult,
    @JsonKey(name: 'items_found') required int itemsFound,
    @JsonKey(name: 'alternatives_found') required int alternativesFound,
    @JsonKey(name: 'potential_savings') required double potentialSavings,
    @JsonKey(name: 'confidence_score') double? confidenceScore,
    @JsonKey(name: 'processing_time') int? processingTime,
    @JsonKey(name: 'user_latitude') double? userLatitude,
    @JsonKey(name: 'user_longitude') double? userLongitude,
    @JsonKey(name: 'user_id') String? userId,
    @JsonKey(name: 'device_info') Map<String, dynamic>? deviceInfo,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _ScanHistory;

  factory ScanHistory.fromJson(Map<String, dynamic> json) =>
      _$ScanHistoryFromJson(json);
}

@freezed
class ScanAnalytics with _$ScanAnalytics {
  const factory ScanAnalytics({
    @JsonKey(name: 'total_scans') required int totalScans,
    @JsonKey(name: 'successful_scans') required int successfulScans,
    @JsonKey(name: 'total_savings') required double totalSavings,
    @JsonKey(name: 'avg_processing_time') required int avgProcessingTime,
    @JsonKey(name: 'unique_users') required int uniqueUsers,
    @JsonKey(name: 'popular_items') List<PopularItem>? popularItems,
    @JsonKey(name: 'error_rate') required double errorRate,
    @JsonKey(name: 'date') required DateTime date,
  }) = _ScanAnalytics;

  factory ScanAnalytics.fromJson(Map<String, dynamic> json) =>
      _$ScanAnalyticsFromJson(json);
}

@freezed
class PopularItem with _$PopularItem {
  const factory PopularItem({
    required String name,
    required int scanCount,
    required double averagePrice,
    required double totalSavings,
  }) = _PopularItem;

  factory PopularItem.fromJson(Map<String, dynamic> json) =>
      _$PopularItemFromJson(json);
}
