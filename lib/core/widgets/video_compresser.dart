import 'dart:io';


Future<File> compressVideo(File path) async {
  await VideoCompress.setLogLevel(0);
  final compressVideo = await VideoCompress.compressVideo(
    path.path,
    quality: VideoQuality.MediumQuality,
    deleteOrigin: false,
    includeAudio: true,
  );

  return compressVideo!.file!;
}
