import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_native_image/flutter_native_image.dart';

Future<File> imageCompressed({required File imagePathToCompress, quality = 100}) async {
  debugPrint('Before Compress: ${getFileSizeMB(imagePathToCompress)}');
  File path;
  if (getFileSizeMB(imagePathToCompress) > 0.6 && getFileSizeMB(imagePathToCompress) < 1.00) {
    path = await FlutterNativeImage.compressImage(imagePathToCompress.absolute.path, quality: quality, percentage: 80);
  } else if (getFileSizeMB(imagePathToCompress) > 1.0 && getFileSizeMB(imagePathToCompress) < 1.50) {
    path = await FlutterNativeImage.compressImage(imagePathToCompress.absolute.path, quality: quality, percentage: 70);
  } else if (getFileSizeMB(imagePathToCompress) > 1.50) {
    path = await FlutterNativeImage.compressImage(imagePathToCompress.absolute.path, quality: quality, percentage: 55);
  } else {
    path = await FlutterNativeImage.compressImage(imagePathToCompress.absolute.path, quality: quality, percentage: 100);
  }

  debugPrint('After Compress: ${getFileSizeMB(path)}');
  return path;
}

double getFileSizeMB(File file) {
  int sizeInBytes = file.lengthSync();
  double sizeInMb = sizeInBytes / (1024 * 1024);
  return sizeInMb;
}
