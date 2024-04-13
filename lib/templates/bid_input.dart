import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:skupka_kradenogo/utils/alert.dart';
import 'package:skupka_kradenogo/utils/bid.dart';

class BidWidget extends StatefulWidget {
  final String price;
  final String lotId;

  const BidWidget({
    Key? key,
    required this.price,
    required this.lotId,
  }) : super(key: key);

  @override
  _BidWidgetState createState() => _BidWidgetState();
}

class _BidWidgetState extends State<BidWidget> {
  final _storage = const FlutterSecureStorage();
  final _controller = TextEditingController();
  bool _isEditing = false;
  String? userId;

  void _onTap() {
    setState(() {
      if (userId != null) {
        _isEditing = true;
      } else {
        showAlert(context);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    checkTokenAndUpdateTab();
  }

  void checkTokenAndUpdateTab() async {
    String? id = await _storage.read(key: 'id');
    setState(() {
      userId = id;
    });
  }

  void _onSubmit() {
    final double bid = double.parse(_controller.text);
    if (bid > double.parse(widget.price) + 2) {
      updateBid(userId!, widget.lotId, bid.toString());
      setState(() {
        _isEditing = false;
        _controller.clear();
      });
    } else {
      // Обработка ошибки: ставка меньше item.price + 2 или не является числом
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(scale: animation, child: child);
          },
          child: _isEditing
              ? Container(
              padding: EdgeInsets.only(bottom: 5),
              height: 50,
              width: 254,
              child: Row(
                children: [
                  Container(
                    height: 50,
                    width: 200,
                    child: TextField(
                      controller: _controller,
                      onSubmitted: (_) => _onSubmit(),
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.indigo[500],
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 20),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.check, color: Colors.lightGreen),
                    onPressed: _onSubmit,
                    color: Colors.indigo[500],
                    padding: EdgeInsets.zero,
                    // Установка отступов в ноль
                    alignment: Alignment
                        .center, // Выравнивание иконки по центру
                  ),
                ],
              )
          )
              : TextButton(
            key: const ValueKey('TextButton'),
            style: TextButton.styleFrom(
              backgroundColor: Colors.lime,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            ),
            onPressed: _onTap,
            child: const Text(
              'Bid',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
        if (!_isEditing)
          Align(
            alignment: Alignment.center,
            child: Text(
              '\$${widget.price}',
              key: const ValueKey('Price'),
              style: const TextStyle(
                color: Colors.red,
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
          ),
      ],
    );
  }
}
