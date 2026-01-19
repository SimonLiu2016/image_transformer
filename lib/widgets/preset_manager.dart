import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/preset_provider.dart';
import '../providers/image_provider.dart' as ImageTransformProvider;
import '../l10n/app_localizations.dart';

class PresetManager extends StatelessWidget {
  const PresetManager({super.key});

  @override
  Widget build(BuildContext context) {
    final presetProvider = Provider.of<PresetProvider>(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Saved Presets',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),

        // Preset list
        Expanded(
          child: ListView.builder(
            itemCount: presetProvider.presets.length,
            itemBuilder: (context, index) {
              final preset = presetProvider.presets[index];
              return Card(
                child: ListTile(
                  title: Text(preset.name),
                  subtitle: Text('ID: ${preset.id}'),
                  onTap: () {
                    presetProvider.selectPreset(preset.id);
                    // Apply the preset to the image provider
                    final imageProvider =
                        Provider.of<ImageTransformProvider.ImageProvider>(
                          context,
                          listen: false,
                        );
                    presetProvider.applyPresetToImageProvider(imageProvider);
                  },
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () {
                      presetProvider.deletePreset(preset.id);
                    },
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),

        // Save preset button
        ElevatedButton.icon(
          icon: const Icon(Icons.bookmark_add),
          label: Text(
            AppLocalizations.of(context)?.applyPreset ??
                'Save Current as Preset',
          ),
          onPressed: () {
            _showSavePresetDialog(context);
          },
        ),
      ],
    );
  }

  Future<void> _showSavePresetDialog(BuildContext context) async {
    final presetProvider = Provider.of<PresetProvider>(context, listen: false);
    final imageProvider = Provider.of<ImageTransformProvider.ImageProvider>(
      context,
      listen: false,
    );
    String presetName = '';

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)?.applyPreset ?? 'Save Preset',
          ),
          content: TextField(
            decoration: const InputDecoration(hintText: 'Enter preset name'),
            onChanged: (value) {
              presetName = value;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(AppLocalizations.of(context)?.cancel ?? 'Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (presetName.isNotEmpty) {
                  // Create parameters map with current image settings
                  final parameters = <String, dynamic>{
                    'outputFormat': imageProvider.outputFormat,
                    'width': imageProvider.width,
                    'height': imageProvider.height,
                    'quality': imageProvider.quality,
                    'brightness': imageProvider.brightness,
                    'contrast': imageProvider.contrast,
                    'saturation': imageProvider.saturation,
                    'rotation': imageProvider.rotation,
                  };
                  final preset = Preset(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    name: presetName,
                    parameters: parameters,
                  );
                  presetProvider.savePreset(preset);
                  Navigator.of(context).pop();
                }
              },
              child: Text(AppLocalizations.of(context)?.export ?? 'Save'),
            ),
          ],
        );
      },
    );
  }
}
