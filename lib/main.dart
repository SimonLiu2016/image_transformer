import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
