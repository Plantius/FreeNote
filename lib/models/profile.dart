class Profile {
  final int id;
  final String uid;
  final String username;
  final String email;

  Profile({
    required this.id,
    required this.uid,
    required this.username,
    required this.email,
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as int,
      uid: json['uid'] as String,
      username: json['user_name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'uid': uid,
    'user_name': username,
    'email': email,
  };

  @override
  String toString() {
    return 'Profile(#$id ~ $uid, "$username")';
  }
}
