

import 'package:flutter/material.dart';

void showAlert(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Вы не вошли'),
        content: Text('Для использования этой функции необходимо быть авторизованным пользователем'),
        actions: <Widget>[
          TextButton(
            child: Text('Закрыть'),
            onPressed: () {
              Navigator.of(context).pop(); // Закрывает диалоговое окно
            },
          ),
          TextButton(
            child: Text('Войти'),
            onPressed: () {
              // Обработка действия пользователя
              Navigator.of(context).pop(); // Закрывает диалоговое окно
            },
          ),
        ],
      );
    },
  );
}
