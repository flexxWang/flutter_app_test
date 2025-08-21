import 'package:flutter/material.dart';
import 'package:flutter_application_test/models/banner_item.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_application_test/core/services/api_service.dart';
import 'package:flutter_application_test/models/post.dart';
import './wigdets/post_item.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Post> _posts = [];
  List<BannerItem> _banners = [];
  final RefreshController _refreshController = RefreshController();
  int _page = 1;
  final int _pageSize = 10;
  bool _hasMore = true;

  @override
  void initState() {
    super.initState();
    loadBanners();
    _loadPosts(isRefresh: true);
  }

  Future<void> loadBanners() async {
    try {
      final result = await ApiService.fetchBanners(position: 1);
      print('加载轮播图成功: $result');
      setState(() {
        _banners = result;
      });
    } catch (e) {
      print('加载轮播图失败: $e');
    }
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

  Widget _buildBanner() {
    if (_banners.isEmpty) {
      return const SizedBox(height: 0);
    }

    return AspectRatio(
      aspectRatio: 16 / 9,
      child: PageView.builder(
        itemCount: _banners.length,
        itemBuilder: (context, index) {
          final banner = _banners[index];
          return GestureDetector(
            onTap: () {
              // 可以跳转到广告详情页等
            },
            child: Image.network(
              banner.fileUrl,
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SmartRefresher(
      controller: _refreshController,
      enablePullUp: _hasMore,
      onRefresh: () => _loadPosts(isRefresh: true),
      onLoading: _loadPosts,
      child: ListView(
        children: [
          _buildBanner(),
          const SizedBox(height: 12),
          ..._posts.map((post) => PostItem(post: post)).toList(),
        ],
      ),
    );
  }
}
