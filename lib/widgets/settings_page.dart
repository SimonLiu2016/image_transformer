import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = Provider.of<AppProvider>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
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
                    const Text(
                      'Appearance',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      title: const Text('Dark Mode'),
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
                    const Text(
                      'Default Parameters',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Default output format
                    const Text('Default Output Format'),
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
                    const Text('Default Quality'),
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
                      title: const Text('Auto-save Presets'),
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
                    const Text(
                      'About',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text('Image Transformer v1.0'),
                    const SizedBox(height: 8),
                    const Text(
                      'A powerful image conversion and processing tool.',
                    ),
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
