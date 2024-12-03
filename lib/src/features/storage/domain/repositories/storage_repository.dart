import 'dart:typed_data';

import 'package:lyxa_live/src/shared/entities/result/result.dart';

abstract class StorageRepository {
  Future<Result<String>> uploadProfileImage({
    required Uint8List? imageFileBytes,
    required String fileName,
  });

  Future<Result<String>> uploadPostImage({
    required Uint8List? imageFileBytes,
    required String fileName,
  });

  Future<Result<void>> deleteImageByUrl({
    required String downloadUrl,
  });

  //•▼ LEGACY CODE ▼•

  // Upload profile images on mobile platforms
  Future<String?> uploadProfileImageMobile(String path, String fileName);

  // Upload profile images on web platforms
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName);

  // Upload post images on mobile platforms
  Future<String?> uploadPostImageMobile(String path, String fileName);

  // Upload post images on web platforms
  Future<String?> uploadPostImageWeb(Uint8List fileBytes, String fileName);
}
