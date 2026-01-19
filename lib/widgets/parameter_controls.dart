import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/image_provider.dart' as ImageTransformProvider;
import '../l10n/app_localizations.dart';

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
        Text(
          'Color Adjustments',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Brightness control
        Row(
          children: [
            const Icon(Icons.brightness_6, size: 18),
            const SizedBox(width: 8),
            Text('Brightness'),
            const Spacer(),
            Text('${imageProvider.brightness.toInt()}'),
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

        // Contrast control
        Row(
          children: [
            const Icon(Icons.contrast, size: 18),
            const SizedBox(width: 8),
            Text('Contrast'),
            const Spacer(),
            Text('${imageProvider.contrast.toStringAsFixed(2)}'),
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

        // Saturation control
        Row(
          children: [
            const Icon(Icons.gradient, size: 18),
            const SizedBox(width: 8),
            Text('Saturation'),
            const Spacer(),
            Text('${imageProvider.saturation.toStringAsFixed(2)}'),
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

        const SizedBox(height: 16),

        Text(
          'Geometric Transformations',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Rotation control
        Row(
          children: [
            const Icon(Icons.rotate_right, size: 18),
            const SizedBox(width: 8),
            Text('Rotation'),
            const Spacer(),
            Text('${imageProvider.rotation.toInt()}°'),
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
    );
  }
}
