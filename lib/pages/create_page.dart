import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddLotPage extends StatefulWidget {
  @override
  _AddLotPageState createState() => _AddLotPageState();
}

class _AddLotPageState extends State<AddLotPage> {
  final _formKey = GlobalKey<FormState>();
  String? _title, _description, _imageUrl, _activeUntil;
  double? _price;
  String? _category;
  final _storage = const FlutterSecureStorage();
  final Map<String, String> categories = {
    'real_estate': 'media/real_estate.jpg',
    'transport': 'media/transport.jpg',
    'electronics': 'media/electronics.jpg',
    'furniture': 'media/furniture.jpg',
    'misc': 'media/misc.jpg'
  };

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != DateTime.tryParse(_activeUntil ?? '')) {
      setState(() {
        _activeUntil = picked.toIso8601String().split('T')[0]; // Сохраняем дату в формате YYYY-MM-DD
      });
    }
  }


  Future<void> submitLot() async {
    String? id = await _storage.read(key: 'id');
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      var response = await http.post(
        Uri.parse('http://localhost:3000/lots'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'title': _title,
          'description': _description,
          'initial_price': _price,
          'current_price': _price,
          'user_id': id,
          'category': _category,
          'active_until': _activeUntil,
        }),
      );
      if (response.statusCode == 200) {
        print('Lot added successfully');
      } else {
        print('Failed to add lot');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add a Lot"),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(16),
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Title'),
              onSaved: (value) => _title = value,
              validator: (value) => value!.isEmpty ? 'Please enter title' : null,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Description'),
              onSaved: (value) => _description = value,
              validator: (value) => value!.isEmpty ? 'Please enter description' : null,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              onSaved: (value) => _price = double.tryParse(value!),
              validator: (value) => value!.isEmpty ? 'Please enter price' : null,
            ),
            DropdownButtonFormField(
              decoration: InputDecoration(labelText: 'Category'),
              value: _category,
              items: categories.keys.map((category) {
                return DropdownMenuItem(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? value) {
                setState(() {
                  _category = value;
                });
              },
              validator: (value) => value == null ? 'Please select a category' : null,
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Active Until'),
              controller: TextEditingController(text: _activeUntil),
              onTap: () {
                _selectDate(context); // Вызов функции выбора даты при нажатии на поле
              },
              readOnly: true, // Сделаем поле только для чтения, так как дата выбирается через DatePicker
              validator: (value) => value!.isEmpty ? 'Please enter active until date' : null,
            ),
            const SizedBox(height: 10,),
            ElevatedButton(
              onPressed: submitLot,
              child: Text('Submit Lot'),
            ),
          ],
        ),
      ),
    );
  }
}
