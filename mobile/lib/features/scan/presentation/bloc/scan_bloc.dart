import 'dart:io';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';

import '../../../../core/network/api_client.dart';
import '../../../../core/models/scan_result.dart';

part 'scan_event.dart';
part 'scan_state.dart';
part 'scan_bloc.freezed.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  final ApiClient _apiClient;

  ScanBloc(this._apiClient) : super(const ScanState.initial()) {
    on<ScanEvent>((event, emit) async {
      await event.map(
        scanInvoice: (e) => _onScanInvoice(e, emit),
        reset: (e) => _onReset(e, emit),
      );
    });
  }

  Future<void> _onScanInvoice(_ScanInvoice event, Emitter<ScanState> emit) async {
    try {
      emit(const ScanState.scanning());

      // Get current location
      final position = await _getCurrentLocation();
      
      // Scan invoice
      final result = await _apiClient.scanInvoice(
        imagePath: event.imageFile.path,
        latitude: position.latitude,
        longitude: position.longitude,
        radius: event.radius,
        premiumOnly: event.premiumOnly,
      );

      emit(ScanState.scanSuccess(result));
    } catch (error) {
      emit(ScanState.scanError(error.toString()));
    }
  }

  void _onReset(_Reset event, Emitter<ScanState> emit) {
    emit(const ScanState.initial());
  }

  Future<Position> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception('Location services are disabled.');
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        throw Exception('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception('Location permissions are permanently denied');
    }

    return await Geolocator.getCurrentPosition();
  }
}