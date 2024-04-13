import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:skupka_kradenogo/constraints/colors.dart';

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
      backgroundColor: appColors?.primaryColor,
      appBar: AppBar(
        backgroundColor: appColors?.primaryColor,
        title: Text("Add a Lot", style: TextStyle(color: appColors?.textColor)),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 300,
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      child: TextFormField(
                        style: TextStyle(color: appColors?.textColor),
                        decoration: InputDecoration(
                          labelText: 'Title',
                          labelStyle: TextStyle(color: appColors?.textColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onSaved: (value) => _title = value,
                        validator: (value) => value!.isEmpty ? 'Please enter title' : null,
                      ),
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      child: TextFormField(
                        style: TextStyle(color: appColors?.textColor),
                        decoration: InputDecoration(
                          labelText: 'Description',
                          labelStyle: TextStyle(color: appColors?.textColor),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(30.0),
                          ),
                        ),
                        onSaved: (value) => _description = value,
                        validator: (value) => value!.isEmpty ? 'Please enter description' : null,
                        maxLines: 4, // Увеличение количества строк для большего описания
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 20), // Промежуток между колонками
              SizedBox(
                width: 300,
                child: Column(
                  children: [
                    TextFormField(
                      style: TextStyle(color: appColors?.textColor),
                      decoration: InputDecoration(
                        labelText: 'Price',
                        labelStyle: TextStyle(color: appColors?.textColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      keyboardType: TextInputType.number,
                      onSaved: (value) => _price = double.tryParse(value!),
                      validator: (value) => value!.isEmpty ? 'Please enter price' : null,
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField(
                      style: TextStyle(color: appColors?.textColor),
                      decoration: InputDecoration(
                        labelText: 'Category',
                        labelStyle: TextStyle(color: appColors?.textColor),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
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
                      dropdownColor: appColors?.secondaryColor,
                      validator: (value) => value == null ? 'Please select a category' : null,
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      style: TextStyle(color: appColors?.textColor),
                      decoration: InputDecoration(
                        labelText: 'Active Until',
                        labelStyle: TextStyle(color: appColors?.textColor),
                        fillColor: appColors?.primaryColor,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                        ),
                      ),
                      controller: TextEditingController(text: _activeUntil),
                      onTap: () {
                        _selectDate(context); // Вызов функции выбора даты
                      },
                      readOnly: true,
                      validator: (value) => value!.isEmpty ? 'Please enter active until date' : null,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 20,),
          ElevatedButton(
            style: ButtonStyle(backgroundColor: MaterialStateProperty.all(appColors?.secondaryColor)),
            onPressed: submitLot,
            child: Text('Submit Lot', style: TextStyle(color: appColors?.textColor)),
          ),
        ]
        ),
      ),
    );
  }
}

