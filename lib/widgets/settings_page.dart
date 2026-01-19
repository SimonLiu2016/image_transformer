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
      appBar: AppBar(
        title: Text(localizations.settings),
        backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
        foregroundColor: Theme.of(context).colorScheme.onSurface,
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: ListView(
          children: [
            // Theme settings
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 0.8,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.palette, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          localizations.appearance,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    SwitchListTile(
                      title: Text(
                        localizations.darkMode,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      value: appProvider.isDarkMode,
                      onChanged: (value) {
                        appProvider.toggleTheme();
                      },
                      secondary: const Icon(Icons.dark_mode, size: 18),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      dense: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Default parameters
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 0.8,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.settings, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          localizations.defaultParameters,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Default output format
                    Text(
                      localizations.defaultOutputFormat,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 6),
                    DropdownButtonFormField<String>(
                      value: appProvider.defaultOutputFormat,
                      decoration: const InputDecoration(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
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
                    const SizedBox(height: 12),

                    // Default quality
                    Text(
                      localizations.defaultQuality,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 6),
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
                    Text(
                      '${appProvider.defaultQuality}%',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 8),

                    SwitchListTile(
                      title: Text(
                        localizations.autoSavePresets,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                      value: appProvider.autoSavePreset,
                      onChanged: (value) {
                        appProvider.setAutoSavePreset(value);
                      },
                      secondary: const Icon(Icons.bookmark, size: 18),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      dense: true,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // About section
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(6),
                side: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 0.8,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          localizations.about,
                          style: Theme.of(context).textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${localizations.imageTransformer} v1.0',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'A powerful image conversion and processing tool.',
                      style: TextStyle(fontSize: 12),
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
