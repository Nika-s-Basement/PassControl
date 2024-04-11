import 'package:flutter/material.dart';

import '../templates/login.dart';
import '../templates/register.dart';

class LoginPage extends StatefulWidget {
  late final TabController? tabController;

  LoginPage(this.tabController);
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Логин'),
            Tab(text: 'Регистрация'),
          ],
        ),
        title: const Text('Вход / Регистрация'),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          LoginForm(tabController: widget.tabController,), // Форма входа
          RegisterForm(), // Форма регистрации
        ],
      ),
    );
  }
}
