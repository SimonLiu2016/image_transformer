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
  bool _isComparisonView = false;
  bool _showOriginal = true;
  bool _showProcessed = true;

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageTransformProvider.ImageProvider>(
      context,
    );
    final localizations = AppLocalizations.of(context)!;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        children: [
          // Preview header with controls
          Container(
            height: 36,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Text(
                  localizations.imagePreview,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
                ),
                const Spacer(),

                // Comparison toggle
                Row(
                  children: [
                    Text(
                      localizations.compare,
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    Switch(
                      value: _isComparisonView,
                      onChanged: (value) {
                        setState(() {
                          _isComparisonView = value;
                        });
                      },
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                  ],
                ),

                // Removed Reset button since it's now in the parameter controls panel
              ],
            ),
          ),

          Expanded(
            child: _isComparisonView
                ? _buildComparisonView(imageProvider)
                : _buildSingleView(imageProvider),
          ),
        ],
      ),
    );
  }

  Widget _buildSingleView(ImageTransformProvider.ImageProvider imageProvider) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            height: 32,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
            ),
            child: TabBar(
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(
                  child: Text(
                    AppLocalizations.of(context)?.original ?? 'Original',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
                Tab(
                  child: Text(
                    AppLocalizations.of(context)?.processed ?? 'Processed',
                    style: Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildImageView(imageProvider.selectedImagePath),
                _buildImageView(imageProvider.processedImagePath),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildComparisonView(
    ImageTransformProvider.ImageProvider imageProvider,
  ) {
    return Row(
      children: [
        // Original image panel
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                right: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Column(
              children: [
                Container(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  child: Row(
                    children: [
                      Text(
                        AppLocalizations.of(context)?.original ?? 'Original',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const Spacer(),
                      Checkbox(
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        value: _showOriginal,
                        onChanged: (value) {
                          setState(() {
                            _showOriginal = value!;
                          });
                        },
                      ),
                    ],
                  ),
                ),
                if (_showOriginal)
                  Expanded(
                    child: _buildImageView(imageProvider.selectedImagePath),
                  ),
              ],
            ),
          ),
        ),

        // Processed image panel
        Expanded(
          child: Column(
            children: [
              Container(
                height: 32,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceVariant,
                ),
                child: Row(
                  children: [
                    Text(
                      AppLocalizations.of(context)?.processed ?? 'Processed',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const Spacer(),
                    Checkbox(
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      value: _showProcessed,
                      onChanged: (value) {
                        setState(() {
                          _showProcessed = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
              if (_showProcessed)
                Expanded(
                  child: _buildImageView(imageProvider.processedImagePath),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildImageView(String? imagePath) {
    if (imagePath == null || !File(imagePath).existsSync()) {
      return Container(
        color: Theme.of(context).colorScheme.surface,
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.image_not_supported, size: 48, color: Colors.grey),
              SizedBox(height: 8),
              Text(
                'No image to display',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: InteractiveViewer(
        clipBehavior: Clip.none,
        boundaryMargin: const EdgeInsets.all(20.0),
        minScale: 0.1,
        maxScale: 5.0,
        child: Image.file(
          File(imagePath),
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) {
            return Container(
              color: Theme.of(context).colorScheme.surface,
              child: const Center(
                child: Icon(Icons.broken_image, size: 48, color: Colors.grey),
              ),
            );
          },
        ),
      ),
    );
  }
}
