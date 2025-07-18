import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'app/core/di/injection.dart';
import 'app/core/theme/app_theme.dart';
import 'app/core/utils/logger.dart';
import 'app/features/auth/bloc/auth_bloc.dart';
import 'app/features/scan/bloc/scan_bloc.dart';
import 'app/features/location/bloc/location_bloc.dart';
import 'app/features/scan/presentation/pages/scan_page.dart';
import 'app/features/home/presentation/pages/home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Setup dependency injection
  await initializeDependencies();

  // Initialize logger
  Logger.info('App initialized');

  runApp(const ClovaInvoiceScannerApp());
}

class ClovaInvoiceScannerApp extends StatelessWidget {
  const ClovaInvoiceScannerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => AuthBloc(),
        ),
        BlocProvider<ScanBloc>(
          create: (context) => ScanBloc(),
        ),
        BlocProvider<LocationBloc>(
          create: (context) => LocationBloc(),
        ),
      ],
      child: MaterialApp(
        title: 'CLOVA Invoice Scanner',
        debugShowCheckedModeBanner: false,

        // Theme
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,

        // Localization
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en', 'US'),
          Locale('ko', 'KR'),
        ],

        // Home page
        home: const HomePage(),

        // Builder for custom error handling
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.0)),
            child: child!,
          );
        },
      ),
    );
  }
}
