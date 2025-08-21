class GroupItem {
  final int id;
  final String name;

  GroupItem({
    required this.id,
    required this.name,
  });

  factory GroupItem.fromJson(Map<String, dynamic> json) {
    return GroupItem(
      id: json['id'],
      name: json['name'] ?? '',
    );
  }
}
