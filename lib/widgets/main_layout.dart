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
                  // Logo/icon area
                  Container(
                    padding: const EdgeInsets.all(4),
                    child: const Icon(
                      Icons.brush,
                      size: 16,
                      color: Color(0xFF007AFF),
                    ),
                  ),
                  const SizedBox(width: 2),

                  const SizedBox(width: 8),

                  const Spacer(),

                  // File operations
                  IconButton(
                    icon: const Icon(Icons.insert_photo_outlined, size: 16),
                    tooltip: localizations.importImage,
                    onPressed: () async {
                      final path = await FileService.pickSingleImage();
                      if (path != null) {
                        imageProvider.setSelectedImage(path);
                      }
                    },
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(const EdgeInsets.all(6)),
                      backgroundColor: WidgetStateProperty.resolveWith<Color?>((
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

                  IconButton(
                    icon: const Icon(Icons.save_outlined, size: 16),
                    tooltip: localizations.export,
                    onPressed: () {
                      // Export functionality would go here
                    },
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(const EdgeInsets.all(6)),
                      backgroundColor: WidgetStateProperty.resolveWith<Color?>((
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

                  // Separator
                  Container(
                    width: 1,
                    height: 20,
                    color: Theme.of(context).dividerColor,
                  ),

                  const SizedBox(width: 8),

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
                                  color: appProvider.currentLanguageCode == 'en'
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
                                  color: appProvider.currentLanguageCode == 'zh'
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

                  // Settings button
                  IconButton(
                    icon: const Icon(Icons.settings_outlined, size: 16),
                    tooltip: localizations.settings,
                    onPressed: () {
                      setState(() {
                        _showSettings = true;
                      });
                    },
                    style: ButtonStyle(
                      padding: WidgetStateProperty.all(const EdgeInsets.all(6)),
                      backgroundColor: WidgetStateProperty.resolveWith<Color?>((
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

          // Main content area
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
                      // Batch processor
                      Container(
                        color: Theme.of(context).scaffoldBackgroundColor,
                        child: const BatchProcessor(),
                      ),
                      // Image preview
                      ImagePreview(),
                    ],
                  ),
                ),

                // Right sidebar - similar to professional software's properties panel
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
    );
  }
}
