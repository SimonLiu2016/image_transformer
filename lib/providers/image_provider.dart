import 'package:flutter/foundation.dart';

import 'dart:io';
import '../services/image_service.dart';

class ImageProvider extends ChangeNotifier {
  String? _selectedImagePath;
  String? _processedImagePath;
  double _brightness = 0.0;
  double _contrast = 1.0;
  double _saturation = 1.0;
  double _rotation = 0.0;
  int _width = 0;
  int _height = 0;
  String _outputFormat = 'png';
  double _quality = 100.0;

  String? get selectedImagePath => _selectedImagePath;
  String? get processedImagePath => _processedImagePath;
  double get brightness => _brightness;
  double get contrast => _contrast;
  double get saturation => _saturation;
  double get rotation => _rotation;
  int get width => _width;
  int get height => _height;
  String get outputFormat => _outputFormat;
  double get quality => _quality;

  void setSelectedImage(String path) {
    _selectedImagePath = path;
    notifyListeners();
  }

  void setProcessedImage(String path) {
    _processedImagePath = path;
    notifyListeners();
  }

  void setBrightness(double value) {
    _brightness = value;
    notifyListeners();
  }

  void setContrast(double value) {
    _contrast = value;
    notifyListeners();
  }

  void setSaturation(double value) {
    _saturation = value;
    notifyListeners();
  }

  void setRotation(double value) {
    _rotation = value;
    notifyListeners();
  }

  void setDimensions(int width, int height) {
    _width = width;
    _height = height;
    notifyListeners();
  }

  void setOutputFormat(String format) {
    _outputFormat = format;
    notifyListeners();
  }

  void setQuality(double value) {
    _quality = value;
    notifyListeners();
  }

  void reset() {
    _brightness = 0.0;
    _contrast = 1.0;
    _saturation = 1.0;
    _rotation = 0.0;
    _width = 0;
    _height = 0;
    _outputFormat = 'png';
    _quality = 100.0;
    notifyListeners();
  }

  Future<String> processImage(String outputPath) async {
    if (_selectedImagePath == null) {
      throw Exception('No image selected');
    }

    final config = ImageProcessingConfig(
      outputFormat: _outputFormat,
      width: _width > 0 ? _width : null,
      height: _height > 0 ? _height : null,
      quality: _quality.round(),
      brightness: _brightness,
      contrast: _contrast,
      saturation: _saturation,
      rotation: _rotation,
    );

    return await ImageService.processImage(
      _selectedImagePath!,
      outputPath,
      config,
    );
  }

  // Batch processing properties
  List<String> _batchInputPaths = [];
  bool _isBatchProcessing = false;
  int _batchProcessedCount = 0;
  int _batchTotalCount = 0;
  String _batchStatusMessage = '';

  List<String> get batchInputPaths => _batchInputPaths;
  bool get isBatchProcessing => _isBatchProcessing;
  int get batchProcessedCount => _batchProcessedCount;
  int get batchTotalCount => _batchTotalCount;
  String get batchStatusMessage => _batchStatusMessage;

  void setBatchInputPaths(List<String> paths) {
    _batchInputPaths = paths;
    notifyListeners();
  }

  void startBatchProcessing() {
    _isBatchProcessing = true;
    _batchProcessedCount = 0;
    _batchTotalCount = _batchInputPaths.length;
    _batchStatusMessage = 'Starting batch processing...';
    notifyListeners();
  }

  void updateBatchProgress(int processed, int total) {
    _batchProcessedCount = processed;
    _batchTotalCount = total;
    _batchStatusMessage = 'Processed $processed of $total images';
    notifyListeners();
  }

  void finishBatchProcessing() {
    _isBatchProcessing = false;
    _batchStatusMessage = 'Batch processing completed';
    notifyListeners();
  }

  void cancelBatchProcessing() {
    _isBatchProcessing = false;
    _batchStatusMessage = 'Batch processing cancelled';
    notifyListeners();
  }

  Future<void> startBatchProcess(String outputDirectory) async {
    if (_batchInputPaths.isEmpty) {
      _batchStatusMessage = 'No images to process';
      notifyListeners();
      return;
    }

    startBatchProcessing();

    try {
      final config = ImageProcessingConfig(
        outputFormat: _outputFormat,
        width: _width > 0 ? _width : null,
        height: _height > 0 ? _height : null,
        quality: _quality.round(),
        brightness: _brightness,
        contrast: _contrast,
        saturation: _saturation,
        rotation: _rotation,
      );

      for (int i = 0; i < _batchInputPaths.length; i++) {
        if (!_isBatchProcessing) {
          // Processing was cancelled
          break;
        }

        try {
          String inputPath = _batchInputPaths[i];
          String fileName = inputPath.split('/').last;
          String nameWithoutExt = fileName.substring(
            0,
            fileName.lastIndexOf('.'),
          );
          String outputPath =
              '$outputDirectory/$nameWithoutExt._converted.$outputFormat';

          await ImageService.processImage(inputPath, outputPath, config);
        } catch (e) {
          print('Error processing ${_batchInputPaths[i]}: $e');
        }

        updateBatchProgress(i + 1, _batchInputPaths.length);
      }

      finishBatchProcessing();
    } catch (e) {
      _batchStatusMessage = 'Error during batch processing: $e';
      _isBatchProcessing = false;
      notifyListeners();
    }
  }
}
