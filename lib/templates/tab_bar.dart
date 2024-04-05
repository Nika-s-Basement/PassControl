import 'package:flutter/material.dart';

import 'package:skupka_kradenogo/pages/main_page.dart';


class CustomPageController extends StatefulWidget {
  @override
  _CustomPageControllerState createState() => _CustomPageControllerState();
}

class _CustomPageControllerState extends State<CustomPageController>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
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
          Center(child: Text('Новости')),
          Center(child: CardsGrid()),
          Center(child: Text('Контакты')),
          Center(child: Text('Вход')),
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
  final List<String> _tabs = ['Новости', 'Лоты', 'Контакты', 'Вход'];

  @override
  void initState() {
    super.initState();
    _indicatorPosition = 0;
    widget.tabController.addListener(_setActiveTab);
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_setActiveTab);
    super.dispose();
  }

  void _setActiveTab() {
    setState(() {
      _indicatorPosition = widget.tabController.index.toDouble();
    });
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var tabWidth = ((screenWidth - 100) / _tabs.length);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List<Widget>.generate(_tabs.length, (index) {
            return GestureDetector(
              onTap: () => widget.tabController.animateTo(index),
              child: Container(
                height: 40,
                width: tabWidth,
                alignment: Alignment.center,
                child: Text(
                  _tabs[index],
                  style: TextStyle(
                    color: widget.tabController.index == index ? Colors.black : Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Montserrat',
                  ),
                ),
              ),
            );
          }),
        ),
        AnimatedContainer(
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
          alignment: Alignment(_indicatorPosition / (_tabs.length - 1) * 2 - 1, 0),
          child: Container(
            width: tabWidth,
            height: 2,
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}