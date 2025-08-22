import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_application_test/core/services/api_service.dart';
import 'package:flutter_application_test/models/banner_item.dart';
import 'package:flutter_application_test/models/thread.dart';
import 'package:flutter_application_test/widgets/image_preview_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<BannerItem> _banners = [];
  List<ThreadItem> threads = [];
  int page = 1;
  bool hasMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    loadBanners();
    _loadData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 100 &&
          hasMore) {
        _loadData();
      }
    });
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

  Future<void> _loadData() async {
    final result = await ApiService.fetchThread(page: page, pageSize: 10);
    print('加载作品数据: $result');
    setState(() {
      threads.addAll(result);
      page++;
      hasMore = result.length == 10;
    });
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

  List<String> get _galleryUrls => threads
      .map((e) => e.attachments.isNotEmpty
          ? e.attachments.first.thumbUrl
          : (e.extra.moreImages.isNotEmpty
              ? e.extra.moreImages.first.thumbUrl
              : ''))
      .toList();

  String _firstImageUrl(ThreadItem thread) {
    return thread.attachments.isNotEmpty
        ? thread.attachments.first.thumbUrl
        : (thread.extra.moreImages.isNotEmpty
            ? thread.extra.moreImages.first.thumbUrl
            : 'https://c.zwoastro.cn/common_attachments/image/2025/08/12/8113f2364a7e40258e8f281f11a07ca5.jpg');
  }

  Widget _buildPostGrid() {
    return SliverPadding(
      padding: const EdgeInsets.all(8),
      sliver: SliverMasonryGrid.count(
        crossAxisCount: 1,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childCount: threads.length,
        itemBuilder: (context, index) {
          final thread = threads[index];
          final imageUrl = _firstImageUrl(thread);

          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                builder: (_) => ImagePreviewPage(
                  images: _galleryUrls,
                  initialIndex: index,
                  ids: threads.map((t) => t.id).toList(),
                  heroTagPrefix: 'thread-hero-',
                ),
              ));
            },
            child: Hero(
              // 使用 ValueKey 保证唯一性，避免 GlobalKey 冲突
              key: ValueKey('thread-hero-${thread.id}'),
              tag: 'thread-hero-${thread.id}',
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[200],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 图片
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: AspectRatio(
                        aspectRatio: 3 / 4,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Container(color: Colors.grey[300]),
                            Image.network(
                              imageUrl,
                              fit: BoxFit.cover,
                              loadingBuilder: (context, child, progress) {
                                if (progress == null) return child;
                                return const SizedBox.shrink();
                              },
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(Icons.broken_image),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // 标题
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        thread.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    const SizedBox(height: 4),
                    // 用户信息
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 10,
                            backgroundImage: NetworkImage(thread.safeAvatar),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              thread.author.nickname.isNotEmpty
                                  ? thread.author.nickname
                                  : '匿名用户',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.grey,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        controller: _scrollController,
        slivers: [
          // banner
          SliverToBoxAdapter(child: _buildBanner()),
          const SliverPadding(padding: EdgeInsets.only(top: 8)),
          // 帖子列表
          _buildPostGrid(),
          // 底部 loading
          if (hasMore || page == 1)
            const SliverToBoxAdapter(
              child: Padding(
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
              ),
            ),
        ],
      ),
    );
  }
}
