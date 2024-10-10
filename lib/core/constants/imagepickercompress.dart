// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:path/path.dart' as p;
// import 'dart:io';
// import 'package:cross_file/cross_file.dart'; // XFile class

// Future<XFile> compressImage({
//   required XFile? imageFileX,
//   int quality = 95,
//   CompressFormat format = CompressFormat.jpeg,
// }) async {
//   File imageFile;
//   if (imageFileX != null) {
//     imageFile = File(imageFileX.path); // Convert XFile to File
//   } else {
//     throw ("Failed to load the image");
//   }

//   final String targetPath =
//       p.join(Directory.systemTemp.path, '${DateTime.now()}temp.${format.name}');
//   final XFile? compressedImage = await FlutterImageCompress.compressAndGetFile(
//       imageFile.path, targetPath,
//       quality: quality, format: format);
//   print(targetPath);

//   if (compressedImage == null) {
//     throw ("Failed to compress the image");
//   }
//   print(File(compressedImage.path).lengthSync() / (1024 * 1024));
//   if (File(compressedImage.path).lengthSync() / (1024 * 1024) > 1.00) {
//     return compressImage(imageFileX: compressedImage, quality: 90);
//   }
//   return compressedImage;
// }
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'dart:io';

Future<XFile> compressImage({
  required XFile? imageFileX,
  int initialQuality = 95,
  double sizeLimitMB = 1.00,
  CompressFormat format = CompressFormat.jpeg,
}) async {
  if (imageFileX == null) {
    throw ("Failed to load the image");
  }

  // Convert XFile to File
  File imageFile = File(imageFileX.path);

  // Generate a target path for compressed image
  final String targetPath = p.join(
    Directory.systemTemp.path,
    '${DateTime.now()}_compressed.${format.name}',
  );

  // Compress the image with the initial quality
  XFile? compressedImage = await FlutterImageCompress.compressAndGetFile(
    imageFile.path,
    targetPath,
    quality: initialQuality,
    format: format,
  );

  if (compressedImage == null) {
    throw ("Failed to compress the image");
  }

  // Check if the compressed image is within the size limit
  double imageSizeMB = File(compressedImage.path).lengthSync() / (1024 * 1024);
  print("Initial Image Size: ${imageSizeMB.toStringAsFixed(2)} MB");

  // Reduce quality only if the file size is greater than the limit
  int currentQuality = initialQuality;
  while (imageSizeMB > sizeLimitMB && currentQuality > 50) {
    // Reduce quality by 5% each time until it fits or quality is too low
    currentQuality -= 5;
    compressedImage = await FlutterImageCompress.compressAndGetFile(
      imageFile.path,
      targetPath,
      quality: currentQuality,
      format: format,
    );

    // Update the new file size after compression
    if (compressedImage != null) {
      imageSizeMB = File(compressedImage.path).lengthSync() / (1024 * 1024);
      print(
          "Compressed Image Size: ${imageSizeMB.toStringAsFixed(2)} MB with Quality: $currentQuality");
    } else {
      break;
    }
  }

  return compressedImage ?? imageFileX;
}
