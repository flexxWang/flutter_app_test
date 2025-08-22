import 'package:flutter_application_test/models/banner_item.dart';
import 'package:flutter_application_test/models/post.dart';
import 'package:flutter_application_test/models/thread.dart';
import 'dio_client.dart';

class ApiService {
  static Future<List<Post>> fetchPosts(
      {int page = 1, int pageSize = 10}) async {
    final res = await DioClient().get('/v1/threads', params: {
      'sort': 'new',
      'current': page,
      'pageSize': pageSize,
    });

    final List list = res.data['data']['items'] ?? [];
    return list.map((e) => Post.fromJson(e)).toList();
  }

  static Future<Post> fetchPostsDetail(int threadId) async {
    final res = await DioClient().get('/v1/threads/$threadId');
    final data = res.data['data'];
    return Post.fromJson(data);
  }

  static Future<List<BannerItem>> fetchBanners({int position = 1}) async {
    final res = await DioClient.bannerApi().get(
        '/opercenter/v1/advert-app/on-list',
        params: {'position': position, 'product': 'astronet'});
    final list = res.data['data']['list'] as List;
    print('banner: $list');
    return list.map((e) => BannerItem.fromJson(e)).toList();
  }

  static Future<List<ThreadItem>> fetchThread(
      {int page = 1, int pageSize = 10}) async {
    final res = await DioClient().get('/v1/creation/latest', params: {
      'showTopics': true,
      'showStaredUsers': true,
      'isSeestar': false,
      'isAsiair': false,
      'excludeSeestar': false,
      'excludeAsiair': false,
      'current': page,
      'pageSize': pageSize,
    });

    final List list = res.data['data']['items'] ?? [];
    return list.map((e) => ThreadItem.fromJson(e)).toList();
  }
}
