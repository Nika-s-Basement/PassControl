class Item {
  final String image;
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

List<Item> items = [
  Item(
    image: 'assets/item1.jpg',
    title: 'Fantastic Widget',
    subscription: 'This is a fantastic widget that you absolutely need in your life. The best of its kind.',
    price: '\$20',
  ),
  Item(
    image: 'assets/item2.jpg',
    title: 'Incredible Gadget',
    subscription: 'An incredible gadget that will make your life easier, faster, and better in every aspect.',
    price: '\$35',
  ),
  Item(
    image: 'assets/item3.jpg',
    title: 'Amazing Thingamajig',
    subscription: 'You won’t believe how amazing this thingamajig is until you see it for yourself. Get it now!',
    price: '\$15',
  ),
  Item(
    image: 'assets/item4.jpg',
    title: 'Wonderful Whatsit',
    subscription: 'This wonderful whatsit is something you didn’t even know you needed. Discover its benefits today.',
    price: '\$25',
  ),
  // Добавьте больше элементов по аналогии, если нужно
];
