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
              useMaterial3: true,
              brightness: Brightness.light,
              // Professional light theme similar to Photoshop/VSCode
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF007ACC),
                secondary: Color(0xFF3A3A3A),
                surface: Color(0xFFF6F6F6),
                background: Color(0xFFF6F6F6),
                error: Color(0xFFE57373),
                onPrimary: Color(0xFFFFFFFF),
                onSecondary: Color(0xFFFFFFFF),
                onSurface: Color(0xFF1B1B1B),
                onBackground: Color(0xFF1B1B1B),
                onError: Color(0xFF000000),
              ),
              dividerColor: const Color(0xFFD0D0D0),
              scaffoldBackgroundColor: const Color(0xFFF6F6F6),
              cardColor: const Color(0xFFFFFFFF),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFFE9E9E9),
                foregroundColor: Color(0xFF1B1B1B),
                elevation: 0,
              ),
              tabBarTheme: const TabBarThemeData(
                labelColor: Color(0xFF007ACC),
                unselectedLabelColor: Color(0xFF6B6B6B),
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              // Professional dark theme similar to Photoshop/VSCode
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFF007ACC),
                secondary: Color(0xFFCCCCCC),
                surface: Color(0xFF2D2D30),
                background: Color(0xFF252526),
                error: Color(0xFFE57373),
                onPrimary: Color(0xFFFFFFFF),
                onSecondary: Color(0xFF000000),
                onSurface: Color(0xFFFFFFFF),
                onBackground: Color(0xFFFFFFFF),
                onError: Color(0xFF000000),
              ),
              dividerColor: const Color(0xFF454545),
              scaffoldBackgroundColor: const Color(0xFF252526),
              cardColor: const Color(0xFF2D2D30),
              appBarTheme: const AppBarTheme(
                backgroundColor: Color(0xFF333333),
                foregroundColor: Color(0xFFFFFFFF),
                elevation: 0,
              ),
              tabBarTheme: const TabBarThemeData(
                labelColor: Color(0xFF007ACC),
                unselectedLabelColor: Color(0xFF9E9E9E),
              ),
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
