import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  final double logoWidth = 150.0;
  final double menuWidth = (4 + 11 + 19 + 23 + 10 + 10 + 10) * 5; // Примерно рассчитываем ширину меню

  @override
  Widget build(BuildContext context) {
    double totalWidth = MediaQuery.of(context).size.width;
    var titles = ['Лоты', 'Новости', 'Контакты', 'Вход'];
    var sum = 0;
    var lenghts = [];
    for (String element in titles) {sum += element.length; lenghts.add(sum + 10);}
    print(lenghts);
    lenghts = [0, 4, 7, 8];

    return Scaffold(
      appBar: AppBar(
        title: SizedBox(
          width: totalWidth,
          height: 56,
          child: Stack(
            children: [
              for (int i = 0; i < 4; i++)
                AnimatedPositioned(
                  duration: Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                  left: isExpanded ? totalWidth / 2 - menuWidth / 2 + lenghts[i] * 30 : totalWidth / 2 - logoWidth / 2,
                  child: _buildMenuButton(titles[i]),
                ),
              AnimatedPositioned(
                duration: Duration(milliseconds: 500),
                curve: Curves.easeInOut,
                left: isExpanded ? totalWidth / 2 - menuWidth / 2 - logoWidth : totalWidth / 2 - logoWidth / 2 - 50,
                child: InkWell(
                  onTap: () {
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                  },
                  child: Container(
                    width: logoWidth,
                    height: 56,
                    color: Colors.white,
                    child: Image.asset('web/icons/icon-192.png', width: 50,), // Замените на ваш логотип
                    alignment: Alignment.centerRight,
                  ),
                ),
              ),
            ],
          ),
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
    return TextButton(
      onPressed: () {
        // Добавьте сюда вашу логику перехода
        print('$title pressed');
      },
      child: Text(
        title,
        style: GoogleFonts.montserrat(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black,
        ),
      ),
      style: TextButton.styleFrom(
        backgroundColor: Colors.transparent,
        padding: EdgeInsets.zero,
      ),
    );
  }
}
