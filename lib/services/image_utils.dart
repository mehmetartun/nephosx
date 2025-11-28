import 'dart:convert';
import 'dart:typed_data';

import 'package:image/image.dart'
    as img
    show encodeJpg, decodeImage, copyCrop, copyResize, Interpolation;
import 'package:image_picker/image_picker.dart';

// import '../../model/extracted_image.dart';
// import '../../model/inserted_image.dart';
import '../../services/logger_service.dart';

class ImageSize {
  final double width;
  final double height;
  final double? x;
  final double? y;
  final double? scaleX;
  final double? scaleY;
  ImageSize({
    required this.width,
    required this.height,
    this.x = 0,
    this.y = 0,
    this.scaleX = 1,
    this.scaleY = 1,
  });

  @override
  String toString() {
    return 'ImageSize(w: $width, h: $height, x: $x, y: $y, sX: $scaleX, sY: $scaleY)';
  }
}

class ImageUtils {
  static double inchesToEMUs(double valueInInches) {
    return valueInInches * 3600000 * 2.54;
  }

  static double cmsToEMUs(double valueInCentimeters) {
    return valueInCentimeters * 3600000 * 1;
  }

  static double emusToInches(double valueInEMUs) {
    return valueInEMUs / (3600000 * 2.54);
  }

  static double emusToCms(double valueInEMUs) {
    return valueInEMUs / (3600000 * 1);
  }

  static void printImageDimensions(Uint8List imageBytes) {
    try {
      final decodedImage = img.decodeImage(imageBytes);
    } catch (e) {
      Logs.instance.error('Error decoding image: $e');
    }
  }

  static String createThumbnail(Uint8List imageBytes) {
    try {
      // Decode the image
      final decodedImage = img.decodeImage(imageBytes);
      if (decodedImage == null) throw Exception('Failed to decode image');

      // Calculate new dimensions while maintaining aspect ratio
      const maxDimension = 200.0;
      final originalWidth = decodedImage.width.toDouble();
      final originalHeight = decodedImage.height.toDouble();

      double newWidth, newHeight;

      if (originalWidth > originalHeight) {
        // Landscape image
        newWidth = maxDimension;
        newHeight = (originalHeight * maxDimension) / originalWidth;
      } else {
        // Portrait or square image
        newHeight = maxDimension;
        newWidth = (originalWidth * maxDimension) / originalHeight;
      }

      // Resize the image
      final resizedImage = img.copyResize(
        decodedImage,
        width: newWidth.round(),
        height: newHeight.round(),
        interpolation: img.Interpolation.linear,
      );

      // Encode to JPEG with reduced quality for smaller file size. Using PNG to preserve transparency.
      final thumbnailBytes = img.encodeJpg(resizedImage, quality: 85);

      // Convert to base64
      final base64String = base64Encode(thumbnailBytes);
      return base64String;
    } catch (e) {
      throw Exception('Failed to create thumbnail: $e');
    }
  }

  /// Converts image bytes to base64 string with data URL format
  static String imageToBase64(
    Uint8List imageBytes, {
    String contentType = 'image/jpeg',
  }) {
    try {
      final base64String = base64Encode(imageBytes);
      return 'data:$contentType;base64,$base64String';
    } catch (e) {
      throw Exception('Failed to convert image to base64: $e');
    }
  }

  static Uint8List? parseBase64Image(String? photoBase64) {
    if (photoBase64 == null || photoBase64.isEmpty) {
      return null;
    }

    try {
      // Handle data URL format (e.g., "data:image/jpeg;base64,/9j/4AAQ...")
      if (photoBase64.startsWith('data:')) {
        // Extract the base64 part after the comma
        final commaIndex = photoBase64.indexOf(',');
        if (commaIndex != -1) {
          final base64Data = photoBase64.substring(commaIndex + 1);
          return base64Decode(base64Data);
        }
      } else {
        // Handle plain base64 string
        return base64Decode(photoBase64);
      }
    } catch (e) {
      Logs.instance.error('Error parsing base64 image: $e');
      return null;
    }

    return null;
  }

  /// Converts an [XFile] object to a [Uint8List].
  static Future<Uint8List> xFileToUint8List(XFile file) async {
    return file.readAsBytes();
  }

  static Future<Uint8List?> cropImage(
    Uint8List imageBytes,
    int x,
    int y,
    int width,
    int height,
  ) async {
    try {
      final originalImage = img.decodeImage(imageBytes);
      if (originalImage == null) {
        throw Exception('Failed to decode image for cropping.');
      }

      final croppedImage = img.copyCrop(
        originalImage,
        x: x,
        y: y,
        width: width,
        height: height,
      );

      // Encode back to PNG to preserve transparency
      return img.encodeJpg(croppedImage, quality: 90);
    } catch (e) {
      Logs.instance.error('Error cropping image: $e');
      return null;
    }
  }
}
