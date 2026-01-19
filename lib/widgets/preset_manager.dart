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
        // Header with title and save button
        Container(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Text(
                'PRESETS',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const Spacer(),

              // Save preset button
              FilledButton.icon(
                icon: const Icon(Icons.bookmark_add, size: 14),
                label: const Text('Save', style: TextStyle(fontSize: 12)),
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  visualDensity: VisualDensity.compact,
                  backgroundColor: WidgetStateProperty.resolveWith<Color?>((
                    Set<WidgetState> states,
                  ) {
                    if (states.contains(WidgetState.hovered)) {
                      return Theme.of(
                        context,
                      ).colorScheme.primary.withOpacity(0.8);
                    }
                    return Theme.of(context).colorScheme.primary;
                  }),
                ),
                onPressed: () {
                  _showSavePresetDialog(context);
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),

        // Preset list
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Theme.of(context).dividerColor.withOpacity(0.5),
                width: 0.8,
              ),
            ),
            child: presetProvider.presets.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.bookmark_border,
                          size: 36,
                          color: Colors.grey,
                        ),
                        SizedBox(height: 8),
                        Text(
                          'No presets saved',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        Text(
                          'Create a preset to save your settings',
                          style: TextStyle(color: Colors.grey, fontSize: 10),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: presetProvider.presets.length,
                    itemBuilder: (context, index) {
                      final preset = presetProvider.presets[index];
                      return ListTile(
                        title: Text(
                          preset.name,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        subtitle: Text(
                          'ID: ${preset.id.substring(0, 8)}...',
                          style: const TextStyle(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                        leading: const Icon(
                          Icons.bookmark_outline,
                          size: 16,
                          color: Colors.grey,
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.play_arrow, size: 14),
                              tooltip: 'Apply preset',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints.tightFor(
                                width: 28,
                                height: 28,
                              ),
                              style: ButtonStyle(
                                visualDensity: VisualDensity.compact,
                              ),
                              onPressed: () {
                                presetProvider.selectPreset(preset.id);
                                // Apply the preset to the image provider
                                final imageProvider =
                                    Provider.of<
                                      ImageTransformProvider.ImageProvider
                                    >(context, listen: false);
                                presetProvider.applyPresetToImageProvider(
                                  imageProvider,
                                );
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, size: 14),
                              tooltip: 'Delete preset',
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints.tightFor(
                                width: 28,
                                height: 28,
                              ),
                              style: ButtonStyle(
                                visualDensity: VisualDensity.compact,
                              ),
                              onPressed: () {
                                presetProvider.deletePreset(preset.id);
                              },
                            ),
                          ],
                        ),
                        onTap: () {
                          presetProvider.selectPreset(preset.id);
                          // Apply the preset to the image provider
                          final imageProvider =
                              Provider.of<ImageTransformProvider.ImageProvider>(
                                context,
                                listen: false,
                              );
                          presetProvider.applyPresetToImageProvider(
                            imageProvider,
                          );
                        },
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                        style: ListTileStyle.list,
                        dense: true,
                      );
                    },
                  ),
          ),
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
          title: const Text('Save Preset', style: TextStyle(fontSize: 16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(
                  hintText: 'Enter preset name',
                  labelText: 'Preset Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 1,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: Theme.of(context).dividerColor,
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 1,
                    ),
                  ),
                ),
                onChanged: (value) {
                  presetName = value;
                },
              ),
              const SizedBox(height: 12),
              // Show current parameter values
              ExpansionTile(
                title: const Text(
                  'Current Parameters',
                  style: TextStyle(fontSize: 14),
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Output Format: ${imageProvider.outputFormat}'),
                        Text('Quality: ${imageProvider.quality.round()}%'),
                        Text('Brightness: ${imageProvider.brightness.toInt()}'),
                        Text(
                          'Contrast: ${imageProvider.contrast.toStringAsFixed(2)}',
                        ),
                        Text(
                          'Saturation: ${imageProvider.saturation.toStringAsFixed(2)}',
                        ),
                        Text('Rotation: ${imageProvider.rotation.toInt()}°'),
                        if (imageProvider.width > 0 || imageProvider.height > 0)
                          Text(
                            'Size: ${imageProvider.width} × ${imageProvider.height}',
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
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
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}
