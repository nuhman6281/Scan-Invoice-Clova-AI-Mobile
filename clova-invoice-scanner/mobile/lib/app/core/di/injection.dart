import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../utils/logger.dart';
import '../../features/auth/bloc/auth_bloc.dart';
import '../../features/scan/bloc/scan_bloc.dart';
import '../../features/location/bloc/location_bloc.dart';

final GetIt getIt = GetIt.instance;

Future<void> initializeDependencies() async {
  try {
    Logger.info('Initializing dependencies...');
    
    // Register HTTP client
    getIt.registerLazySingleton<http.Client>(() => http.Client());
    
    // Register BLoCs
    getIt.registerLazySingleton<AuthBloc>(() => AuthBloc());
    getIt.registerLazySingleton<ScanBloc>(() => ScanBloc());
    getIt.registerLazySingleton<LocationBloc>(() => LocationBloc());
    
    Logger.info('Dependencies initialized successfully');
  } catch (e) {
    Logger.error('Failed to initialize dependencies: $e');
    rethrow;
  }
}

/// Get a registered dependency
T get<T extends Object>() {
  return getIt.get<T>();
}

/// Check if a dependency is registered
bool isRegistered<T extends Object>() {
  return getIt.isRegistered<T>();
} 