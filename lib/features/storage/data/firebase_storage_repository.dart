import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:lyxa_live/features/storage/domain/storage_repository.dart';

class FirebaseStorageRepository implements StorageRepository {
  final FirebaseStorage storage = FirebaseStorage.instance;
  @override
  Future<String?> uploadProfileImageMobile(String path, String fileName) {
    // TODO: implement uploadProfileImageMobile
    throw UnimplementedError();
  }

  @override
  Future<String?> uploadProfileImageWeb(String fileBytes, String fileName) {
    // TODO: implement uploadProfileImageWeb
    throw UnimplementedError();
  }

  // Helper methods : to upload files to storage

  // Mobile platforms (file)
  Future<String?> _uploadFile(
      String path, String fileName, String folder) async {
    try {
      // Get file
      final file = File(path);

      // Find place to store
      final storageRef = storage.ref().child('$folder/$fileName');

      // Upload
      final uploadTask = await storageRef.putFile(file);

      // Get image download url
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (error) {
      return null;
    }
  }

  // Web platforms (file)
  Future<String?> _uploadFileBytes(
      Uint8List fileBytes, String fileName, String folder) async {
    try {

      // Find place to store
      final storageRef = storage.ref().child('$folder/$fileName');

      // Upload
      final uploadTask = await storageRef.putData(fileBytes);

      // Get image download url
      final downloadUrl = await uploadTask.ref.getDownloadURL();

      return downloadUrl;
    } catch (error) {
      return null;
    }
  }
}
