// lib/models/user_model.dart
class UserItem {
  final String id;
  final String nickname;
  final String avatar;
  final String? token;

  UserItem(
      {required this.id,
      required this.nickname,
      required this.avatar,
      required this.token});

  factory UserItem.fromJson(Map<String, dynamic> json) => UserItem(
        id: json['id'],
        nickname: json['nickname'],
        avatar: json['avatar'],
        token: json['token'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'nickname': nickname,
        'avatar': avatar,
        'token': token,
      };
}
