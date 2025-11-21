class Profile {
  final int id;
  final String userName;

  Profile({required this.id, required this.userName});

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as int,
      userName: json['user_name'] as String,
    );
  }

  Map<String, dynamic> toJson() => {'id': id, 'user_name': userName};
}
