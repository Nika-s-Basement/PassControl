import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class LoginForm extends StatefulWidget {
  late final TabController? tabController;

  LoginForm({this.tabController});

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      final username = _usernameController.text;
      final password = _passwordController.text;
      print(username);
      print(password);
      // Здесь вызываем функцию входа
      await login(username, password, widget.tabController);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              controller: _usernameController,
              decoration: InputDecoration(labelText: 'Имя пользователя'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите имя пользователя';
                }
                return null;
              },
            ),
            TextFormField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Пароль'),
              obscureText: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Пожалуйста, введите пароль';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: ElevatedButton(
                onPressed: _login,
                child: Text('Вход'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


Future<void> login(String username, String password, TabController? tab) async {
  const storage = FlutterSecureStorage();
  final url = Uri.parse('http://localhost:3000/login');
  try {
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'username': username,
        'password': password,
      }),
    );
    print('$username $password');
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      // Предполагаем, что сервер возвращает токен сессии в теле ответа

      // Сохраняем токен сессии в хранилище
      await storage.write(key: 'username', value: username);

      try {
        final urlId = Uri.parse('http://localhost:3000/user/$username');
        final response = await http.get(
          urlId,
          headers: {'Content-Type': 'application/json'},
        );
        final List<dynamic> fetched = json.decode(response.body);
        print(response.body);
        await storage.write(key: 'id', value: fetched[0]['user_id'].toString());
      } catch(e) {
        print('Ошибка кэша: ${e.toString()}. Рекомендуется пройти валидацию ещё раз');
      }

      // Редирект на UserPage
      tab?.animateTo(1);
    } else {
      // Обработка ошибок входа
      print('Ошибка входа: ${response.body}');
    }
  } catch (e) {
    print(e.toString());
  }
}
