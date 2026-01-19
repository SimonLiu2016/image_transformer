import 'dart:io';
import 'package:file_picker/file_picker.dart';

class FileService {
  static Future<String?> pickSingleImage() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );

      if (result != null && result.files.single.path != null) {
        return result.files.single.path!;
      }
      return null;
    } catch (e) {
      print('Error picking image: $e');
      return null;
    }
  }

  static Future<List<String>> pickMultipleImages() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: true,
      );

      if (result != null) {
        return result.files
            .where((file) => file.path != null)
            .map((file) => file.path!)
            .toList();
      }
      return [];
    } catch (e) {
      print('Error picking images: $e');
      return [];
    }
  }

  static Future<List<String>> pickImagesFromDirectory() async {
    try {
      String? directoryPath = await FilePicker.platform.getDirectoryPath();

      if (directoryPath != null) {
        Directory directory = Directory(directoryPath);
        List<FileSystemEntity> entities = directory.listSync();

        List<String> imagePaths = entities
            .whereType<File>()
            .where((file) => _isImageFile(file.path))
            .map((file) => file.path)
            .toList();

        return imagePaths;
      }
      return [];
    } catch (e) {
      print('Error picking images from directory: $e');
      return [];
    }
  }

  static bool _isImageFile(String filePath) {
    final extension = filePath.toLowerCase().split('.').last;
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
    return imageExtensions.contains(extension);
  }

  static Future<bool> isValidImageFile(String filePath) async {
    try {
      File file = File(filePath);
      if (!await file.exists()) {
        return false;
      }

      return _isImageFile(filePath);
    } catch (e) {
      print('Error validating image file: $e');
      return false;
    }
  }
}
