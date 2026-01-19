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
        const Text(
          'Color Adjustments',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Brightness control
        Row(
          children: [
            const Icon(Icons.brightness_6, size: 18),
            const SizedBox(width: 8),
            const Text('Brightness'),
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
            const Text('Contrast'),
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
            const Text('Saturation'),
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

        const Text(
          'Geometric Transformations',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),

        // Rotation control
        Row(
          children: [
            const Icon(Icons.rotate_right, size: 18),
            const SizedBox(width: 8),
            const Text('Rotation'),
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
