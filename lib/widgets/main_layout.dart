import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:desktop_drop/desktop_drop.dart';
import '../services/file_service.dart';
import '../providers/image_provider.dart' as ImageTransformProvider;
import '../providers/app_provider.dart';
import '../l10n/app_localizations.dart';
import '../utils/drag_drop_handler.dart';
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
  bool _showSettings = false;
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageTransformProvider.ImageProvider>(
      context,
    );
    final appProvider = Provider.of<AppProvider>(context);
    final localizations = AppLocalizations.of(context)!;

    return DropTarget(
      onDragDone: (details) {
        final imageFiles = DragDropHandler.handleDrop(details);
        if (imageFiles.isNotEmpty) {
          // 如果是批量模式，添加到批处理列表
          if (_selectedIndex == 2) {
            final batchInputPaths = List<String>.from(
              imageProvider.batchInputPaths,
            )..addAll(imageFiles);
            imageProvider.setBatchInputPaths(batchInputPaths);
          } else {
            // 否则设置第一张图片为预览图
            imageProvider.setSelectedImageWithoutPreview(imageFiles.first);
          }
        }
      },
      child: Scaffold(
        body: Column(
          children: [
            // Top toolbar (similar to Pixelmator Pro)
            Container(
              height: 40,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  bottom: BorderSide(
                    color: Theme.of(context).dividerColor,
                    width: 1,
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  80.0,
                  0,
                  8.0,
                  0,
                ), // Increased left padding to avoid overlapping with system window controls
                child: Row(
                  children: [
                    const Spacer(),

                    // Navigation buttons - toggle between Preview and Batch modes
                    if (!_showSettings)
                      if (_selectedIndex ==
                          0) // On Preview screen, show Batch button
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(
                                Icons.batch_prediction,
                                size: 16,
                              ),
                              tooltip: localizations.batchMode,
                              onPressed: () {
                                setState(() {
                                  _selectedIndex = 2;
                                  _showSettings = false;
                                });
                              },
                              style: ButtonStyle(
                                padding: WidgetStateProperty.all(
                                  const EdgeInsets.all(6),
                                ),
                                backgroundColor:
                                    WidgetStateProperty.resolveWith<Color?>((
                                      Set<WidgetState> states,
                                    ) {
                                      if (states.contains(
                                        WidgetState.hovered,
                                      )) {
                                        return Theme.of(context).dividerColor;
                                      }
                                      return Colors.transparent;
                                    }),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                              ),
                            ),
                            // Separator after the mode switch button
                            Container(
                              width: 1,
                              height: 20,
                              color: Theme.of(context).dividerColor,
                            ),
                          ],
                        )
                      else if (_selectedIndex ==
                          2) // On Batch screen, show Preview button
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.photo, size: 16),
                              tooltip: localizations.imagePreview,
                              onPressed: () {
                                setState(() {
                                  _selectedIndex = 0;
                                  _showSettings = false;
                                });
                              },
                              style: ButtonStyle(
                                padding: WidgetStateProperty.all(
                                  const EdgeInsets.all(6),
                                ),
                                backgroundColor:
                                    WidgetStateProperty.resolveWith<Color?>((
                                      Set<WidgetState> states,
                                    ) {
                                      if (states.contains(
                                        WidgetState.hovered,
                                      )) {
                                        return Theme.of(context).dividerColor;
                                      }
                                      return Colors.transparent;
                                    }),
                                shape: WidgetStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4.0),
                                  ),
                                ),
                              ),
                            ),
                            // Separator after the mode switch button
                            Container(
                              width: 1,
                              height: 20,
                              color: Theme.of(context).dividerColor,
                            ),
                          ],
                        ),

                    const SizedBox(width: 8),

                    // File operations - hidden when showing settings
                    if (!_showSettings)
                      IconButton(
                        icon: const Icon(Icons.insert_photo_outlined, size: 16),
                        tooltip: localizations.importImage,
                        onPressed: () async {
                          print('Import button pressed'); // Debug log
                          final path = await FileService.pickSingleImage();
                          print(
                            'File picker returned: ' + (path ?? 'null'),
                          ); // Debug log
                          if (path != null) {
                            try {
                              print(
                                'Setting selected image: $path',
                              ); // Debug log
                              imageProvider.setSelectedImageWithoutPreview(
                                path,
                              );
                              // Request preview update after setting the image
                              imageProvider.requestPreviewUpdate();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Image imported successfully: ${path.split("/").last}',
                                  ),
                                ),
                              );
                            } catch (e) {
                              print('Error setting image: $e'); // Debug log
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error importing image: $e'),
                                ),
                              );
                            }
                          } else {
                            print('No file selected'); // Debug log
                          }
                        },
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.all(6),
                          ),
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color?>((
                                Set<WidgetState> states,
                              ) {
                                if (states.contains(WidgetState.hovered)) {
                                  return Theme.of(context).dividerColor;
                                }
                                return Colors.transparent;
                              }),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
                      ),
                    const SizedBox(width: 8),

                    if (!_showSettings)
                      IconButton(
                        icon: const Icon(Icons.save_outlined, size: 16),
                        tooltip: localizations.export,
                        onPressed: () async {
                          if (imageProvider.selectedImagePath != null &&
                              imageProvider.processedImagePath != null) {
                            // Export the processed image
                            try {
                              String processedImagePath =
                                  imageProvider.processedImagePath!;
                              String originalPath =
                                  imageProvider.selectedImagePath!;
                              String fileName = originalPath.split('/').last;
                              String nameWithoutExt = fileName.substring(
                                0,
                                fileName.lastIndexOf('.'),
                              );
                              String ext = imageProvider.outputFormat;
                              String saveFileName =
                                  '${nameWithoutExt}_converted.$ext';

                              // Use file picker to let user choose save location
                              String? outputPath =
                                  await FileService.saveImageAs(
                                    processedImagePath,
                                    saveFileName,
                                  );
                              if (outputPath != null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'Image saved successfully to $outputPath',
                                    ),
                                  ),
                                );
                              }
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Error saving image: $e'),
                                ),
                              );
                            }
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'No processed image to export. Please select an image and adjust parameters first.',
                                ),
                              ),
                            );
                          }
                        },
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.all(6),
                          ),
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color?>((
                                Set<WidgetState> states,
                              ) {
                                if (states.contains(WidgetState.hovered)) {
                                  return Theme.of(context).dividerColor;
                                }
                                return Colors.transparent;
                              }),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
                      ),

                    const SizedBox(width: 8),

                    // Language selector
                    PopupMenuButton<String>(
                      icon: const Icon(Icons.language, size: 16),
                      tooltip: localizations.language,
                      onSelected: (String languageCode) {
                        appProvider.setLanguage(languageCode);
                      },
                      itemBuilder: (BuildContext context) {
                        return [
                          PopupMenuItem(
                            value: 'en',
                            child: Row(
                              children: [
                                const Icon(Icons.flag, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  'English',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        appProvider.currentLanguageCode == 'en'
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(
                                            context,
                                          ).textTheme.bodySmall?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuItem(
                            value: 'zh',
                            child: Row(
                              children: [
                                const Icon(Icons.flag, size: 16),
                                const SizedBox(width: 8),
                                Text(
                                  '中文',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        appProvider.currentLanguageCode == 'zh'
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(
                                            context,
                                          ).textTheme.bodySmall?.color,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ];
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      offset: const Offset(0, 40),
                    ),

                    // Settings button - hidden when showing settings
                    if (!_showSettings)
                      IconButton(
                        icon: const Icon(Icons.settings_outlined, size: 16),
                        tooltip: localizations.settings,
                        onPressed: () {
                          setState(() {
                            _showSettings = true;
                          });
                        },
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.all(6),
                          ),
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color?>((
                                Set<WidgetState> states,
                              ) {
                                if (states.contains(WidgetState.hovered)) {
                                  return Theme.of(context).dividerColor;
                                }
                                return Colors.transparent;
                              }),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
                      ),

                    if (_showSettings) // Back button
                      IconButton(
                        icon: const Icon(Icons.arrow_back_outlined, size: 16),
                        tooltip: 'Back',
                        onPressed: () {
                          setState(() {
                            _showSettings = false;
                          });
                        },
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.all(6),
                          ),
                          backgroundColor:
                              WidgetStateProperty.resolveWith<Color?>((
                                Set<WidgetState> states,
                              ) {
                                if (states.contains(WidgetState.hovered)) {
                                  return Theme.of(context).dividerColor;
                                }
                                return Colors.transparent;
                              }),
                          shape: WidgetStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4.0),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),

            // Main content area - using original layout to avoid compatibility issues with super_drag_and_drop
            Expanded(
              child: Row(
                children: [
                  // Main content area
                  Expanded(
                    child: IndexedStack(
                      index: _showSettings ? 0 : (_selectedIndex == 2 ? 1 : 2),
                      children: [
                        // Settings page
                        Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: const SettingsPage(),
                        ),
                        // Batch processor with sidebar - show both in batch mode
                        Container(
                          color: Theme.of(context).scaffoldBackgroundColor,
                          child: Row(
                            children: [
                              // Left side - Batch processor
                              Expanded(flex: 2, child: const BatchProcessor()),
                              // Right side - Parameter controls (SidebarPanel)
                              Container(
                                width: 280,
                                decoration: BoxDecoration(
                                  color: Theme.of(
                                    context,
                                  ).scaffoldBackgroundColor,
                                  border: Border(
                                    left: BorderSide(
                                      color: Theme.of(context).dividerColor,
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: SidebarPanel(),
                              ),
                            ],
                          ),
                        ),
                        // Image preview
                        ImagePreview(),
                      ],
                    ),
                  ),

                  // Right sidebar - similar to professional software's properties panel
                  // Only show for non-batch modes (single image processing)
                  if (!_showSettings && _selectedIndex != 2)
                    Container(
                      width: 280,
                      decoration: BoxDecoration(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        border: Border(
                          left: BorderSide(
                            color: Theme.of(context).dividerColor,
                            width: 1,
                          ),
                        ),
                      ),
                      child: SidebarPanel(),
                    ),
                ],
              ),
            ),
          ],
        ),
      ), // Close Scaffold
    ); // Close DropTarget
  } // Close build method
} // Close _MainLayoutState class
