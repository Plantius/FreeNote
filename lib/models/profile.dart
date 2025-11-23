class Profile {
  final int id;
  final String userName;
  final String email;

  Profile({required this.id, required this.userName, required this.email});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as int,
      userName: json['user_name'] as String,
      email: json['email'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'user_name': userName,
    'email': email,
  };
}
