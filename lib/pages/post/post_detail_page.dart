import 'package:flutter/material.dart';

class PostDetailPage extends StatelessWidget {
  final String postId;
  const PostDetailPage({super.key, required this.postId});
  @override
  Widget build(BuildContext context) => Center(child: Text('动态详情：$postId'));
}
