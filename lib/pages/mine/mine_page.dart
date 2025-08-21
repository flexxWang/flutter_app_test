import 'package:flutter/material.dart';
import './widgets/stat_item.dart';
import 'package:flutter_application_test/models/thread.dart';
import 'package:flutter_application_test/core/services/api_service.dart';

class MinePage extends StatefulWidget {
  const MinePage({super.key});

  @override
  State<MinePage> createState() => _MinePageState();
}

class _MinePageState extends State<MinePage> {
  List<ThreadItem> threads = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final result = await ApiService.fetchThread(page: 1, pageSize: 10);
      setState(() {
        threads = result;
      });
    } catch (e) {
      print('加载数据失败: $e');
    }
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
                    _buildPostGrid(threads),
                    Center(child: Text('文章内容')),
                    Center(child: Text('想法内容')),
                    Center(child: Text('提问内容')),
                  ],
                ),
              ),
            )));
  }

  Widget _buildPostGrid(List<ThreadItem> threads) {
    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 0.75,
      ),
      itemCount: threads.length,
      itemBuilder: (context, index) {
        final thread = threads[index];
        final imageUrl = thread.attachments.isNotEmpty
            ? thread.attachments.first.thumbUrl
            : (thread.extra.moreImages.isNotEmpty
                ? thread.extra.moreImages.first.thumbUrl
                : 'https://c.zwoastro.cn/common_attachments/image/2025/08/12/8113f2364a7e40258e8f281f11a07ca5.jpg');

        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Stack(
            children: [
              Image.network(
                imageUrl,
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,
              ),
            ],
          ),
        );
      },
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
}
