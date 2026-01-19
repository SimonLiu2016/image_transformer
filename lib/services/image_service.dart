import 'dart:io';
import 'dart:typed_data';
import 'package:image/image.dart' as img;
import 'package:flutter_image_compress/flutter_image_compress.dart';

class ImageProcessingConfig {
  final String outputFormat;
  final int? width;
  final int? height;
  final int quality;
  final double brightness;
  final double contrast;
  final double saturation;
  final double rotation;
  final bool flipHorizontal;
  final bool flipVertical;

  ImageProcessingConfig({
    this.outputFormat = 'png',
    this.width,
    this.height,
    this.quality = 80,
    this.brightness = 0.0,
    this.contrast = 1.0,
    this.saturation = 1.0,
    this.rotation = 0.0,
    this.flipHorizontal = false,
    this.flipVertical = false,
  });

  ImageProcessingConfig copyWith({
    String? outputFormat,
    int? width,
    int? height,
    int? quality,
    double? brightness,
    double? contrast,
    double? saturation,
    double? rotation,
    bool? flipHorizontal,
    bool? flipVertical,
  }) {
    return ImageProcessingConfig(
      outputFormat: outputFormat ?? this.outputFormat,
      width: width ?? this.width,
      height: height ?? this.height,
      quality: quality ?? this.quality,
      brightness: brightness ?? this.brightness,
      contrast: contrast ?? this.contrast,
      saturation: saturation ?? this.saturation,
      rotation: rotation ?? this.rotation,
      flipHorizontal: flipHorizontal ?? this.flipHorizontal,
      flipVertical: flipVertical ?? this.flipVertical,
    );
  }
}

class ImageService {
  static Future<String> processImage(
    String inputPath,
    String outputPath,
    ImageProcessingConfig config,
  ) async {
    try {
      // Read the input image
      final inputFile = File(inputPath);
      final inputData = await inputFile.readAsBytes();
      final image = img.decodeImage(inputData);

      if (image == null) {
        throw Exception('Could not decode image');
      }

      // Apply transformations in order
      var processedImage = image;

      // Apply rotation
      if (config.rotation > 0) {
        processedImage = _rotateImage(processedImage, config.rotation);
      }

      // Apply flips
      if (config.flipHorizontal) {
        processedImage = img.flipHorizontal(processedImage);
      }
      if (config.flipVertical) {
        processedImage = img.flipVertical(processedImage);
      }

      // Apply dimensions (resize)
      if (config.width != null || config.height != null) {
        int newWidth =
            config.width ??
            (processedImage.width * (config.height! / processedImage.height))
                .round();
        int newHeight =
            config.height ??
            (processedImage.height * (config.width! / processedImage.width))
                .round();
        processedImage = img.copyResize(
          processedImage,
          width: newWidth,
          height: newHeight,
        );
      }

      // Apply color adjustments
      processedImage = _adjustColors(
        processedImage,
        brightness: config.brightness,
        contrast: config.contrast,
        saturation: config.saturation,
      );

      // Encode the image based on output format
      Uint8List encodedData;
      switch (config.outputFormat.toLowerCase()) {
        case 'jpg':
        case 'jpeg':
          encodedData = img.encodeJpg(processedImage, quality: config.quality);
          break;
        case 'png':
          encodedData = img.encodePng(processedImage);
          break;
        case 'gif':
          encodedData = img.encodeGif(processedImage);
          break;
        case 'bmp':
          encodedData = img.encodeBmp(processedImage);
          break;
        case 'webp':
          // For WebP, we'll use flutter_image_compress after encoding as PNG/JPG
          encodedData = img.encodePng(processedImage);
          break;
        default:
          encodedData = img.encodePng(processedImage);
      }

      // Compress if needed (especially for JPEG)
      if (config.outputFormat.toLowerCase() == 'webp') {
        // Use flutter_image_compress for WebP conversion
        encodedData = await FlutterImageCompress.compressWithList(
          encodedData,
          quality: config.quality,
        );
      } else if (config.quality < 100 &&
          (config.outputFormat.toLowerCase() == 'jpg' ||
              config.outputFormat.toLowerCase() == 'jpeg')) {
        // Compress JPEG
        encodedData = await FlutterImageCompress.compressWithList(
          encodedData,
          quality: config.quality,
        );
      }

      // Write the output image
      final outputFile = File(outputPath);
      await outputFile.writeAsBytes(encodedData);

      return outputPath;
    } catch (e) {
      print('Error processing image: $e');
      rethrow;
    }
  }

  static img.Image _rotateImage(img.Image src, double degrees) {
    switch (degrees.round()) {
      case 90:
        return img.copyRotate(src, angle: 90);
      case 180:
        return img.copyRotate(src, angle: 180);
      case 270:
        return img.copyRotate(src, angle: 270);
      default:
        // For arbitrary rotations, use the general rotate function
        return img.copyRotate(src, angle: degrees);
    }
  }

  static img.Image _adjustColors(
    img.Image src, {
    double brightness = 0.0,
    double contrast = 1.0,
    double saturation = 1.0,
  }) {
    // For now, return the original image
    // Color adjustment functionality requires the correct version of image package
    // and its API, which varies by version
    return src;
  }

  static Future<String> convertFormat(
    String inputPath,
    String outputFormat,
    String outputDirectory,
  ) async {
    final fileName = _getFileNameWithoutExtension(inputPath);
    final extension = _getValidExtension(outputFormat);
    final outputPath = '$outputDirectory/${fileName}_converted.$extension';

    final config = ImageProcessingConfig(
      outputFormat: outputFormat.toLowerCase(),
    );

    return await processImage(inputPath, outputPath, config);
  }

  static String _getFileNameWithoutExtension(String filePath) {
    final fileName = filePath.split('/').last;
    final parts = fileName.split('.');
    parts.removeLast(); // Remove extension
    return parts.join('.');
  }

  static String _getValidExtension(String format) {
    switch (format.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'jpg';
      case 'png':
      case 'gif':
      case 'bmp':
      case 'webp':
        return format.toLowerCase();
      default:
        return 'png';
    }
  }

  static Future<Map<String, dynamic>> getImageInfo(String imagePath) async {
    try {
      final file = File(imagePath);
      final bytes = await file.readAsBytes();
      final image = img.decodeImage(bytes);

      if (image == null) {
        throw Exception('Could not decode image');
      }

      return {
        'width': image.width,
        'height': image.height,
        'sizeInBytes': await file.length(),
        'path': imagePath,
        'fileName': file.path.split('/').last,
      };
    } catch (e) {
      print('Error getting image info: $e');
      rethrow;
    }
  }
}
