import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/home/splash_page.dart';
import '../pages/home/home_page.dart';
import '../pages/post/post_page.dart';
import '../pages/login/login_page.dart';
import '../pages/mine/mine_page.dart';
import '../pages/post/post_detail_page.dart';
import '../pages/post/post_publish_page.dart';
import '../pages/message/message_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/splash',
    routes: [
      GoRoute(
        path: '/splash',
        name: 'splash',
        builder: (context, state) => const SplashPage(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => LoginPage(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return _MainScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/post',
            name: 'post',
            builder: (context, state) => const PostPage(),
          ),
          GoRoute(
            path: '/post/publish',
            name: 'post_publish',
            builder: (context, state) => const PostPublishPage(),
          ),
          GoRoute(
            path: '/post/detail/:id',
            name: 'post_detail',
            builder: (context, state) {
              final postId = int.tryParse(state.pathParameters['id']!) ?? 0;
              return PostDetailPage(postId: postId);
            },
          ),
          GoRoute(
            path: '/message',
            name: 'message',
            builder: (context, state) => const MessagePage(),
          ),
          GoRoute(
            path: '/mine',
            name: 'mine',
            builder: (context, state) => const MinePage(),
          ),
        ],
      ),
    ],
  );
}

// 底部 Tab 用的 Scaffold
class _MainScaffold extends StatefulWidget {
  final Widget child;

  const _MainScaffold({super.key, required this.child});

  @override
  State<_MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<_MainScaffold> {
  final tabs = [
    '/home',
    '/post',
    '/message',
    '/mine',
  ];

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith('/post')) return 1;
    if (location.startsWith('/message')) return 2;
    if (location.startsWith('/mine')) return 3;
    return 0; // 默认为首页
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: const Color.fromARGB(255, 243, 33, 33), // 选中颜色
        unselectedItemColor: Colors.grey, // 未选中颜色
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          if (index == currentIndex) return;
          context.go(tabs[index]);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.public), label: '广场'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: '消息'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ],
      ),
    );
  }
}
