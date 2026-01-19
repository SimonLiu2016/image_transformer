import 'dart:io';
import 'package:path/path.dart' as path;
import 'image_service.dart';

class BatchProcessingResult {
  final String inputPath;
  final String outputPath;
  final bool success;
  final String? error;

  BatchProcessingResult({
    required this.inputPath,
    required this.outputPath,
    required this.success,
    this.error,
  });
}

class BatchService {
  static Future<List<BatchProcessingResult>> processBatch(
    List<String> inputPaths,
    String outputDirectory,
    ImageProcessingConfig config, {
    Function(int processed, int total)? onProgress,
  }) async {
    final results = <BatchProcessingResult>[];
    int total = inputPaths.length;
    int processed = 0;

    for (String inputPath in inputPaths) {
      try {
        // Generate output path
        String fileName = path.basenameWithoutExtension(inputPath);
        String extension = config.outputFormat;
        String outputPath =
            '$outputDirectory/$fileName.${_getExtension(extension)}';

        // Process the image
        String resultPath = await ImageService.processImage(
          inputPath,
          outputPath,
          config,
        );

        results.add(
          BatchProcessingResult(
            inputPath: inputPath,
            outputPath: resultPath,
            success: true,
          ),
        );
      } catch (e) {
        results.add(
          BatchProcessingResult(
            inputPath: inputPath,
            outputPath: '',
            success: false,
            error: e.toString(),
          ),
        );
      }

      processed++;
      if (onProgress != null) {
        onProgress(processed, total);
      }
    }

    return results;
  }

  static String _getExtension(String format) {
    switch (format.toLowerCase()) {
      case 'jpg':
        return 'jpg';
      case 'jpeg':
        return 'jpeg';
      case 'png':
      case 'gif':
      case 'bmp':
      case 'webp':
        return format.toLowerCase();
      default:
        return 'png';
    }
  }

  static Future<List<String>> getImagesFromDirectory(
    String directoryPath,
  ) async {
    final directory = Directory(directoryPath);
    if (!await directory.exists()) {
      return [];
    }

    final List<FileSystemEntity> entities = directory.listSync();
    final List<String> imagePaths = [];

    for (FileSystemEntity entity in entities) {
      if (entity is File) {
        String filePath = entity.path.toLowerCase();
        if (_isImageFile(filePath)) {
          imagePaths.add(entity.path);
        }
      }
    }

    return imagePaths;
  }

  static bool _isImageFile(String filePath) {
    final extension = filePath.split('.').last;
    const imageExtensions = {
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp',
      'webp',
      'tiff',
      'tif',
      'heic',
    };
    return imageExtensions.contains(extension.toLowerCase());
  }
}
