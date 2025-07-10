part of 'scan_bloc.dart';

@freezed
class ScanEvent with _$ScanEvent {
  const factory ScanEvent.scanInvoice({
    required File imageFile,
    double? radius,
    bool? premiumOnly,
  }) = _ScanInvoice;

  const factory ScanEvent.reset() = _Reset;
}