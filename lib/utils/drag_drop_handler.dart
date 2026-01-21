import 'dart:io';
import 'package:desktop_drop/desktop_drop.dart';

class DragDropHandler {
  /// 检查文件是否为支持的图像格式
  static bool isImageFile(String filePath) {
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

  /// 过滤出支持的图像文件
  static List<String> filterImageFiles(List<String> filePaths) {
    return filePaths.where((path) => isImageFile(path)).toList();
  }

  /// 处理拖拽事件，返回有效的图像文件路径
  static List<String> handleDrop(DropDoneDetails event) {
    final filePaths = <String>[];

    for (final file in event.files) {
      final path = file.path;
      if (File(path).existsSync() && isImageFile(path)) {
        filePaths.add(path);
      }
    }

    return filePaths;
  }
}
