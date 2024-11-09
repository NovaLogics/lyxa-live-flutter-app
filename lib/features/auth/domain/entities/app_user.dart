class AppUser {
  final String uid;
  final String email;
  final String name;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
  });

  //Convert AppUser -> json
  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
    };
  }

  //Convert json -> AppUser
  factory AppUser.fromJson(Map<String, dynamic> user) {
    return AppUser(
      uid: user['uid'],
      email: user['email'],
      name: user['name'],
    );
  }
}
