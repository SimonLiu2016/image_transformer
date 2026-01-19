import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';
import '../l10n/app_localizations.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(localizations.settings)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            // Theme settings
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.appearance,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: Text(localizations.darkMode),
                      value: appProvider.isDarkMode,
                      onChanged: (value) {
                        appProvider.toggleTheme();
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Default parameters
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.defaultParameters,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Default output format
                    Text(localizations.defaultOutputFormat),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: appProvider.defaultOutputFormat,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      items: ['png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp']
                          .map(
                            (format) => DropdownMenuItem(
                              value: format,
                              child: Text(format.toUpperCase()),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) {
                          appProvider.setDefaultOutputFormat(value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Default quality
                    Text(localizations.defaultQuality),
                    const SizedBox(height: 8),
                    Slider(
                      value: appProvider.defaultQuality.toDouble(),
                      min: 1,
                      max: 100,
                      divisions: 99,
                      label: '${appProvider.defaultQuality}%',
                      onChanged: (value) {
                        appProvider.setDefaultQuality(value.round());
                      },
                    ),
                    Text('${appProvider.defaultQuality}%'),
                    const SizedBox(height: 16),

                    SwitchListTile(
                      title: Text(localizations.autoSavePresets),
                      value: appProvider.autoSavePreset,
                      onChanged: (value) {
                        appProvider.setAutoSavePreset(value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // About section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.about,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(localizations.imageTransformer + ' v1.0'),
                    const SizedBox(height: 8),
                    Text('A powerful image conversion and processing tool.'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
