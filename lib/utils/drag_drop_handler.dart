import 'dart:io';
import 'package:desktop_drop/desktop_drop.dart';

class DragDropHandler {
  /// 检查文件是否为支持的图像格式
  static bool isImageFile(String filePath) {
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
