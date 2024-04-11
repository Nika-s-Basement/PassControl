import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/globals.dart';
import 'main_page.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              color: Colors.red,
              child: Center(
                child: Text('Левая часть'),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.green,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                      child: Text(
                        'Мои лоты',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                      ),
                    ),
                    Expanded(child: CardsGrid(itemArray: items),)
                  ],
                )
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: Colors.blue,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100,
                      child: Text(
                        'Мои ставки',
                        style: GoogleFonts.montserrat(
                          textStyle: const TextStyle(
                            color: Colors.black,
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                          )
                        ),
                      ),
                    ),
                    Expanded(child: CardsGrid(itemArray: myItems),)
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
