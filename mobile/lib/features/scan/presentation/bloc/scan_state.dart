part of 'scan_bloc.dart';

@freezed
class ScanState with _$ScanState {
  const factory ScanState.initial() = _Initial;
  const factory ScanState.scanning() = _Scanning;
  const factory ScanState.scanSuccess(ScanResult result) = _ScanSuccess;
  const factory ScanState.scanError(String message) = _ScanError;
}