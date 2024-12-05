import 'package:lyxa_live/src/features/profile/data/models/profile_user_model.dart';
import 'package:lyxa_live/src/features/profile/domain/entities/profile_user_entity.dart';

class ProfileService {
  ProfileUserModel _profile;

  ProfileService(this._profile);

  ProfileUserModel get profile => _profile;

  ProfileUserEntity get profileEntity => _profile.toEntity();

  String getUserId() {
    return _profile.uid;
  }

  void updateProfile({
    String? newBio,
    String? newProfileImageUrl,
    List<String>? newFollowers,
    List<String>? newFollowing,
  }) {
    _profile = _profile.copyWith(
      newBio: newBio,
      newProfileImageUrl: newProfileImageUrl,
      newFollowers: newFollowers,
      newFollowing: newFollowing,
    );
  }

  void assignEntity(ProfileUserEntity entity) {
    _profile = ProfileUserModel.fromEntity(entity);
  }
}
