class AppUserEntity {
  final String uid;
  final String email;
  final String name;
  final String searchableName;

  AppUserEntity({
    required this.uid,
    required this.email,
    required this.name,
    required this.searchableName,
  });

  @override
  String toString() => {
        'uid': uid,
        'email': email,
        'name': name,
        'searchableName': searchableName,
      }.toString();
}
