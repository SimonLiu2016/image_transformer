import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../providers/image_provider.dart' as ImageTransformProvider;
import '../l10n/app_localizations.dart';

class ImagePreview extends StatefulWidget {
  const ImagePreview({super.key});

  @override
  State<ImagePreview> createState() => _ImagePreviewState();
}

class _ImagePreviewState extends State<ImagePreview> {
  bool _showComparison = false;
  double _sliderPosition = 0.5; // For split view

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageTransformProvider.ImageProvider>(
      context,
    );

    return Container(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Preview header
          Row(
            children: [
              Text(
                AppLocalizations.of(context)?.imagePreview ?? 'Image Preview',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              // Toggle comparison view
              Switch(
                value: _showComparison,
                onChanged: (value) {
                  setState(() {
                    _showComparison = value;
                  });
                },
              ),
              const Text('Compare'),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  // Refresh preview
                },
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Preview area
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(8),
                color: Theme.of(context).canvasColor,
              ),
              child: imageProvider.selectedImagePath != null
                  ? _buildPreviewArea(imageProvider)
                  : const Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.image, size: 64, color: Colors.grey),
                          SizedBox(height: 16),
                          Text(
                            'Drag & drop an image here or click Import Image',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 16),

          // Image info
          if (imageProvider.selectedImagePath != null)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                border: Border.all(color: Theme.of(context).dividerColor),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Original: ${imageProvider.selectedImagePath!.split('/').last}',
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildPreviewArea(ImageTransformProvider.ImageProvider imageProvider) {
    if (_showComparison && imageProvider.processedImagePath != null) {
      // Comparison view - show before and after
      return _buildComparisonView(imageProvider);
    } else if (_showComparison) {
      // Show message if no processed image available for comparison
      return const Center(
        child: Text('Process an image first to see comparison'),
      );
    } else {
      // Single image view
      return InteractiveViewer(
        child: Image.file(
          fit: BoxFit.contain,
          alignment: Alignment.center,
          File(imageProvider.selectedImagePath!),
        ),
      );
    }
  }

  Widget _buildComparisonView(
    ImageTransformProvider.ImageProvider imageProvider,
  ) {
    // Create a tabbed view to switch between original and processed
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            constraints: const BoxConstraints.expand(height: 50),
            child: TabBar(
              tabs: [
                Tab(text: AppLocalizations.of(context)?.original ?? 'Original'),
                Tab(
                  text: AppLocalizations.of(context)?.processed ?? 'Processed',
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                // Original image
                InteractiveViewer(
                  child: Image.file(
                    fit: BoxFit.contain,
                    alignment: Alignment.center,
                    File(imageProvider.selectedImagePath!),
                  ),
                ),
                // Processed image
                imageProvider.processedImagePath != null
                    ? InteractiveViewer(
                        child: Image.file(
                          fit: BoxFit.contain,
                          alignment: Alignment.center,
                          File(imageProvider.processedImagePath!),
                        ),
                      )
                    : const Center(child: Text('No processed image available')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
