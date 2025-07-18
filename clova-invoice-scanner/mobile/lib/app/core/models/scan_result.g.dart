// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ScanApiResponseImpl _$$ScanApiResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$ScanApiResponseImpl(
      success: json['success'] as bool,
      data: ScanData.fromJson(json['data'] as Map<String, dynamic>),
      error: json['error'] as String?,
    );

Map<String, dynamic> _$$ScanApiResponseImplToJson(
        _$ScanApiResponseImpl instance) =>
    <String, dynamic>{
      'success': instance.success,
      'data': instance.data,
      'error': instance.error,
    };

_$ScanDataImpl _$$ScanDataImplFromJson(Map<String, dynamic> json) =>
    _$ScanDataImpl(
      extractedItems: (json['extractedItems'] as List<dynamic>)
          .map((e) => ExtractedItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: (json['total'] as num).toDouble(),
      merchant: json['merchant'] as String,
      betterOffers: (json['betterOffers'] as List<dynamic>)
          .map((e) => BetterOffer.fromJson(e as Map<String, dynamic>))
          .toList(),
      processingTime: (json['processingTime'] as num).toInt(),
      accuracy: (json['accuracy'] as num).toDouble(),
    );

Map<String, dynamic> _$$ScanDataImplToJson(_$ScanDataImpl instance) =>
    <String, dynamic>{
      'extractedItems': instance.extractedItems,
      'total': instance.total,
      'merchant': instance.merchant,
      'betterOffers': instance.betterOffers,
      'processingTime': instance.processingTime,
      'accuracy': instance.accuracy,
    };

_$ExtractedItemImpl _$$ExtractedItemImplFromJson(Map<String, dynamic> json) =>
    _$ExtractedItemImpl(
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      total: (json['total'] as num).toDouble(),
    );

Map<String, dynamic> _$$ExtractedItemImplToJson(_$ExtractedItemImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
      'total': instance.total,
    };

_$BetterOfferImpl _$$BetterOfferImplFromJson(Map<String, dynamic> json) =>
    _$BetterOfferImpl(
      originalItem:
          ExtractedItem.fromJson(json['originalItem'] as Map<String, dynamic>),
      betterOffers: (json['betterOffers'] as List<dynamic>)
          .map((e) => OfferDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$BetterOfferImplToJson(_$BetterOfferImpl instance) =>
    <String, dynamic>{
      'originalItem': instance.originalItem,
      'betterOffers': instance.betterOffers,
    };

_$OfferDetailImpl _$$OfferDetailImplFromJson(Map<String, dynamic> json) =>
    _$OfferDetailImpl(
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      shopName: json['shopName'] as String,
      shopAddress: json['shopAddress'] as String,
      shopRating: json['shopRating'] as String,
      price: (json['price'] as num).toDouble(),
      savings: (json['savings'] as num).toDouble(),
      savingsPercentage: json['savingsPercentage'] as String,
    );

Map<String, dynamic> _$$OfferDetailImplToJson(_$OfferDetailImpl instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'productName': instance.productName,
      'shopName': instance.shopName,
      'shopAddress': instance.shopAddress,
      'shopRating': instance.shopRating,
      'price': instance.price,
      'savings': instance.savings,
      'savingsPercentage': instance.savingsPercentage,
    };

_$ScanResultImpl _$$ScanResultImplFromJson(Map<String, dynamic> json) =>
    _$ScanResultImpl(
      scanId: json['scanId'] as String,
      scannedItems: (json['scannedItems'] as List<dynamic>)
          .map((e) => ScannedItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      alternatives: (json['alternatives'] as List<dynamic>)
          .map((e) => Alternative.fromJson(e as Map<String, dynamic>))
          .toList(),
      summary: ScanSummary.fromJson(json['summary'] as Map<String, dynamic>),
      processingTimeMs: (json['processingTimeMs'] as num).toInt(),
      error: json['error'] as String?,
      modelUsed: json['model_used'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );

Map<String, dynamic> _$$ScanResultImplToJson(_$ScanResultImpl instance) =>
    <String, dynamic>{
      'scanId': instance.scanId,
      'scannedItems': instance.scannedItems,
      'alternatives': instance.alternatives,
      'summary': instance.summary,
      'processingTimeMs': instance.processingTimeMs,
      'error': instance.error,
      'model_used': instance.modelUsed,
      'metadata': instance.metadata,
    };

_$ScannedItemImpl _$$ScannedItemImplFromJson(Map<String, dynamic> json) =>
    _$ScannedItemImpl(
      name: json['name'] as String,
      normalizedName: json['normalized_name'] as String,
      price: (json['price'] as num).toDouble(),
      quantity: (json['quantity'] as num).toInt(),
      category: json['category'] as String?,
      confidence: (json['confidence'] as num?)?.toDouble(),
      brand: json['brand'] as String?,
      description: json['description'] as String?,
    );

Map<String, dynamic> _$$ScannedItemImplToJson(_$ScannedItemImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'normalized_name': instance.normalizedName,
      'price': instance.price,
      'quantity': instance.quantity,
      'category': instance.category,
      'confidence': instance.confidence,
      'brand': instance.brand,
      'description': instance.description,
    };

_$AlternativeImpl _$$AlternativeImplFromJson(Map<String, dynamic> json) =>
    _$AlternativeImpl(
      originalItem: json['original_item'] as String,
      shop: Shop.fromJson(json['shop'] as Map<String, dynamic>),
      product: Product.fromJson(json['product'] as Map<String, dynamic>),
      savings: (json['savings'] as num).toDouble(),
      savingsPercentage: (json['savings_percentage'] as num).toDouble(),
      distance: (json['distance'] as num).toDouble(),
      estimatedTime: (json['estimated_time'] as num?)?.toInt(),
    );

Map<String, dynamic> _$$AlternativeImplToJson(_$AlternativeImpl instance) =>
    <String, dynamic>{
      'original_item': instance.originalItem,
      'shop': instance.shop,
      'product': instance.product,
      'savings': instance.savings,
      'savings_percentage': instance.savingsPercentage,
      'distance': instance.distance,
      'estimated_time': instance.estimatedTime,
    };

_$ShopImpl _$$ShopImplFromJson(Map<String, dynamic> json) => _$ShopImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      address: json['address'] as String?,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      phone: json['phone'] as String?,
      rating: (json['rating'] as num?)?.toDouble(),
      isPremium: json['is_premium'] as bool,
      category: json['category'] as String?,
      imageUrl: json['image_url'] as String?,
      description: json['description'] as String?,
      openingHours: json['opening_hours'] as String?,
    );

Map<String, dynamic> _$$ShopImplToJson(_$ShopImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'address': instance.address,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'phone': instance.phone,
      'rating': instance.rating,
      'is_premium': instance.isPremium,
      'category': instance.category,
      'image_url': instance.imageUrl,
      'description': instance.description,
      'opening_hours': instance.openingHours,
    };

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: json['id'] as String,
      shopId: json['shop_id'] as String,
      name: json['name'] as String,
      normalizedName: json['normalized_name'] as String,
      category: json['category'] as String?,
      price: (json['price'] as num).toDouble(),
      imageUrl: json['image_url'] as String?,
      brand: json['brand'] as String?,
      description: json['description'] as String?,
      keywords:
          (json['keywords'] as List<dynamic>).map((e) => e as String).toList(),
      isAvailable: json['is_available'] as bool,
      stockQuantity: (json['stock_quantity'] as num?)?.toInt(),
      barcode: json['barcode'] as String?,
      weight: (json['weight'] as num?)?.toDouble(),
      unit: json['unit'] as String?,
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'shop_id': instance.shopId,
      'name': instance.name,
      'normalized_name': instance.normalizedName,
      'category': instance.category,
      'price': instance.price,
      'image_url': instance.imageUrl,
      'brand': instance.brand,
      'description': instance.description,
      'keywords': instance.keywords,
      'is_available': instance.isAvailable,
      'stock_quantity': instance.stockQuantity,
      'barcode': instance.barcode,
      'weight': instance.weight,
      'unit': instance.unit,
    };

_$ScanSummaryImpl _$$ScanSummaryImplFromJson(Map<String, dynamic> json) =>
    _$ScanSummaryImpl(
      itemsFound: (json['items_found'] as num).toInt(),
      alternativesFound: (json['alternatives_found'] as num).toInt(),
      potentialSavings: (json['potential_savings'] as num).toDouble(),
      confidenceScore: (json['confidence_score'] as num?)?.toDouble(),
      totalAmount: (json['total_amount'] as num).toDouble(),
      processingTimeMs: (json['processing_time_ms'] as num).toInt(),
    );

Map<String, dynamic> _$$ScanSummaryImplToJson(_$ScanSummaryImpl instance) =>
    <String, dynamic>{
      'items_found': instance.itemsFound,
      'alternatives_found': instance.alternativesFound,
      'potential_savings': instance.potentialSavings,
      'confidence_score': instance.confidenceScore,
      'total_amount': instance.totalAmount,
      'processing_time_ms': instance.processingTimeMs,
    };

_$ScanRequestImpl _$$ScanRequestImplFromJson(Map<String, dynamic> json) =>
    _$ScanRequestImpl(
      imagePath: json['imagePath'] as String,
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      radius: (json['radius'] as num?)?.toDouble(),
      premiumOnly: json['premium_only'] as bool?,
      confidenceThreshold: (json['confidence_threshold'] as num?)?.toDouble(),
      useFallback: json['use_fallback'] as bool?,
    );

Map<String, dynamic> _$$ScanRequestImplToJson(_$ScanRequestImpl instance) =>
    <String, dynamic>{
      'imagePath': instance.imagePath,
      'latitude': instance.latitude,
      'longitude': instance.longitude,
      'radius': instance.radius,
      'premium_only': instance.premiumOnly,
      'confidence_threshold': instance.confidenceThreshold,
      'use_fallback': instance.useFallback,
    };

_$ScanHistoryImpl _$$ScanHistoryImplFromJson(Map<String, dynamic> json) =>
    _$ScanHistoryImpl(
      id: json['id'] as String,
      imagePath: json['image_path'] as String?,
      scanResult: json['scan_result'] == null
          ? null
          : ScanResult.fromJson(json['scan_result'] as Map<String, dynamic>),
      itemsFound: (json['items_found'] as num).toInt(),
      alternativesFound: (json['alternatives_found'] as num).toInt(),
      potentialSavings: (json['potential_savings'] as num).toDouble(),
      confidenceScore: (json['confidence_score'] as num?)?.toDouble(),
      processingTime: (json['processing_time'] as num?)?.toInt(),
      userLatitude: (json['user_latitude'] as num?)?.toDouble(),
      userLongitude: (json['user_longitude'] as num?)?.toDouble(),
      userId: json['user_id'] as String?,
      deviceInfo: json['device_info'] as Map<String, dynamic>?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$ScanHistoryImplToJson(_$ScanHistoryImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'image_path': instance.imagePath,
      'scan_result': instance.scanResult,
      'items_found': instance.itemsFound,
      'alternatives_found': instance.alternativesFound,
      'potential_savings': instance.potentialSavings,
      'confidence_score': instance.confidenceScore,
      'processing_time': instance.processingTime,
      'user_latitude': instance.userLatitude,
      'user_longitude': instance.userLongitude,
      'user_id': instance.userId,
      'device_info': instance.deviceInfo,
      'created_at': instance.createdAt.toIso8601String(),
    };

_$ScanAnalyticsImpl _$$ScanAnalyticsImplFromJson(Map<String, dynamic> json) =>
    _$ScanAnalyticsImpl(
      totalScans: (json['total_scans'] as num).toInt(),
      successfulScans: (json['successful_scans'] as num).toInt(),
      totalSavings: (json['total_savings'] as num).toDouble(),
      avgProcessingTime: (json['avg_processing_time'] as num).toInt(),
      uniqueUsers: (json['unique_users'] as num).toInt(),
      popularItems: (json['popular_items'] as List<dynamic>?)
          ?.map((e) => PopularItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      errorRate: (json['error_rate'] as num).toDouble(),
      date: DateTime.parse(json['date'] as String),
    );

Map<String, dynamic> _$$ScanAnalyticsImplToJson(_$ScanAnalyticsImpl instance) =>
    <String, dynamic>{
      'total_scans': instance.totalScans,
      'successful_scans': instance.successfulScans,
      'total_savings': instance.totalSavings,
      'avg_processing_time': instance.avgProcessingTime,
      'unique_users': instance.uniqueUsers,
      'popular_items': instance.popularItems,
      'error_rate': instance.errorRate,
      'date': instance.date.toIso8601String(),
    };

_$PopularItemImpl _$$PopularItemImplFromJson(Map<String, dynamic> json) =>
    _$PopularItemImpl(
      name: json['name'] as String,
      scanCount: (json['scanCount'] as num).toInt(),
      averagePrice: (json['averagePrice'] as num).toDouble(),
      totalSavings: (json['totalSavings'] as num).toDouble(),
    );

Map<String, dynamic> _$$PopularItemImplToJson(_$PopularItemImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'scanCount': instance.scanCount,
      'averagePrice': instance.averagePrice,
      'totalSavings': instance.totalSavings,
    };
