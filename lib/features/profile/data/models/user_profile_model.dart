class UserProfileModel {
  final String userId;
  final String name;
  final String email;
  final String? photoUrl;

  const UserProfileModel({
    required this.userId,
    required this.name,
    required this.email,
    this.photoUrl,
  });

  factory UserProfileModel.fromMap(Map<String, dynamic> map, String id) {
    return UserProfileModel(
      userId: id,
      name: map['name'] ?? 'User',
      email: map['email'] ?? '',
      photoUrl: map['photoUrl'],
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'email': email,
    'photoUrl': photoUrl,
  };
}