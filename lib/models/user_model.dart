
class UserModel {
  final String name;
  final String profilePic;
  final String phoneNumber;
  final String uid;
  final bool isOnline;
  final List<String> groupId;
  UserModel({
    required this.name,
    required this.profilePic,
    required this.phoneNumber,
    required this.uid,
    required this.isOnline,
    required this.groupId,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profilePic': profilePic,
      'phoneNumber': phoneNumber,
      'uid': uid,
      'isOnline': isOnline,
      'groupId': groupId,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      profilePic: map['profilePic'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      uid: map['uid'] ?? '',
      isOnline: map['isOnline'] ?? false,
      groupId: List<String>.from(map['groupId']),
    );
  }

}
