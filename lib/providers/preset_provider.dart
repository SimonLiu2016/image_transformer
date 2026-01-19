import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'image_provider.dart' as ImageTransformProvider;

class Preset {
  final String id;
  final String name;
  final Map<String, dynamic> parameters;

  Preset({required this.id, required this.name, required this.parameters});

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'parameters': parameters};
  }

  factory Preset.fromJson(Map<String, dynamic> json) {
    return Preset(
      id: json['id'],
      name: json['name'],
      parameters: json['parameters'],
    );
  }
}

class PresetProvider extends ChangeNotifier {
  List<Preset> _presets = [];
  String _selectedPresetId = '';

  List<Preset> get presets => _presets;
  String get selectedPresetId => _selectedPresetId;
  Preset? get selectedPreset {
    try {
      return _presets.firstWhere((preset) => preset.id == _selectedPresetId);
    } catch (e) {
      return null;
    }
  }

  PresetProvider() {
    loadPresets();
  }

  Future<void> loadPresets() async {
    final prefs = await SharedPreferences.getInstance();
    final presetsJson = prefs.getStringList('presets') ?? [];

    _presets = presetsJson
        .map((jsonString) => Preset.fromJson(json.decode(jsonString)))
        .toList();

    notifyListeners();
  }

  Future<void> savePreset(Preset preset) async {
    // Check if a preset with the same id already exists
    final existingIndex = _presets.indexWhere((p) => p.id == preset.id);
    if (existingIndex != -1) {
      _presets[existingIndex] = preset;
    } else {
      _presets.add(preset);
    }

    final prefs = await SharedPreferences.getInstance();
    final presetsJson = _presets
        .map((preset) => json.encode(preset.toJson()))
        .toList();
    await prefs.setStringList('presets', presetsJson);

    notifyListeners();
  }

  Future<void> deletePreset(String id) async {
    _presets.removeWhere((preset) => preset.id == id);

    final prefs = await SharedPreferences.getInstance();
    final presetsJson = _presets
        .map((preset) => json.encode(preset.toJson()))
        .toList();
    await prefs.setStringList('presets', presetsJson);

    if (_selectedPresetId == id) {
      _selectedPresetId = '';
    }

    notifyListeners();
  }

  void selectPreset(String id) {
    _selectedPresetId = id;
    notifyListeners();
  }

  void clearSelectedPreset() {
    _selectedPresetId = '';
    notifyListeners();
  }

  void applyPresetToImageProvider(
    ImageTransformProvider.ImageProvider imageProvider,
  ) {
    if (selectedPreset != null) {
      final params = selectedPreset!.parameters;

      if (params.containsKey('outputFormat')) {
        imageProvider.setOutputFormat(params['outputFormat']);
      }
      if (params.containsKey('width')) {
        imageProvider.setDimensions(params['width'], imageProvider.height);
      }
      if (params.containsKey('height')) {
        imageProvider.setDimensions(imageProvider.width, params['height']);
      }
      if (params.containsKey('quality')) {
        imageProvider.setQuality(params['quality']);
      }
      if (params.containsKey('brightness')) {
        imageProvider.setBrightness(params['brightness']);
      }
      if (params.containsKey('contrast')) {
        imageProvider.setContrast(params['contrast']);
      }
      if (params.containsKey('saturation')) {
        imageProvider.setSaturation(params['saturation']);
      }
      if (params.containsKey('rotation')) {
        imageProvider.setRotation(params['rotation']);
      }
    }
  }
}
