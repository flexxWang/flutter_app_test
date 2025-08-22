import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_application_test/core/services/api_service.dart';
import 'package:flutter_application_test/models/post.dart';
import './wigdets/post_item.dart';

class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  final List<Post> _posts = [];
  final RefreshController _refreshController = RefreshController();
  int _page = 1;
  final int _pageSize = 20;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    _loadPosts(isRefresh: true);
  }

  Future<void> _loadPosts({bool isRefresh = false}) async {
    if (isRefresh) {
      _page = 1;
      _hasMore = true;
    }

    if (!_hasMore) return;

    final result =
        await ApiService.fetchPosts(page: _page, pageSize: _pageSize);
    setState(() {
      if (isRefresh) {
        _posts.clear();
      }
      _posts.addAll(result);
      _hasMore = result.length == _pageSize;
      if (_hasMore) _page++;
    });

    if (isRefresh) {
      _refreshController.refreshCompleted();
    } else {
      _refreshController.loadComplete();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SmartRefresher(
        controller: _refreshController,
        enablePullUp: _hasMore,
        onRefresh: () => _loadPosts(isRefresh: true),
        onLoading: _loadPosts,
        child: ListView(
          children: [
            ..._posts.map((post) => PostItem(post: post)).toList(),
          ],
        ),
      ),
    );
  }
}
