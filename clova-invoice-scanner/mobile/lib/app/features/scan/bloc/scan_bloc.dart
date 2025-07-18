import 'package:flutter_bloc/flutter_bloc.dart';

class ScanBloc extends Bloc<ScanEvent, ScanState> {
  ScanBloc() : super(ScanInitial()) {
    on<ScanStarted>(_onScanStarted);
    on<ScanCompleted>(_onScanCompleted);
    on<ScanFailed>(_onScanFailed);
  }

  void _onScanStarted(ScanStarted event, Emitter<ScanState> emit) {
    emit(ScanLoading());
  }

  void _onScanCompleted(ScanCompleted event, Emitter<ScanState> emit) {
    emit(ScanSuccess(result: event.result));
  }

  void _onScanFailed(ScanFailed event, Emitter<ScanState> emit) {
    emit(ScanFailure(message: event.message));
  }
}

// Events
abstract class ScanEvent {}

class ScanStarted extends ScanEvent {}

class ScanCompleted extends ScanEvent {
  final Map<String, dynamic> result;
  ScanCompleted({required this.result});
}

class ScanFailed extends ScanEvent {
  final String message;
  ScanFailed({required this.message});
}

// States
abstract class ScanState {}

class ScanInitial extends ScanState {}

class ScanLoading extends ScanState {}

class ScanSuccess extends ScanState {
  final Map<String, dynamic> result;
  ScanSuccess({required this.result});
}

class ScanFailure extends ScanState {
  final String message;
  ScanFailure({required this.message});
} 