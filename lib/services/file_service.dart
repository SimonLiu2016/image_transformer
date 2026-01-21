import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as path;

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
      // 通用常用格式
      'jpg',
      'jpeg',
      'png',
      'gif',
      'bmp',
      'webp',
      'tiff',
      'tif',
      'heic',
      'heif',
      'avif',
      'icns',

      // 专业摄影/后期格式
      'raw',
      'cr2', // 佳能RAW
      'cr3', // 佳能RAW
      'nef', // 尼康RAW
      'arw', // 索尼RAW
      'orf', // 奥林巴斯RAW
      'dng', // Adobe通用RAW
      // 软件专属/行业专用格式
      'psd',
      'pdd',
      'tga',
      'pcx',
      'wmf',
      'emf',
      'cur',
      'ico',
      'xbm',
      'xpm',

      // 小众/老旧格式
      'bpg',
      'pbm',
      'pgm',
      'ppm',
      'sgi',

      // 矢量图格式（可转换为位图）
      'svg',
      'pdf',
      'eps',
      'ai',
      'cdr',
      'svgz', // SVG压缩格式
      // 工程制图格式
      'dwg', // AutoCAD格式
      'dxf', // AutoCAD交换格式
      // 传真和移动格式
      'tfx', // 传真格式
      'wbmp', // 无线位图格式
      // 矢量图形格式
      'cgm', // 计算机图形元文件格式
      'vml', // 矢量标记语言
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

  static Future<String?> saveImageAs(
    String sourceImagePath,
    String suggestedFileName,
  ) async {
    try {
      // Get the file extension from the original file if suggested name doesn't have one
      String fileName = suggestedFileName;
      if (!suggestedFileName.contains('.')) {
        String originalExt = path.extension(sourceImagePath);
        fileName = suggestedFileName + originalExt;
      }

      // Use file_picker to let user choose save location
      String? outputPath = await FilePicker.platform.saveFile(
        dialogTitle: 'Save processed image',
        fileName: fileName,
        allowedExtensions: [_getImageExtension(fileName)],
      );

      if (outputPath != null) {
        // Copy the processed image to the selected location
        File sourceFile = File(sourceImagePath);
        await sourceFile.copy(outputPath);
        return outputPath;
      }

      return null;
    } catch (e) {
      print('Error saving image: $e');
      return null;
    }
  }

  static String _getImageExtension(String fileName) {
    if (fileName.contains('.')) {
      return fileName.split('.').last.toLowerCase();
    }
    return 'png'; // default extension
  }
}
