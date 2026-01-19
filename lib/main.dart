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
            title:
                '', // Removed app title to follow professional software design like Photoshop/VSCode where no app title is shown in UI
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
              // Pixelmator Pro style light theme
              colorScheme: const ColorScheme.light(
                primary: Color(0xFF007AFF), // macOS system blue
                secondary: Color(0xFF6B6B6B),
                surface: Color(0xFFFAFAFA),
                background: Color(0xFFFAFAFA),
                error: Color(0xFFFF3B30),
                onPrimary: Color(0xFFFFFFFF),
                onSecondary: Color(0xFFFFFFFF),
                onSurface: Color(0xFF1B1B1B),
                onBackground: Color(0xFF1B1B1B),
                onError: Color(0xFFFFFFFF),
              ),
              dividerColor: const Color(0xFFD1D1D1),
              scaffoldBackgroundColor: const Color(0xFFFAFAFA),
              cardColor: const Color(0xFFFFFFFF),
              textTheme: const TextTheme(
                bodySmall: TextStyle(fontSize: 11, fontFamily: '.SF UI Text'),
                bodyMedium: TextStyle(fontSize: 12, fontFamily: '.SF UI Text'),
                labelSmall: TextStyle(
                  fontSize: 11,
                  fontFamily: '.SF UI Text',
                  fontWeight: FontWeight.w500,
                ),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                foregroundColor: Color(0xFF1B1B1B),
                elevation: 0,
              ),
              tabBarTheme: const TabBarThemeData(
                labelColor: Color(0xFF007AFF),
                unselectedLabelColor: Color(0xFF8E8E93),
              ),
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD1D1D1), width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD1D1D1), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF007AFF), width: 1),
                ),
              ),
            ),
            darkTheme: ThemeData(
              useMaterial3: true,
              brightness: Brightness.dark,
              // Pixelmator Pro style dark theme
              colorScheme: const ColorScheme.dark(
                primary: Color(0xFF007AFF), // macOS system blue
                secondary: Color(0xFFAAAAAA),
                surface: Color(0xFF1C1C1E), // Match Pixelmator Pro dark theme
                background: Color(0xFF1C1C1E),
                error: Color(0xFFFF453A),
                onPrimary: Color(0xFFFFFFFF),
                onSecondary: Color(0xFF000000),
                onSurface: Color(0xFFDADADA),
                onBackground: Color(0xFFDADADA),
                onError: Color(0xFFFFFFFF),
              ),
              dividerColor: const Color(0xFF48484A),
              scaffoldBackgroundColor: const Color(0xFF1C1C1E),
              cardColor: const Color(0xFF2C2C2E),
              textTheme: const TextTheme(
                bodySmall: TextStyle(
                  fontSize: 11,
                  fontFamily: '.SF UI Text',
                  color: Color(0xFFDADADA),
                ),
                bodyMedium: TextStyle(
                  fontSize: 12,
                  fontFamily: '.SF UI Text',
                  color: Color(0xFFDADADA),
                ),
                labelSmall: TextStyle(
                  fontSize: 11,
                  fontFamily: '.SF UI Text',
                  fontWeight: FontWeight.w500,
                  color: Color(0xFFDADADA),
                ),
              ),
              appBarTheme: const AppBarTheme(
                backgroundColor: Colors.transparent,
                foregroundColor: Color(0xFFDADADA),
                elevation: 0,
              ),
              tabBarTheme: const TabBarThemeData(
                labelColor: Color(0xFF007AFF),
                unselectedLabelColor: Color(0xFF8E8E93),
              ),
              inputDecorationTheme: const InputDecorationTheme(
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF48484A), width: 1),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF48484A), width: 1),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF007AFF), width: 1),
                ),
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
