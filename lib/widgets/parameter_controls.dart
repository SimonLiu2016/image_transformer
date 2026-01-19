import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/image_provider.dart' as ImageTransformProvider;

class ParameterControls extends StatelessWidget {
  const ParameterControls({super.key});

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageTransformProvider.ImageProvider>(
      context,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
              const Text(
                'FORMAT',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: imageProvider.outputFormat,
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
                    imageProvider.setOutputFormat(value);
                  }
                },
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  border: OutlineInputBorder(),
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
              const Text(
                'SIZE',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'W',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: imageProvider.width > 0
                          ? imageProvider.width.toString()
                          : '',
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          imageProvider.setDimensions(
                            int.tryParse(value) ?? 0,
                            imageProvider.height,
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text('×', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 6),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'H',
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 8,
                        ),
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                      initialValue: imageProvider.height > 0
                          ? imageProvider.height.toString()
                          : '',
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          imageProvider.setDimensions(
                            imageProvider.width,
                            int.tryParse(value) ?? 0,
                          );
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
              const Text(
                'QUALITY',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
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
              const Text(
                'COLOR ADJUSTMENTS',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),

              // Brightness control
              Row(
                children: [
                  const Icon(Icons.brightness_6, size: 16),
                  const SizedBox(width: 6),
                  const Text('Brightness', style: TextStyle(fontSize: 13)),
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
                },
              ),

              const SizedBox(height: 6),

              // Contrast control
              Row(
                children: [
                  const Icon(Icons.contrast, size: 16),
                  const SizedBox(width: 6),
                  const Text('Contrast', style: TextStyle(fontSize: 13)),
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
                },
              ),

              const SizedBox(height: 6),

              // Saturation control
              Row(
                children: [
                  const Icon(Icons.gradient, size: 16),
                  const SizedBox(width: 6),
                  const Text('Saturation', style: TextStyle(fontSize: 13)),
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
              const Text(
                'TRANSFORM',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.0,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 8),

              // Rotation control
              Row(
                children: [
                  const Icon(Icons.rotate_right, size: 16),
                  const SizedBox(width: 6),
                  const Text('Rotation', style: TextStyle(fontSize: 13)),
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
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
