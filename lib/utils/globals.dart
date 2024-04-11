import 'dart:convert';
import 'dart:html';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:math';


class Item {
  final Image image;
  final String title;
  final String subscription;
  final String price;

  Item({
    required this.image,
    required this.title,
    required this.subscription,
    required this.price,
  });
}

// List<Item> items = [
//   Item(
//     image: 'assets/item1.jpg',
//     title: 'Fantastic Widget',
//     subscription: 'This is a fantastic widget that you absolutely need in your life. The best of its kind.',
//     price: '\$20',
//   ),
//   Item(
//     image: 'assets/item2.jpg',
//     title: 'Incredible Gadget',
//     subscription: 'An incredible gadget that will make your life easier, faster, and better in every aspect.',
//     price: '\$35',
//   ),
//   Item(
//     image: 'assets/item3.jpg',
//     title: 'Amazing Thingamajig',
//     subscription: 'You won’t believe how amazing this thingamajig is until you see it for yourself. Get it now!',
//     price: '\$15',
//   ),
//   Item(
//     image: 'assets/item4.jpg',
//     title: 'Wonderful Whatsit',
//     subscription: 'This wonderful whatsit is something you didn’t even know you needed. Discover its benefits today.',
//     price: '\$25',
//   ),
//   // Добавьте больше элементов по аналогии, если нужно
// ];


List<Item> items = [];
List<Item> myItems = [];

Future<List<Item>?> fetchItems({String flag = 'lots/active'}) async {
  final url = 'http://localhost:3000/$flag';
  try {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final List<dynamic> fetchedItems = json.decode(response.body);
      List<Item> loadedItems = [];

      for (var itemJson in fetchedItems) {
        final item = Item(
          image: itemJson['image_url'],
          title: itemJson['title'],
          subscription: itemJson['description'],
          price: itemJson['current_price'].toString(),
        );
        loadedItems.add(item);
      }

      if (flag.contains('lots/active')) {
        items = loadedItems;
        return items;
      } else if (flag.contains('lots/user')) {
        myItems = loadedItems;
        return myItems;
      }

    } else {
      throw Exception('Failed to load items');
    }
  } catch (e) {
    print(e.toString());
    // Обработка исключений/ошибок запроса
  }
  return null;
}