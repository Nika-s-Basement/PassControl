import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:skupka_kradenogo/constraints/colors.dart';
import 'package:skupka_kradenogo/pages/create_page.dart';
import 'package:skupka_kradenogo/pages/user_page.dart';
import 'package:skupka_kradenogo/utils/globals.dart';

import 'package:skupka_kradenogo/pages/main_page.dart';
import 'package:skupka_kradenogo/pages/sign_page.dart';


class CustomPageController extends StatefulWidget {
  @override
  _CustomPageControllerState createState() => _CustomPageControllerState();
}

class _CustomPageControllerState extends State<CustomPageController>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _storage = const FlutterSecureStorage();
  String? _token;
  String? _userId;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(checkTokenAndUpdateTab);
  }

  void checkTokenAndUpdateTab() async {
    String? token = await _storage.read(key: 'username');
    String? id = await _storage.read(key: 'id');
    print(id);
    if (id != null) {
      fetchItems(flag: 'lots/user/$id');
    }
    setState(() {
      _token = token;
      _userId = id;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors?.primaryColor,
      appBar: AppBar(
        backgroundColor: appColors?.secondaryColor,
        shadowColor: Colors.transparent,
        title: Row(
          children: [
            const Icon(Icons.menu, color: Colors.black),
            Expanded(
              child: CustomTabBar(
                tabController: _tabController,
              ),
            ),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          Center(child: Text('Новости', style: TextStyle(color: appColors?.textColor),)),
          Center(child: CardsGrid(itemArray: items)),
          Center(child: AddLotPage()),
          Center(child: _token == null ? LoginPage(_tabController) : UserPage()),
        ],
      ),
    );
  }
}


class CustomTabBar extends StatefulWidget {
  final TabController tabController;

  const CustomTabBar({Key? key, required this.tabController}) : super(key: key);

  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar> {
  late double _indicatorPosition;
  late double _indicatorWidth;
  List<GlobalKey> _tabKeys = [];
  final List<String> _tabs = ['Обновления', 'Лоты', 'Создать', 'Вход'];
  final _storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _indicatorPosition = 0;
    _indicatorWidth = 0; // Инициализация с нулевой шириной
    _tabKeys = List.generate(_tabs.length, (index) => GlobalKey());

    // Установка начальной позиции индикатора
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.tabController.index < _tabs.length) {
        _updateIndicator(widget.tabController.index);
      }
    });

    checkTokenAndUpdateTab();
    widget.tabController.addListener(_setActiveTab);
  }


  void _updateIndicator(int index) {
    if (_tabKeys[index].currentContext != null) {
      final RenderBox renderBox = _tabKeys[index].currentContext!.findRenderObject() as RenderBox;
      final size = renderBox.size;
      final position = renderBox.localToGlobal(Offset.zero);

      setState(() {
        _indicatorPosition = position.dx;
        _indicatorWidth = size.width + 10; // Добавим отступы к ширине
      });
    }
  }


  void checkTokenAndUpdateTab() async {
    String? token = await _storage.read(key: 'username');
    setState(() {
      if (token != null) {
        _tabs[3] = token; // Обновляем, если токен есть
      } else {
        _tabs[3] = 'Вход'; // Обновляем, если токена нет
      }
    });
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_setActiveTab);
    super.dispose();
  }

  void _setActiveTab() {
    if (widget.tabController.indexIsChanging && widget.tabController.index < _tabs.length) {
      _updateIndicator(widget.tabController.index);
    }
    setState(() {
      _indicatorPosition = widget.tabController.index.toDouble();
      checkTokenAndUpdateTab();
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    var tabWidth = ((screenWidth - 100) / _tabs.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          children: [
            Positioned(
              left: _indicatorPosition,
              child: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
                width: _indicatorWidth,
                height: 40, // Высота вкладки
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.grey.shade300,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text(
                    _tabs[widget.tabController.index],
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List<Widget>.generate(_tabs.length, (index) {
                return GestureDetector(
                  onTap: () {
                    widget.tabController.animateTo(index);
                    setState(() {
                      _indicatorPosition = index.toDouble();
                    });
                  },
                  child: Container(
                    height: 40,
                    width: tabWidth,
                    alignment: Alignment.center,
                    child: Text(
                      _tabs[index],
                      style: TextStyle(
                        color: widget.tabController.index == index ? Colors
                            .black : appColors?.textColor,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ),
      ],
    );
  }
}