import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/image_provider.dart' as ImageTransformProvider;
import '../services/file_service.dart';
import '../l10n/app_localizations.dart';

class BatchProcessor extends StatefulWidget {
  const BatchProcessor({super.key});

  @override
  State<BatchProcessor> createState() => _BatchProcessorState();
}

class _BatchProcessorState extends State<BatchProcessor> {
  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageTransformProvider.ImageProvider>(
      context,
    );
    final localizations = AppLocalizations.of(context)!;

    return Container(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Batch Processor',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 16),

          // Action buttons
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              FilledButton.icon(
                icon: const Icon(Icons.add_photo_alternate, size: 16),
                label: Text(
                  localizations.addImages,
                  style: const TextStyle(fontSize: 12),
                ),
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                ),
                onPressed: () async {
                  final paths = await FileService.pickMultipleImages();
                  if (paths.isNotEmpty) {
                    final updatedPaths = List<String>.from(
                      imageProvider.batchInputPaths,
                    )..addAll(paths);
                    imageProvider.setBatchInputPaths(updatedPaths);
                  }
                },
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.folder, size: 16),
                label: Text(
                  localizations.selectOutputFolder,
                  style: const TextStyle(fontSize: 12),
                ),
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                ),
                onPressed: () async {
                  // For now, we'll just show a placeholder - actual folder selection
                  // would require additional implementation
                  final path = await FileService.pickSingleImage();
                  if (path != null &&
                      imageProvider.batchInputPaths.isNotEmpty) {
                    String outputDir = path.substring(0, path.lastIndexOf('/'));
                    imageProvider.startBatchProcess(outputDir);
                  }
                },
              ),
              OutlinedButton.icon(
                icon: const Icon(Icons.stop, size: 16),
                label: Text(
                  localizations.cancel,
                  style: const TextStyle(fontSize: 12),
                ),
                style: ButtonStyle(
                  padding: WidgetStateProperty.all(
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  ),
                ),
                onPressed: imageProvider.isBatchProcessing
                    ? imageProvider.cancelBatchProcessing
                    : null,
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Status panel
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
                Row(
                  children: [
                    Icon(
                      imageProvider.isBatchProcessing
                          ? Icons.hourglass_top
                          : Icons.info,
                      size: 16,
                      color: imageProvider.isBatchProcessing
                          ? Colors.orange
                          : Colors.blue,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      localizations.status,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  'Status: ${imageProvider.batchStatusMessage}',
                  style: const TextStyle(fontSize: 11),
                ),
                const SizedBox(height: 8),
                if (imageProvider.isBatchProcessing)
                  Column(
                    children: [
                      LinearProgressIndicator(
                        value: imageProvider.batchTotalCount > 0
                            ? imageProvider.batchProcessedCount /
                                  imageProvider.batchTotalCount
                            : 0,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${imageProvider.batchProcessedCount} of ${imageProvider.batchTotalCount} images processed',
                        style: const TextStyle(fontSize: 10),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Image list
          Text(
            localizations.imagesToProcess,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: Theme.of(context).dividerColor.withOpacity(0.5),
                  width: 0.8,
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(6.0),
                child: imageProvider.batchInputPaths.isEmpty
                    ? const Center(
                        child: Text(
                          'No images added. Click "Add Images" to get started.',
                          style: TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                      )
                    : ListView.builder(
                        itemCount: imageProvider.batchInputPaths.length,
                        itemBuilder: (context, index) {
                          final path = imageProvider.batchInputPaths[index];
                          final fileName = path.split('/').last;
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              leading: const Icon(Icons.image, size: 16),
                              title: Text(
                                fileName,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(fontSize: 11),
                              ),
                              subtitle: Text(
                                path,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 9,
                                  color: Colors.grey,
                                ),
                              ),
                              trailing: IconButton(
                                icon: const Icon(Icons.close, size: 14),
                                onPressed: () {
                                  final updatedPaths = List<String>.from(
                                    imageProvider.batchInputPaths,
                                  );
                                  updatedPaths.removeAt(index);
                                  imageProvider.setBatchInputPaths(
                                    updatedPaths,
                                  );
                                },
                              ),
                              dense: true,
                              visualDensity: VisualDensity.compact,
                            ),
                          );
                        },
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
