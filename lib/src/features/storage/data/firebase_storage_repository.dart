import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:lyxa_live/src/core/constants/constants.dart';
import 'package:lyxa_live/src/features/storage/domain/storage_repository.dart';
import 'package:lyxa_live/src/shared/entities/result/errors/firebase_error.dart';
import 'package:lyxa_live/src/shared/entities/result/errors/generic_error.dart';
import 'package:lyxa_live/src/shared/entities/result/result.dart';
import 'package:lyxa_live/src/shared/handlers/errors/utils/error_messages.dart';

class FirebaseStorageRepository implements StorageRepository {
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  @override
  Future<Result<String>> uploadPostImage({
    required Uint8List? imageFileBytes,
    required String fileName,
  }) async {
    if (imageFileBytes == null) Result.error(ErrorMsgs.imageFileEmpty);
    try {
      final downloadUrl = await _uploadFileBytes(
        fileBytes: imageFileBytes!,
        fileName: fileName,
        folder: STORAGE_PATH_POST_IMAGES,
      );

      return Result.success(
        data: downloadUrl,
      );
    } on FirebaseException catch (error) {
      return Result.error(FirebaseError(error));
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }

  @override
  Future<Result<String>> uploadProfileImage({
    required Uint8List? imageFileBytes,
    required String fileName,
  }) async {
    if (imageFileBytes == null) Result.error(ErrorMsgs.imageFileEmpty);
    try {
      final downloadUrl = await _uploadFileBytes(
        fileBytes: imageFileBytes!,
        fileName: fileName,
        folder: STORAGE_PATH_PROFILE_IMAGES,
      );

      return Result.success(
        data: downloadUrl,
      );
    } on FirebaseException catch (error) {
      return Result.error(FirebaseError(error));
    } catch (error) {
      return Result.error(GenericError(error: error));
    }
  }

  // Profile Pictures
  //-> upload profile pictures to storage
  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, STORAGE_PATH_PROFILE_IMAGES);
  }

  @override
  Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(
      fileBytes: fileBytes,
      fileName: fileName,
      folder: STORAGE_PATH_PROFILE_IMAGES,
    );
  }

  // Post Pictures
  //-> upload post pictures to storage
  @override
  Future<String?> uploadPostImageMobile(String path, String fileName) {
    return _uploadFile(path, fileName, STORAGE_PATH_POST_IMAGES);
  }

  @override
  Future<String?> uploadPostImageWeb(Uint8List fileBytes, String fileName) {
    return _uploadFileBytes(
      fileBytes: fileBytes,
      fileName: fileName,
      folder: STORAGE_PATH_POST_IMAGES,
    );
  }

  // Helper Methods
  //-> to upload files to storage

  // Mobile platforms (file)
  Future<String?> _uploadFile(
      String path, String fileName, String folder) async {
    try {
      // Get file
      final file = File(path);

      // Find place to store
      final storageRef = _firebaseStorage.ref().child('$folder/$fileName');

      // Upload
      final uploadTask = await storageRef.putFile(file);

      // Get image download url
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (error) {
      return null;
    }
  }

  // Upload using Image File Bytes | Best use : Web platforms
  Future<String> _uploadFileBytes({
    required Uint8List fileBytes,
    required String fileName,
    required String folder,
  }) async {
    try {
      final uploadFilePath = '$folder/$fileName';

      final storageRef = _firebaseStorage.ref().child(uploadFilePath);

      final uploadTask = await storageRef.putData(fileBytes);

      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (error) {
      throw Exception('Failed to upload file: ${error.toString()}');
    }
  }
}
