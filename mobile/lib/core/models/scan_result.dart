import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_result.freezed.dart';
part 'scan_result.g.dart';

@freezed
class ScanResult with _$ScanResult {
  const factory ScanResult({
    required String scanId,
    required List<ScannedItem> scannedItems,
    required List<Alternative> alternatives,
    required ScanSummary summary,
    required int processingTimeMs,
  }) = _ScanResult;
  
  factory ScanResult.fromJson(Map<String, dynamic> json) =>
      _$ScanResultFromJson(json);
}

@freezed
class ScannedItem with _$ScannedItem {
  const factory ScannedItem({
    required String name,
    required String normalizedName,
    required double price,
    required int quantity,
    String? category,
    double? confidence,
  }) = _ScannedItem;
  
  factory ScannedItem.fromJson(Map<String, dynamic> json) =>
      _$ScannedItemFromJson(json);
}

@freezed
class Alternative with _$Alternative {
  const factory Alternative({
    required String originalItem,
    required Shop shop,
    required Product product,
    required double savings,
    required double savingsPercentage,
    required double distance,
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
    double? rating,
    required bool isPremium,
    String? category,
    String? imageUrl,
    double? distance,
  }) = _Shop;
  
  factory Shop.fromJson(Map<String, dynamic> json) =>
      _$ShopFromJson(json);
}

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required double price,
    String? category,
    String? brand,
    String? imageUrl,
  }) = _Product;
  
  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

@freezed
class ScanSummary with _$ScanSummary {
  const factory ScanSummary({
    required int itemsFound,
    required int alternativesFound,
    required double potentialSavings,
    required double confidenceScore,
  }) = _ScanSummary;
  
  factory ScanSummary.fromJson(Map<String, dynamic> json) =>
      _$ScanSummaryFromJson(json);
}