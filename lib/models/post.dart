import 'user.dart'; // 你应该有 UserItem 模型
import 'attachment.dart';
import 'group.dart';

class Post {
  final int id;
  final String title;
  final String threadType;
  final String description;
  final String summary;
  final UserItem author;
  final int favoriteCount;
  final int starCount;
  final int commentCount;
  final bool myFavorite;
  final bool myStar;
  final int discussCount;
  final List<AttachmentItem> attachments;
  final int approveStatus;
  final int createTime;
  final int userUpdateTime;
  final GroupItem? group;
  final String createdAt;

  Post({
    required this.id,
    required this.title,
    required this.threadType,
    required this.description,
    required this.summary,
    required this.author,
    required this.favoriteCount,
    required this.starCount,
    required this.commentCount,
    required this.myFavorite,
    required this.myStar,
    required this.discussCount,
    required this.attachments,
    required this.approveStatus,
    required this.createTime,
    required this.userUpdateTime,
    required this.group,
    required this.createdAt,
  });

  // 安全头像 Getter
  String get safeAvatar {
    if (author.avatar.isNotEmpty) {
      return author.avatar;
    }
    return 'https://i.cmoscool.com/mp-astroimg/avatar.png';
  }

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      title: json['title'] ?? '',
      threadType: json['threadType'] ?? '',
      description: json['description'] ?? '',
      summary: json['summary'] ?? '',
      author: UserItem.fromJson(json['author']),
      favoriteCount: json['favoriteCount'] ?? 0,
      starCount: json['starCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      myFavorite: json['myFavorite'] ?? false,
      myStar: json['myStar'] ?? false,
      discussCount: json['discussCount'] ?? 0,
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => AttachmentItem.fromJson(e))
              .toList() ??
          [],
      approveStatus: json['approveStatus'] ?? 0,
      createTime: json['createTime'] ?? 0,
      userUpdateTime: json['userUpdateTime'] ?? 0,
      group: json['group'] != null ? GroupItem.fromJson(json['group']) : null,
      createdAt: json['createdAt'] ?? '',
    );
  }
}
