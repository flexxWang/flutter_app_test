class BannerItem {
  final int id;
  final String fileUrl;

  BannerItem({
    required this.id,
    required this.fileUrl,
  });

  factory BannerItem.fromJson(Map<String, dynamic> json) {
    return BannerItem(
      id: json['id'],
      fileUrl: json['fileUrl'],
    );
  }
}
