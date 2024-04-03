import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: InkWell(
          onTap: () {
            setState(() {
              _isExpanded = !_isExpanded;
            });
          },
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              // Логотип
              Container(
                child: Image.asset('web/icons/icon-192.png', width: 50)
              ),
              // Кнопки, которые появляются
              AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                left: _isExpanded ? 0 : MediaQuery.of(context).size.width / 2 - 50, // Начальное и конечное положение кнопок
                right: _isExpanded ? 0 : MediaQuery.of(context).size.width / 2 - 50,
                top: _isExpanded ? 60 : 0, // Высота появления кнопок
                child: Opacity(
                  opacity: _isExpanded ? 1 : 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      _buildButton('Лоты'),
                      _buildButton('Новости'),
                      _buildButton('Контакты'),
                      _buildButton('Вход'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Text('Главный экран'),
      ),
    );
  }

  Widget _buildButton(String title) {
    return ElevatedButton(
      onPressed: () {
        // Ваша логика навигации здесь
        print('$title pressed');
      },
      child: Text(title),
    );
  }
}

