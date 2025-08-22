import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_application_test/models/post.dart';
import 'package:flutter_application_test/core/services/api_service.dart';
import 'package:flutter_html/flutter_html.dart';

class PostDetailPage extends StatefulWidget {
  final int postId;

  const PostDetailPage({super.key, required this.postId});

  @override
  State<PostDetailPage> createState() => _PostDetailPageState();
}

class _PostDetailPageState extends State<PostDetailPage> {
  Post? postDetail;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPostsDetail();
  }

  Future<void> _loadPostsDetail() async {
    try {
      final result = await ApiService.fetchPostsDetail(widget.postId);
      setState(() {
        postDetail = result;
        isLoading = false;
      });
    } catch (e) {
      print('加载帖子详情失败: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('帖子详情'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            // go_router 的返回
            context.pop();
            // 或者用 Navigator.pop(context) 也可以
          },
        ),
      ),
      body: isLoading
          ? Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            )
          : postDetail == null
              ? const Center(child: Text('帖子不存在'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                              backgroundImage:
                                  NetworkImage(postDetail!.safeAvatar)),
                          const SizedBox(width: 8),
                          Text(postDetail!.author.nickname),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(postDetail!.title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Html(data: postDetail!.description),
                    ],
                  ),
                ),
    );
  }
}
