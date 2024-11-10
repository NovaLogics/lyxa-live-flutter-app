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
}
