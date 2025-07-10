import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';

import '../../features/scan/presentation/bloc/scan_bloc.dart';
import '../network/api_client.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // Network
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.options.baseUrl = 'http://localhost:3000/api';
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    return dio;
  });

  getIt.registerLazySingleton<ApiClient>(() => ApiClient(getIt<Dio>()));

  // BLoCs
  getIt.registerFactory<ScanBloc>(() => ScanBloc(getIt<ApiClient>()));
}