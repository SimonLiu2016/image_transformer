import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../services/file_service.dart';
import '../providers/image_provider.dart' as ImageTransformProvider;
import 'sidebar_panel.dart';
import 'image_preview.dart';
import 'batch_processor.dart';
import 'settings_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  bool _isBatchMode = false;

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageTransformProvider.ImageProvider>(
      context,
    );

    return Theme(
      data: Theme.of(context).copyWith(
        tabBarTheme: TabBarTheme.of(
          context,
        ).copyWith(labelColor: Colors.blue, unselectedLabelColor: Colors.grey),
      ),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)?.title ?? 'Image Transformer',
          ),
          actions: [
            Switch(
              value: _isBatchMode,
              onChanged: (value) {
                setState(() {
                  _isBatchMode = value;
                });
              },
            ),
            Text(AppLocalizations.of(context)?.batchMode ?? 'Batch Mode'),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SettingsPage()),
                );
              },
            ),
          ],
        ),
        body: _isBatchMode
            ? const BatchProcessor()
            : Row(
                children: [
                  // Sidebar panel (left)
                  SizedBox(width: 300, child: const SidebarPanel()),

                  // Vertical divider
                  Container(width: 1, color: Theme.of(context).dividerColor),

                  // Main content area (center)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Toolbar
                          Container(
                            height: 50,
                            margin: const EdgeInsets.only(bottom: 8.0),
                            child: Row(
                              children: [
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.folder_open),
                                  label: const Text('Import Image'),
                                  onPressed: () async {
                                    final imagePath =
                                        await FileService.pickSingleImage();
                                    if (imagePath != null) {
                                      Provider.of<
                                            ImageTransformProvider.ImageProvider
                                          >(context, listen: false)
                                          .setSelectedImage(imagePath);
                                    }
                                  },
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.save),
                                  label: const Text('Apply Preset'),
                                  onPressed: () {
                                    // Apply preset functionality will be implemented later
                                  },
                                ),
                                const SizedBox(width: 8),
                                ElevatedButton.icon(
                                  icon: const Icon(Icons.download),
                                  label: const Text('Export'),
                                  onPressed: () async {
                                    if (imageProvider.selectedImagePath !=
                                        null) {
                                      // Show dialog to select output directory
                                      String? outputDir =
                                          await FileService.pickSingleImage();
                                      if (outputDir != null) {
                                        String outputFileName = imageProvider
                                            .selectedImagePath!
                                            .split('/')
                                            .last;
                                        String outputPath =
                                            outputDir + '/' + outputFileName;

                                        try {
                                          String processedImagePath =
                                              await imageProvider.processImage(
                                                outputPath,
                                              );
                                          imageProvider.setProcessedImage(
                                            processedImagePath,
                                          );
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Image processed successfully!',
                                              ),
                                            ),
                                          );
                                        } catch (e) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                'Error processing image: $e',
                                              ),
                                            ),
                                          );
                                        }
                                      }
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),

                          // Preview area
                          Expanded(
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Theme.of(context).dividerColor,
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const ImagePreview(),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
