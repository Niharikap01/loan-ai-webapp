import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ai_explanation.dart';

class AiService {
  static const String baseUrl = 'http://127.0.0.1:8000';

  static Future<AiExplanation> fetchExplanation(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/predict-risk'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );

    if (response.statusCode != 200) {
      throw Exception('AI explanation failed');
    }

    final json = jsonDecode(response.body);
    return AiExplanation.fromJson(json);
  }
}
