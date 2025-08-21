class DiscussCategoryItem {
  final int id;
  final String name;

  DiscussCategoryItem({
    required this.id,
    required this.name,
  });

  factory DiscussCategoryItem.fromJson(Map<String, dynamic> json) {
    return DiscussCategoryItem(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }
}
