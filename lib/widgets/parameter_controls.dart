import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import '../providers/image_provider.dart' as ImageTransformProvider;
import '../l10n/app_localizations.dart';

class ParameterControls extends HookWidget {
  const ParameterControls({super.key});

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageTransformProvider.ImageProvider>(
      context,
    );
    final localizations = AppLocalizations.of(context)!;

    // Trigger preview update when parameters change
    useEffect(() {
      void listener() {
        if (imageProvider.selectedImagePath != null) {
          imageProvider.processImageForPreview();
        }
      }

      imageProvider.addListener(listener);
      return () => imageProvider.removeListener(listener);
    }, [imageProvider]);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with title and reset button
        Container(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Text(
                localizations.adjustments,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const Spacer(),

              // Reset button
              FilledButton.icon(
                icon: const Icon(Icons.refresh, size: 14),
                label: Text(
                  localizations.reset,
                  style: TextStyle(fontSize: 12),
                ),
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
                      ).colorScheme.error.withOpacity(0.8);
                    }
                    return Theme.of(context).colorScheme.error;
                  }),
                ),
                onPressed: () {
                  imageProvider.reset();
                  if (imageProvider.selectedImagePath != null) {
                    imageProvider.requestPreviewUpdate();
                  }
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 4),

        // Format conversion section
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.5),
              width: 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.format,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: imageProvider.outputFormat,
                items:
                    ['png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp', 'tiff', 'tga']
                        .map(
                          (format) => DropdownMenuItem(
                            value: format,
                            child: Text(format.toUpperCase()),
                          ),
                        )
                        .toList(),
                onChanged: (value) {
                  if (value != null) {
                    imageProvider.setOutputFormat(value);
                    if (imageProvider.selectedImagePath != null) {
                      imageProvider.requestPreviewUpdate();
                    }
                  }
                },
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Size adjustment section
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.5),
              width: 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.size,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: localizations.width,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: imageProvider.width > 0
                          ? imageProvider.width.toString()
                          : '',
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          int widthValue = double.tryParse(value)?.round() ?? 0;
                          imageProvider.setDimensions(
                            widthValue,
                            imageProvider.height,
                          );
                        } else {
                          imageProvider.setDimensions(0, imageProvider.height);
                        }
                        if (imageProvider.selectedImagePath != null) {
                          imageProvider.requestPreviewUpdate();
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      decoration: InputDecoration(
                        labelText: localizations.height,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: imageProvider.height > 0
                          ? imageProvider.height.toString()
                          : '',
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          int heightValue =
                              double.tryParse(value)?.round() ?? 0;
                          imageProvider.setDimensions(
                            imageProvider.width,
                            heightValue,
                          );
                        } else {
                          imageProvider.setDimensions(imageProvider.width, 0);
                        }
                        if (imageProvider.selectedImagePath != null) {
                          imageProvider.requestPreviewUpdate();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // Quality control section
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.5),
              width: 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.quality,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              Slider(
                value: imageProvider.quality,
                min: 1.0,
                max: 100.0,
                divisions: 99,
                label: '${imageProvider.quality.round()}%',
                onChanged: (value) {
                  imageProvider.setQuality(value);
                  if (imageProvider.selectedImagePath != null) {
                    imageProvider.requestPreviewUpdate();
                  }
                },
              ),
              Text(
                '${imageProvider.quality.round()}%',
                textAlign: TextAlign.right,
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        ),

        // Color adjustments section
        Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.5),
              width: 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.colorAdjustments,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),

              // Brightness control
              Row(
                children: [
                  const Icon(Icons.brightness_medium, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    localizations.brightness,
                    style: TextStyle(fontSize: 13),
                  ),
                  const Spacer(),
                  Text(
                    '${imageProvider.brightness.toInt()}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
              Slider(
                value: imageProvider.brightness,
                min: -100,
                max: 100,
                onChanged: (value) {
                  imageProvider.setBrightness(value);
                  if (imageProvider.selectedImagePath != null) {
                    imageProvider.requestPreviewUpdate();
                  }
                },
              ),

              const SizedBox(height: 6),

              // Contrast control
              Row(
                children: [
                  const Icon(Icons.contrast, size: 16),
                  const SizedBox(width: 6),
                  Text(localizations.contrast, style: TextStyle(fontSize: 13)),
                  const Spacer(),
                  Text(
                    '${imageProvider.contrast.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
              Slider(
                value: imageProvider.contrast,
                min: 0,
                max: 2,
                onChanged: (value) {
                  imageProvider.setContrast(value);
                  if (imageProvider.selectedImagePath != null) {
                    imageProvider.requestPreviewUpdate();
                  }
                },
              ),

              const SizedBox(height: 6),

              // Saturation control
              Row(
                children: [
                  const Icon(Icons.gradient, size: 16),
                  const SizedBox(width: 6),
                  Text(
                    localizations.saturation,
                    style: TextStyle(fontSize: 13),
                  ),
                  const Spacer(),
                  Text(
                    '${imageProvider.saturation.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
              Slider(
                value: imageProvider.saturation,
                min: 0,
                max: 2,
                onChanged: (value) {
                  imageProvider.setSaturation(value);
                  if (imageProvider.selectedImagePath != null) {
                    imageProvider.requestPreviewUpdate();
                  }
                },
              ),
            ],
          ),
        ),

        // Geometric transformations section
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(
              color: Theme.of(context).dividerColor.withOpacity(0.5),
              width: 0.8,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                localizations.transform,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),

              // Rotation control
              Row(
                children: [
                  const Icon(Icons.rotate_right, size: 16),
                  const SizedBox(width: 6),
                  Text(localizations.rotation, style: TextStyle(fontSize: 13)),
                  const Spacer(),
                  Text(
                    '${imageProvider.rotation.toInt()}°',
                    style: const TextStyle(fontSize: 11, color: Colors.grey),
                  ),
                ],
              ),
              Slider(
                value: imageProvider.rotation,
                min: 0,
                max: 360,
                divisions: 360,
                onChanged: (value) {
                  imageProvider.setRotation(value);
                  if (imageProvider.selectedImagePath != null) {
                    imageProvider.requestPreviewUpdate();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
