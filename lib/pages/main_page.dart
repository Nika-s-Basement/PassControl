import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:skupka_kradenogo/constraints/colors.dart';

import 'package:skupka_kradenogo/utils/globals.dart';

import '../templates/bid_input.dart';


class CardsGrid extends StatefulWidget {
  late List<Item> itemArray;
  late bool isNeeded;
  CardsGrid({required this.itemArray, this.isNeeded=true});
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
      widget.itemArray.length,
          (index) =>
          AnimationController(
            vsync: this,
            duration: const Duration(milliseconds: 500),
          ),
    );

    _opacityAnimations = _controllers.map((controller) =>
        Tween<double>(begin: 0.0, end: 1.0).animate(controller)).toList();

    _slideAnimations = _controllers.map((controller) =>
        Tween<Offset>(begin: const Offset(0, -0.1), end: Offset.zero).animate(
            controller)).toList();

    var delay = const Duration(milliseconds: 150);
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
    return FutureBuilder(
        future: fetchItems(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Произошла ошибка'));
          } else if (widget.itemArray.isEmpty) {
            return const Center(child: Text(
                'Нет активных лотов'));
          } else {
            return LayoutBuilder(
            builder: (context, constraints) {
              int crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;

              return SizedBox(
                width: MediaQuery
                    .of(context)
                    .size
                    .width > 600 ? 600 : 300,
                child: GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: (3 / 5),
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: widget.itemArray.length,
                  itemBuilder: (context, index) {
                    final item = widget.itemArray[index];
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
                          color: appColors?.secondaryColor,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: SizedBox(
                                    height: 200,
                                    child: Image.network(
                                        'http://localhost:3000/${item.image}',
                                        fit: BoxFit.cover),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment
                                        .start,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Text(item.title,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20))),
                                      Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8),
                                          child: Text(item.subscription,
                                              style: const TextStyle(
                                                  color: Colors.grey))),
                                      const Spacer(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 5).copyWith(bottom: 5),
                                        child: widget.isNeeded ? BidWidget(
                                          price: item.price,
                                          lotId: item.id,
                                        ) : Align(
                                          alignment: Alignment.center,
                                          child: Text(
                                            '\$${item.price}',
                                            key: const ValueKey('Price'),
                                            style: const TextStyle(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30,
                                            ),
                                          ),
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
    );
          }
        }
    );
  }
}
