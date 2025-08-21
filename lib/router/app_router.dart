import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../pages/home/home_page.dart';
import '../pages/login/login_page.dart';
import '../pages/mine/mine_page.dart';
import '../pages/post/post_detail_page.dart';
import '../pages/post/post_publish_page.dart';
import '../pages/message/message_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/home',
    routes: [
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
            path: '/post/publish',
            name: 'post_publish',
            builder: (context, state) => const PostPublishPage(),
          ),
          GoRoute(
            path: '/post/detail/:id',
            name: 'post_detail',
            builder: (context, state) {
              final postId = state.pathParameters['id']!;
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
    '/message',
    '/mine',
  ];

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    if (location.startsWith('/message')) return 1;
    if (location.startsWith('/mine')) return 2;
    return 0; // 默认为首页
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: (index) {
          if (index == currentIndex) return;
          context.go(tabs[index]);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: '消息'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
        ],
      ),
    );
  }
}
