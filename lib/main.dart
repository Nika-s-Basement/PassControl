import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            AnimatedAlign(
              alignment: isExpanded ? Alignment.centerLeft : Alignment.center,
              duration: Duration(seconds: 1),
              curve: Curves.easeInOut,
              child: InkWell(
                onTap: () {
                  setState(() {
                    isExpanded = !isExpanded;
                  });
                },
                child: Image.asset('path/to/your/logo.png', width: 50), // Замените на свой логотип
              ),
            ),
            if (isExpanded) ...[
              Spacer(),
              _buildMenuButton('Лоты'),
              _buildMenuButton('Новости'),
              _buildMenuButton('Контакты'),
              _buildMenuButton('Вход'),
            ],
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Center(
        child: Text('Главная страница'),
      ),
    );
  }

  Widget _buildMenuButton(String title) {
    return ElevatedButton(
      onPressed: () {
        // Добавьте сюда вашу логику перехода
        print('$title pressed');
      },
      child: Text(title),
    );
  }
}
