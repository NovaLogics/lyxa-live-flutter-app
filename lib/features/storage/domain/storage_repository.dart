import 'dart:typed_data';

abstract class StorageRepository {
  // Upload profile images on mobile platforms
   Future<String?> uploadProfileImageMobile(String path, String fileName);

  // Upload profile images on web platforms
     Future<String?> uploadProfileImageWeb(Uint8List fileBytes, String fileName);

}