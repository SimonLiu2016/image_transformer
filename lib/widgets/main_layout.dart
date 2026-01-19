import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/file_service.dart';
import '../providers/image_provider.dart' as ImageTransformProvider;
import '../providers/app_provider.dart';
import '../l10n/app_localizations.dart';
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

    return Scaffold(
      body: Column(
        children: [
          // Top toolbar (similar to professional software like Photoshop/VSCode)
          Container(
            height: 40,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surfaceVariant,
              border: Border(
                bottom: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(80.0, 0, 8.0, 0), // Increased left padding to avoid overlapping with system window controls
              child: Row(
                children: [
                  // Logo/icon area
                  Container(
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.photo_filter,
                      size: 20,
                      color: Color(0xFF007ACC),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // File operations
                  IconButton(
                    icon: const Icon(Icons.upload, size: 16),
                    tooltip: localizations.importImage,
                    onPressed: () async {
                      final path = await FileService.pickSingleImage();
                      if (path != null) {
                        imageProvider.setSelectedImage(path);
                      }
                    },
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(const EdgeInsets.all(6)),
                    ),
                  ),

                  IconButton(
                    icon: const Icon(Icons.download, size: 16),
                    tooltip: localizations.export,
                    onPressed: () {
                      // Export functionality would go here
                    },
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(const EdgeInsets.all(6)),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Separator
                  Container(
                    width: 1,
                    height: 20,
                    color: Theme.of(context).dividerColor,
                  ),

                  const SizedBox(width: 8),

                  // Batch mode toggle
                  Row(
                    children: [
                      Text(
                        localizations.batchMode,
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      Switch(
                        value: _isBatchMode,
                        onChanged: (value) {
                          setState(() {
                            _isBatchMode = value;
                          });
                        },
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ],
                  ),

                  const Spacer(),

                  // Navigation buttons
                  if (_selectedIndex != 0 && !_showSettings) // Home button
                    IconButton(
                      icon: const Icon(Icons.home, size: 16),
                      tooltip: localizations.title,
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
                      ),
                    ),

                  if (_selectedIndex != 1 && !_showSettings) // Preview button
                    IconButton(
                      icon: const Icon(Icons.photo, size: 16),
                      tooltip: localizations.imagePreview,
                      onPressed: () {
                        setState(() {
                          _selectedIndex = 1;
                          _showSettings = false;
                        });
                      },
                      style: ButtonStyle(
                        padding: WidgetStateProperty.all(
                          const EdgeInsets.all(6),
                        ),
                      ),
                    ),

                  if (_selectedIndex != 2 && !_showSettings) // Batch button
                    IconButton(
                      icon: const Icon(Icons.batch_prediction, size: 16),
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
                      ),
                    ),

                  if (!_showSettings) // Settings button
                    IconButton(
                      icon: const Icon(Icons.settings, size: 16),
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
                      ),
                    ),

                  if (_showSettings) // Back button
                    IconButton(
                      icon: const Icon(Icons.arrow_back, size: 16),
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
                      ),
                    ),
                ],
              ),
            ),
          ),

          // Main content area
          Expanded(
            child: Row(
              children: [
                // Left sidebar - similar to professional software's tools panel
                Container(
                  width: 280,
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardColor,
                    border: Border(
                      right: BorderSide(
                        color: Theme.of(context).dividerColor,
                        width: 1,
                      ),
                    ),
                  ),
                  child: _showSettings
                      ? const SettingsPage()
                      : _selectedIndex == 2
                      ? const BatchProcessor()
                      : SidebarPanel(),
                ),

                // Main content area
                Expanded(
                  child: _showSettings
                      ? const SizedBox.shrink()
                      : _selectedIndex == 2
                      ? const SizedBox.shrink()
                      : ImagePreview(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
