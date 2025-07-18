import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

class LocationBloc extends Bloc<LocationEvent, LocationState> {
  LocationBloc() : super(LocationInitial()) {
    on<LocationRequested>(_onLocationRequested);
    on<LocationUpdated>(_onLocationUpdated);
  }

  void _onLocationRequested(LocationRequested event, Emitter<LocationState> emit) {
    emit(LocationLoading());
  }

  void _onLocationUpdated(LocationUpdated event, Emitter<LocationState> emit) {
    emit(LocationSuccess(position: event.position));
  }
}

// Events
abstract class LocationEvent {}

class LocationRequested extends LocationEvent {}

class LocationUpdated extends LocationEvent {
  final Position position;
  LocationUpdated({required this.position});
}

// States
abstract class LocationState {}

class LocationInitial extends LocationState {}

class LocationLoading extends LocationState {}

class LocationSuccess extends LocationState {
  final Position position;
  LocationSuccess({required this.position});
}

class LocationFailure extends LocationState {
  final String message;
  LocationFailure({required this.message});
} 