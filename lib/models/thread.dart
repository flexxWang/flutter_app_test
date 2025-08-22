import 'attachment.dart';
import 'user.dart';

class ThreadItem {
  final bool myStar;
  final int starCount;
  final bool myFavorite;
  final int approveStatus;
  final int favoriteCount;
  final int commentCount;
  final int id;
  final int updateTime;
  final int createTime;
  final String description;
  final int viewCount;
  final String location;
  final double? longitude;
  final double? latitude;
  final bool isFeatured;
  final int userUpdateTime;
  final String title;
  final Category category;
  final int seekSpotId;
  final List<dynamic>? topic;
  final List<dynamic> userDevices;
  final List<dynamic>? moreInfoPhotos;
  final String moreInfo;
  final Extra extra;
  final DescriptionExtra descriptionExtra;
  final List<dynamic>? staredUsers;
  final UserItem author;
  final List<AttachmentItem> attachments;

  ThreadItem({
    required this.myStar,
    required this.starCount,
    required this.myFavorite,
    required this.approveStatus,
    required this.favoriteCount,
    required this.commentCount,
    required this.id,
    required this.updateTime,
    required this.createTime,
    required this.description,
    required this.viewCount,
    required this.location,
    this.longitude,
    this.latitude,
    required this.isFeatured,
    required this.userUpdateTime,
    required this.title,
    required this.category,
    required this.seekSpotId,
    required this.topic,
    required this.userDevices,
    this.moreInfoPhotos,
    required this.moreInfo,
    required this.extra,
    required this.descriptionExtra,
    this.staredUsers,
    required this.author,
    required this.attachments,
  });

  // 安全头像 Getter
  String get safeAvatar {
    if (author.avatar.isNotEmpty) {
      return author.avatar;
    }
    return 'https://i.cmoscool.com/mp-astroimg/avatar.png';
  }

  factory ThreadItem.fromJson(Map<String, dynamic> json) {
    return ThreadItem(
      myStar: json['myStar'] ?? false,
      starCount: json['starCount'] ?? 0,
      myFavorite: json['myFavorite'] ?? false,
      approveStatus: json['approveStatus'] ?? 0,
      favoriteCount: json['favoriteCount'] ?? 0,
      commentCount: json['commentCount'] ?? 0,
      id: json['id'] ?? 0,
      updateTime: json['updateTime'] ?? 0,
      createTime: json['createTime'] ?? 0,
      description: json['description'] ?? '',
      viewCount: json['viewCount'] ?? 0,
      location: json['location'] ?? '',
      longitude:
          (json['longitude'] != null) ? json['longitude'].toDouble() : null,
      latitude: (json['latitude'] != null) ? json['latitude'].toDouble() : null,
      isFeatured: json['isFeatured'] ?? false,
      userUpdateTime: json['userUpdateTime'] ?? 0,
      title: json['title'] ?? '',
      category:
          Category.fromJson(json['category'] ?? const <String, dynamic>{}),
      seekSpotId: json['seekSpotId'] ?? 0,
      topic: json['topic'],
      userDevices: json['userDevices'] ?? [],
      moreInfoPhotos: json['moreInfoPhotos'],
      moreInfo: json['moreInfo'] ?? '',
      extra: Extra.fromJson(json['extra']),
      descriptionExtra: DescriptionExtra.fromJson(json['descriptionExtra']),
      staredUsers: json['staredUsers'],
      author: UserItem.fromJson(json['author']),
      attachments: (json['attachments'] as List<dynamic>?)
              ?.map((e) => AttachmentItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class Category {
  final String image;
  final String name;
  final String nameEn;
  final int id;

  Category({
    required this.image,
    required this.name,
    required this.nameEn,
    required this.id,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      image: json['image'] ?? '',
      name: json['name'] ?? '',
      nameEn: json['name_en'] ?? '',
      id: json['id'] ?? 0,
    );
  }
}

class Extra {
  final List<dynamic>? userMention;
  final List<dynamic>? topics;
  final List<AttachmentItem> moreImages;

  Extra({
    this.userMention,
    this.topics,
    required this.moreImages,
  });

  factory Extra.fromJson(Map<String, dynamic> json) {
    return Extra(
      userMention: json['userMention'],
      topics: json['topics'],
      moreImages: (json['moreImages'] as List<dynamic>?)
              ?.map((e) => AttachmentItem.fromJson(e))
              .toList() ??
          [],
    );
  }
}

class DescriptionExtra {
  final List<dynamic>? userMention;
  final List<dynamic>? topics;

  DescriptionExtra({
    this.userMention,
    this.topics,
  });

  factory DescriptionExtra.fromJson(Map<String, dynamic> json) {
    return DescriptionExtra(
      userMention: json['userMention'],
      topics: json['topics'],
    );
  }
}
