import 'dart:io';
import 'package:path/path.dart' as path;

class ExportOptions {
  final String outputDirectory;
  final String fileNamePattern;
  final bool overwriteExisting;
  final bool createSubfolder;

  ExportOptions({
    required this.outputDirectory,
    this.fileNamePattern = '{originalName}_converted.{ext}',
    this.overwriteExisting = false,
    this.createSubfolder = false,
  });
}

class ExportService {
  static Future<String> exportImage(
    String inputPath,
    String outputPath, {
    String? newName,
  }) async {
    try {
      final inputFile = File(inputPath);
      if (!await inputFile.exists()) {
        throw Exception('Input file does not exist: $inputPath');
      }

      String outputFilePath = outputPath;
      if (newName != null) {
        String dir = path.dirname(outputPath);
        String ext = path.extension(outputPath);
        outputFilePath = path.join(dir, '$newName$ext');
      }

      // Ensure output directory exists
      String outputDir = path.dirname(outputFilePath);
      await Directory(outputDir).create(recursive: true);

      // Copy the file to the destination
      final outputFile = File(outputFilePath);
      await inputFile.copy(outputFilePath);

      return outputFilePath;
    } catch (e) {
      throw Exception('Failed to export image: $e');
    }
  }

  static Future<List<String>> exportMultipleImages(
    List<String> inputPaths,
    ExportOptions options, {
    Function(int current, int total)? onProgress,
  }) async {
    final exportedPaths = <String>[];
    final int total = inputPaths.length;

    String outputDir = options.outputDirectory;
    if (options.createSubfolder) {
      String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      outputDir = path.join(options.outputDirectory, 'export_$timestamp');
      await Directory(outputDir).create(recursive: true);
    }

    for (int i = 0; i < inputPaths.length; i++) {
      String inputPath = inputPaths[i];

      try {
        String originalName = path.basenameWithoutExtension(inputPath);
        String originalExt = path.extension(inputPath);

        // Generate output filename based on pattern
        String outputFileName = options.fileNamePattern
            .replaceAll('{originalName}', originalName)
            .replaceAll(
              '{ext}',
              originalExt.substring(1),
            ); // Remove the dot from extension

        String outputPath = path.join(outputDir, outputFileName);

        // Handle overwrite option
        if (!options.overwriteExisting) {
          outputPath = _ensureUniqueFileName(outputPath);
        }

        // Export the image
        String exportedPath = await exportImage(inputPath, outputPath);
        exportedPaths.add(exportedPath);

        // Report progress
        if (onProgress != null) {
          onProgress(i + 1, total);
        }
      } catch (e) {
        print('Error exporting ${inputPaths[i]}: $e');
      }
    }

    return exportedPaths;
  }

  static String _ensureUniqueFileName(String filePath) {
    if (!File(filePath).existsSync()) {
      return filePath;
    }

    String dir = path.dirname(filePath);
    String name = path.basenameWithoutExtension(filePath);
    String ext = path.extension(filePath);

    int counter = 1;
    String uniquePath;
    do {
      uniquePath = path.join(dir, '${name}_$counter$ext');
      counter++;
    } while (File(uniquePath).existsSync());

    return uniquePath;
  }

  static Future<String> getAvailableOutputDirectory() async {
    // Get the default documents directory
    String? outputDir = await _getDefaultOutputDirectory();
    if (outputDir == null) {
      // Fallback to temporary directory if documents directory is not available
      outputDir = Directory.systemTemp.path;
    }
    return outputDir;
  }

  static Future<String?> _getDefaultOutputDirectory() async {
    // On macOS, we can try to get the user's Pictures or Documents directory
    try {
      // This is a simplified approach
      // In a real app, you'd use platform channels or a package like path_provider
      // to get the proper system directories
      String homeDir = Directory.current.path;
      String picturesDir = path.join(homeDir, 'Pictures');

      if (await Directory(picturesDir).exists()) {
        return picturesDir;
      }

      return homeDir;
    } catch (e) {
      print('Error getting default output directory: $e');
      return null;
    }
  }
}
