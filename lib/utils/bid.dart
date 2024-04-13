import 'package:http/http.dart' as http;
import 'dart:convert';

Future<void> updateBid(String userId, String lotId, String bid) async {
  String url = 'http://localhost:3000/lots/$lotId/bids';

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'user_id': userId,
        'amount': bid
      }),
    );

    if (response.statusCode == 200) {
      print('Bid submitted successfully');
      // Обработка успешного ответа
    } else {
      print('Failed to submit bid: ${response.body}');
      // Обработка ошибок сервера
    }
  } catch (e) {
    print('Error occurred while sending request: $e');
    // Обработка ошибок соединения
  }
}
