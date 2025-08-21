// lib/features/auth/login_page.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/user.dart';
import '../../providers/user_provider.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  LoginPage({super.key});

  void _login(BuildContext context) async {
    final name = _nameController.text.trim();
    if (name.isEmpty) return;

    // 模拟接口返回
    final user = UserItem(
        id: '123', nickname: name, avatar: '', token: 'fake_token_abc');
    await context.read<UserProvider>().setUser(user);

    if (context.mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('登录')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: '用户名')),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _login(context),
              child: const Text('登录'),
            )
          ],
        ),
      ),
    );
  }
}
