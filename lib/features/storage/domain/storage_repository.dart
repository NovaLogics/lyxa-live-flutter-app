abstract class StorageRepository {
  // Upload profile images on mobile platforms
   Future<String?> uploadProfileImageMobile(String path, String fileName);

  // Upload profile images on web platforms
     Future<String?> uploadProfileImageWeb(String fileBytes, String fileName);

}