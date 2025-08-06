import 'dart:convert';
import 'package:http/http.dart' as http;

class UserService {
  static Future<List<Map<String, dynamic>>> fetchUsers() async {
    final uri = Uri.http('localhost:8080', '/api/users'); // Change host if needed
    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final List data = json.decode(response.body);
      return data.cast<Map<String, dynamic>>();
    } else {
      throw Exception('Failed to load users');
    }
  }
}