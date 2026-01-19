import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/preset_provider.dart';
import '../l10n/app_localizations.dart';
import 'parameter_controls.dart';
import 'preset_manager.dart';

class SidebarPanel extends StatelessWidget {
  const SidebarPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).cardColor,
      child: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              tabs: [
                Tab(text: 'Parameters'),
                Tab(text: 'Presets'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Parameters tab
                  SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Format Conversion',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<String>(
                            value: 'png',
                            items: ['png', 'jpg', 'jpeg', 'gif', 'bmp', 'webp']
                                .map(
                                  (format) => DropdownMenuItem(
                                    value: format,
                                    child: Text(format.toUpperCase()),
                                  ),
                                )
                                .toList(),
                            onChanged: (value) {},
                            decoration: const InputDecoration(
                              labelText: 'Output Format',
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Size controls
                          const Text(
                            'Size Adjustment',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Width',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 8),
                          TextFormField(
                            decoration: const InputDecoration(
                              labelText: 'Height',
                              border: OutlineInputBorder(),
                            ),
                            keyboardType: TextInputType.number,
                          ),
                          const SizedBox(height: 16),

                          // Quality control
                          const Text(
                            'Quality',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Slider(
                            value: 100.0,
                            min: 1.0,
                            max: 100.0,
                            label: '100%',
                            onChanged: (value) {},
                          ),

                          const SizedBox(height: 16),

                          // Parameter controls
                          const ParameterControls(),
                        ],
                      ),
                    ),
                  ),

                  // Presets tab
                  const Padding(
                    padding: EdgeInsets.all(16.0),
                    child: PresetManager(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
