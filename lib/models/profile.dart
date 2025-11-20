class Profile {
  final int id;

  Profile({
    required this.id
  });

  factory Profile.fromJson(Map<String, dynamic> json) {
    return Profile(
      id: json['id'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
  };
}
