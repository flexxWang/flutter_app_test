import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import './widgets/stat_item.dart';
import 'package:flutter_application_test/widgets/image_preview_page.dart';
// 可选缓存
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_application_test/models/thread.dart';
import 'package:flutter_application_test/core/services/api_service.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  List<ThreadItem> threads = [];
  bool isLoading = false;
  bool hasMore = true;
  int page = 1;
  final int pageSize = 10;
  List<String> get _galleryUrls => threads.map(_firstImageUrl).toList();

  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadData();
    // 滚动监听，接近底部时加载更多
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent - 200 &&
          !isLoading &&
          hasMore) {
        _loadData();
      }
    });
  }

  Future<void> _loadData() async {
    if (isLoading) return;

    setState(() => isLoading = true);

    try {
      final result =
          await ApiService.fetchThread(page: page, pageSize: pageSize);
      print('加载数据成功: ${result.length}条');
      setState(() {
        if (result.length < pageSize) {
          hasMore = false;
        }
        threads.addAll(result);
        page++;
      });
    } catch (e) {
      print('加载数据失败: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  String _firstImageUrl(ThreadItem thread) {
    if (thread.attachments.isNotEmpty) {
      return thread.attachments.first.thumbUrl;
    }
    if (thread.extra.moreImages.isNotEmpty) {
      return thread.extra.moreImages.first.thumbUrl;
    }
    return 'https://c.zwoastro.cn/common_attachments/image/2025/08/12/8113f2364a7e40258e8f281f11a07ca5.jpg';
  }

  @override
  Widget build(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return DefaultTabController(
        length: 4,
        child: Scaffold(
            extendBodyBehindAppBar: true,
            body: MediaQuery.removePadding(
              context: context,
              removeTop: true,
              removeBottom: false,
              child: NestedScrollView(
                headerSliverBuilder: (context, innerBoxIsScrolled) {
                  return [
                    SliverAppBar(
                      expandedHeight: 320,
                      pinned: true,
                      backgroundColor: Colors.transparent, // 这里改为白色，防止透明导致视觉差
                      elevation: 0,
                      collapsedHeight: statusBarHeight + kToolbarHeight + 48,
                      forceElevated: innerBoxIsScrolled,
                      flexibleSpace: LayoutBuilder(
                        builder: (context, constraints) {
                          // 可根据收缩状态动态调整top位置（可选）
                          final topPadding = MediaQuery.of(context).padding.top;
                          return Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.network(
                                'https://c-test.zwoastro.com/common_attachments/image/2025/06/18/a1b38e28c34f42d9936908e053fb7d0d.png?imageMogr2/thumbnail/750x750&quot',
                                fit: BoxFit.cover,
                              ),
                              Container(color: Colors.black.withOpacity(0.4)),
                              Positioned(
                                top: topPadding + 38, // 状态栏高度 + 8px
                                left: 16,
                                right: 16,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 1,
                                            ),
                                          ),
                                          child: CircleAvatar(
                                            radius: 35,
                                            backgroundImage: NetworkImage(
                                              'https://c-test.zwoastro.com/common_attachments/image/2025/07/28/0db6e7ff8744422cb33af51d8cade053.png',
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: const [
                                              Text(
                                                '旋律小满爱星野',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              SizedBox(height: 4),
                                              Text(
                                                '向粉丝介绍自己吧，这里是天文爱好者的星野作品分享。',
                                                style: TextStyle(
                                                    color: Colors.white70),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: const [
                                        StatItem(
                                            label: '粉丝',
                                            value: '5210',
                                            color: Colors.white),
                                        SizedBox(width: 16),
                                        StatItem(
                                            label: '关注',
                                            value: '5210',
                                            color: Colors.white),
                                        SizedBox(width: 16),
                                        StatItem(
                                            label: '获赞与收藏',
                                            value: '5210',
                                            color: Colors.white),
                                      ],
                                    ),
                                    const SizedBox(height: 12),
                                    SizedBox(
                                      child: SingleChildScrollView(
                                        scrollDirection: Axis.horizontal,
                                        physics: const BouncingScrollPhysics(),
                                        child: Row(
                                          children: [
                                            _entryItem(
                                                Icons.camera_alt, '创作中心'),
                                            _entryItem(Icons.public, '星球'),
                                            _entryItem(Icons.settings, '设备'),
                                            _entryItem(
                                                Icons.remove_red_eye, '观测'),
                                            _entryItem(Icons.star, '天文秀场'),
                                            _entryItem(Icons.map, '天文地图'),
                                            _entryItem(Icons.group, '天文社群'),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      bottom: PreferredSize(
                        preferredSize: const Size.fromHeight(48),
                        child: Container(
                          color: Colors.white,
                          child: const TabBar(
                            indicatorColor: Colors.redAccent,
                            labelColor: Colors.redAccent,
                            unselectedLabelColor: Colors.grey,
                            tabs: [
                              Tab(text: '作品'),
                              Tab(text: '文章'),
                              Tab(text: '想法'),
                              Tab(text: '提问'),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ];
                },
                body: TabBarView(
                  children: [
                    _buildPostGrid(),
                    Center(child: Text('文章内容')),
                    Center(child: Text('想法内容')),
                    Center(child: Text('提问内容')),
                  ],
                ),
              ),
            )));
  }

  Widget _buildPostGrid() {
    return CustomScrollView(
      controller: _scrollController,
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(8),
          sliver: SliverMasonryGrid.count(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childCount: threads.length,
            itemBuilder: (context, index) {
              final thread = threads[index];
              final imageUrl = _firstImageUrl(thread);

              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => ImagePreviewPage(
                        images: _galleryUrls,
                        initialIndex: index,
                        ids: threads.map((t) => t.id).toList(),
                        heroTagPrefix: 'thread-hero-',
                      ),
                    ),
                  );
                },
                child: Hero(
                  tag: 'thread-hero-${thread.id}',
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Colors.grey[200], // 默认灰色背景
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // 图片容器
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: AspectRatio(
                            aspectRatio: 3 / 4, // 固定比例，高度随宽度变化
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                Container(color: Colors.grey[300]), // 灰色占位
                                Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  loadingBuilder: (context, child, progress) {
                                    if (progress == null) return child;
                                    return const SizedBox.shrink(); // 已经有灰色占位
                                  },
                                  errorBuilder: (context, error, stackTrace) =>
                                      const Icon(Icons.broken_image),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            thread.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 8),
                          child: Row(
                            children: [
                              CircleAvatar(
                                radius: 10,
                                backgroundImage:
                                    NetworkImage(thread.safeAvatar),
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
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        // 底部 Loading（中心居中）
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
    );
  }

  static Widget _entryItem(IconData icon, String label) {
    return Container(
      width: 103,
      margin: const EdgeInsets.symmetric(horizontal: 8),
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.white, fontSize: 12),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
}
