import 'dart:io';
import 'package:path/path.dart' as path;

/// Helper functions for the Image Transformer app
class ImageHelpers {
  /// Checks if a file is a supported image format
  static bool isSupportedImageFormat(String filePath) {
    final extension = path.extension(filePath).toLowerCase();
    // Remove the leading dot
    final format = extension.startsWith('.')
        ? extension.substring(1)
        : extension;

    const supportedFormats = {
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

    return supportedFormats.contains(format);
  }

  /// Generates a valid output filename based on input and format
  static String generateOutputPath(String inputPath, String outputFormat) {
    String dir = path.dirname(inputPath);
    String baseName = path.basenameWithoutExtension(inputPath);

    return path.join(dir, '${baseName}_converted.$outputFormat');
  }

  /// Validates image processing parameters
  static bool validateProcessingParams({
    int? width,
    int? height,
    int quality = 100,
    double brightness = 0.0,
    double contrast = 1.0,
    double saturation = 1.0,
  }) {
    if (width != null && width <= 0) return false;
    if (height != null && height <= 0) return false;
    if (quality < 1 || quality > 100) return false;
    if (brightness < -100 || brightness > 100) return false;
    if (contrast < 0 || contrast > 3) return false; // Reasonable contrast range
    if (saturation < 0 || saturation > 3)
      return false; // Reasonable saturation range

    return true;
  }

  /// Gets human-readable file size
  static String getFileSizeString(int fileSizeInBytes) {
    if (fileSizeInBytes < 1024) {
      return '${fileSizeInBytes} B';
    } else if (fileSizeInBytes < 1024 * 1024) {
      return '${(fileSizeInBytes / 1024).toStringAsFixed(2)} KB';
    } else {
      return '${(fileSizeInBytes / (1024 * 1024)).toStringAsFixed(2)} MB';
    }
  }

  /// Checks if a directory is writable
  static Future<bool> canWriteToDirectory(String directoryPath) async {
    try {
      final dir = Directory(directoryPath);
      if (!await dir.exists()) {
        return false;
      }

      // Try to create a temporary file to test write permissions
      final testFile = File(path.join(directoryPath, '.permission_test'));
      await testFile.writeAsString('test');
      await testFile.delete();
      return true;
    } catch (e) {
      return false;
    }
  }
}

/// Utility functions for validation
class ValidationHelpers {
  /// Validates an email address
  static bool isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
    return emailRegex.hasMatch(email);
  }

  /// Validates a URL
  static bool isValidUrl(String url) {
    try {
      final uri = Uri.parse(url);
      return uri.hasScheme && uri.hasAuthority;
    } catch (e) {
      return false;
    }
  }

  /// Checks if a string is a valid hex color
  static bool isValidHexColor(String color) {
    final hexRegex = RegExp(r'^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$');
    return hexRegex.hasMatch(color);
  }
}
