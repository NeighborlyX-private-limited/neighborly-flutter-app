import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path/path.dart' as p;
import 'dart:io';
import 'package:cross_file/cross_file.dart'; // XFile class

Future<XFile> compressImage({
  required XFile? imageFileX,
  int quality = 95,
  CompressFormat format = CompressFormat.jpeg,
}) async {
  File imageFile;
  if (imageFileX != null) {
    imageFile = File(imageFileX.path); // Convert XFile to File
  } else {
    throw ("Failed to load the image");
  }

  final String targetPath =
      p.join(Directory.systemTemp.path, '${DateTime.now()}temp.${format.name}');
  final XFile? compressedImage = await FlutterImageCompress.compressAndGetFile(
      imageFile.path, targetPath,
      quality: quality, format: format);
  print(targetPath);

  if (compressedImage == null) {
    throw ("Failed to compress the image");
  }
  print(File(compressedImage.path).lengthSync() / (1024 * 1024));
  if (File(compressedImage.path).lengthSync() / (1024 * 1024) > 1.00) {
    return compressImage(imageFileX: compressedImage, quality: 90);
  }
  return compressedImage;
}
