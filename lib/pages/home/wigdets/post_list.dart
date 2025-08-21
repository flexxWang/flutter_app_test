import 'package:flutter/material.dart';
import 'post_item.dart';
import 'post_skeleton.dart';

class PostList extends StatefulWidget {
  const PostList({super.key});

  @override
  State<PostList> createState() => _PostListState();
}

class _PostListState extends State<PostList> {
  bool _loading = true;
  List<String> posts = [];

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        posts = List.generate(10, (index) => {
          return {
            title: '动态内容 #$index',
          }
        });
        _loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const PostSkeleton();
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: posts.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return PostItem(post: posts[index]);
      },
    );
  }
}
