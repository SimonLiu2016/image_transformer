import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'services/tray_service.dart';
import 'package:provider/provider.dart';
import 'l10n/app_localizations.dart';
import 'providers/app_provider.dart';
import 'providers/image_provider.dart' as ImageProviderNamespace;
import 'providers/preset_provider.dart';
import 'widgets/main_layout.dart';
import 'utils/constants.dart';

void main() {
  runApp(const ImageTransformerApp());
}

class ImageTransformerApp extends StatelessWidget {
  const ImageTransformerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize tray service when the app starts
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TrayService.instance.initTray();
    });

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
        ChangeNotifierProvider(
          create: (_) => ImageProviderNamespace.ImageProvider(),
        ),
        ChangeNotifierProvider(create: (_) => PresetProvider()),
      ],
      child: Consumer<AppProvider>(
        builder: (context, appProvider, child) {
          return MaterialApp(
            title: APP_NAME,
            debugShowCheckedModeBanner: false,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'), // English
              Locale('zh'), // Chinese
            ],
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
              brightness: Brightness.light,
            ),
            darkTheme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
              brightness: Brightness.dark,
            ),
            themeMode: appProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            home: const MainLayout(),
          );
        },
      ),
    );
  }
}
