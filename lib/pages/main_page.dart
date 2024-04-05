import 'package:flutter/material.dart';

import 'package:skupka_kradenogo/utils/globals.dart';


class CardsGrid extends StatefulWidget {
  @override
  _CardsGridState createState() => _CardsGridState();
}

class _CardsGridState extends State<CardsGrid> with TickerProviderStateMixin {
  late List<AnimationController> _controllers;
  late List<Animation<double>> _opacityAnimations;
  late List<Animation<Offset>> _slideAnimations;

  @override
  void initState() {
    super.initState();
    _controllers = List<AnimationController>.generate(
      items.length, // Предполагаем, что у вас есть список элементов items
          (index) => AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 500),
      ),
    );

    _opacityAnimations = _controllers.map((controller) =>
        Tween<double>(begin: 0.0, end: 1.0).animate(controller)).toList();

    _slideAnimations = _controllers.map((controller) =>
        Tween<Offset>(begin: const Offset(0, -0.1), end: Offset.zero).animate(controller)).toList();

    // Добавляем задержку между анимациями
    var delay = const Duration(milliseconds: 150); // Начальная задержка
    for (var i = 0; i < _controllers.length; i++) {
      Future.delayed(delay * i, () {
        if (mounted) {
          _controllers[i].forward();
        }
      });
    }
  }


  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width > 600 ? 600 : 300,
      child: GridView.builder(
        padding: const EdgeInsets.all(8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
          childAspectRatio: (3/5),
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
        ),
        itemCount: items.length,
        itemBuilder: (context, index) {
          final item = items[index];
          return AnimatedBuilder(
            animation: _controllers[index],
            builder: (context, child) {
              return FadeTransition(
                opacity: _opacityAnimations[index],
                child: SlideTransition(
                  position: _slideAnimations[index],
                  child: child,
                ),
              );
            },
            child: SizedBox(
              width: 170,
              height: 350,
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: SizedBox(
                          height: 200,
                          child: Image.asset(item.image, fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 5), child: Text(item.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20))),
                            Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text(item.subscription, style: const TextStyle(color: Colors.grey))),
                            const Spacer(),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 5).copyWith(bottom: 5),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    style: TextButton.styleFrom(
                                      backgroundColor: Colors.lime,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                    ),
                                    onPressed: () {
                                      // Здесь логика для кнопки "Купить"
                                    },
                                    child: const Text(
                                      'Buy',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      item.price,
                                      style: const TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30, // Адаптируйте размер шрифта в зависимости от высоты вашей кнопки
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
