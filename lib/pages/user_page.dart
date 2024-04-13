import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:skupka_kradenogo/constraints/colors.dart';

import '../utils/globals.dart';
import 'main_page.dart';

class UserPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColors?.primaryColor,
      body: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              color: const Color(0x50f44336),
              child: const Center(
                child: Text('Данные о пользователе'),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: const Color(0x504CAF50),
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
                    Expanded(child: CardsGrid(itemArray: items, isNeeded: false,),)
                  ],
                )
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: const Color(0x502196F3),
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
                    Expanded(child: CardsGrid(itemArray: myItems, isNeeded: false,),)
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
