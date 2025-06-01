import 'dart:convert';
import 'package:http/http.dart' as http;

class SearchService {
  static const String _baseUrl = 'http://192.168.1.8:8000'; // local dev only

  static Future<Map<String, dynamic>> search(String query) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/search'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'query': query}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to search: ${response.statusCode}');
    }
  }
}
