import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import '../models/scan_result.dart';

part 'api_client.g.dart';

@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String baseUrl}) = _ApiClient;

  @POST('/scan/invoice')
  @MultiPart()
  Future<ScanResult> scanInvoice({
    @Part(name: 'image') required String imagePath,
    @Part(name: 'latitude') required double latitude,
    @Part(name: 'longitude') required double longitude,
    @Part(name: 'radius') double? radius,
    @Part(name: 'premiumOnly') bool? premiumOnly,
  });

  @GET('/scan/history')
  Future<List<ScanResult>> getScanHistory({
    @Query('page') int? page,
    @Query('limit') int? limit,
  });

  @GET('/shops/nearby')
  Future<List<Shop>> getNearbyShops({
    @Query('lat') required double latitude,
    @Query('lng') required double longitude,
    @Query('radius') double? radius,
  });

  @GET('/products')
  Future<List<Product>> getProducts({
    @Query('category') String? category,
    @Query('search') String? search,
    @Query('minPrice') double? minPrice,
    @Query('maxPrice') double? maxPrice,
  });
}