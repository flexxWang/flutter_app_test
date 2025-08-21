class AstroTag {
  final double radius;
  final String name;

  AstroTag({required this.radius, required this.name});

  factory AstroTag.fromJson(Map<String, dynamic> json) {
    return AstroTag(
      radius: (json['radius'] ?? 0).toDouble(),
      name: json['name'] ?? '',
    );
  }
}

class AttachmentItem {
  final List<AstroTag> astroTags;
  final int id;
  final int width;
  final int height;
  final String thumbUrl;
  final int size;
  final bool isApproved;
  final String url;
  final String detailUrl;
  final int type;
  final String videoUrl;
  final String highQualityUrl;

  AttachmentItem({
    required this.astroTags,
    required this.id,
    required this.width,
    required this.height,
    required this.thumbUrl,
    required this.size,
    required this.isApproved,
    required this.url,
    required this.detailUrl,
    required this.type,
    required this.videoUrl,
    required this.highQualityUrl,
  });

  factory AttachmentItem.fromJson(Map<String, dynamic> json) {
    return AttachmentItem(
      astroTags: (json['astroTags'] as List<dynamic>?)
              ?.map((e) => AstroTag.fromJson(e))
              .toList() ??
          [],
      id: json['id'] ?? '',
      width: json['width'] ?? 0,
      height: json['height'] ?? 0,
      thumbUrl: json['thumbUrl'] ?? '',
      size: json['size'] ?? 0,
      isApproved: json['isApproved'] ?? false,
      url: json['url'] ?? '',
      detailUrl: json['detailUrl'] ?? '',
      type: json['type'] ?? 0,
      videoUrl: json['videoUrl'] ?? '',
      highQualityUrl: json['highQualityUrl'] ?? '',
    );
  }
}
