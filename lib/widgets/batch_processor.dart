import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/image_provider.dart' as ImageTransformProvider;
import '../services/file_service.dart';

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

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Batch Processor',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),

            // Controls
            Row(
              children: [
                ElevatedButton.icon(
                  icon: const Icon(Icons.folder_open),
                  label: const Text('Add Images'),
                  onPressed: () async {
                    final paths = await FileService.pickMultipleImages();
                    if (paths.isNotEmpty) {
                      imageProvider.setBatchInputPaths(paths);
                    }
                  },
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.folder),
                  label: const Text('Select Output Folder'),
                  onPressed: () async {
                    // For now, we'll just show a placeholder - actual folder selection
                    // would require additional implementation
                    final path = await FileService.pickSingleImage();
                    if (path != null &&
                        imageProvider.batchInputPaths.isNotEmpty) {
                      String outputDir = path.substring(
                        0,
                        path.lastIndexOf('/'),
                      );
                      imageProvider.startBatchProcess(outputDir);
                    }
                  },
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  icon: const Icon(Icons.stop),
                  label: const Text('Cancel'),
                  onPressed: imageProvider.isBatchProcessing
                      ? imageProvider.cancelBatchProcessing
                      : null,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Status
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Status',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text('Status: ${imageProvider.batchStatusMessage}'),
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
                          const SizedBox(height: 8),
                          Text(
                            '${imageProvider.batchProcessedCount} of ${imageProvider.batchTotalCount} images processed',
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Image list
            const Text(
              'Images to Process',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: imageProvider.batchInputPaths.isEmpty
                      ? const Center(
                          child: Text(
                            'No images added. Click "Add Images" to get started.',
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.builder(
                          itemCount: imageProvider.batchInputPaths.length,
                          itemBuilder: (context, index) {
                            final path = imageProvider.batchInputPaths[index];
                            final fileName = path.split('/').last;
                            return ListTile(
                              leading: const Icon(Icons.image),
                              title: Text(fileName),
                              subtitle: Text(path),
                              trailing: IconButton(
                                icon: const Icon(Icons.close),
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
                            );
                          },
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
