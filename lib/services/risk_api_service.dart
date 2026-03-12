import 'dart:convert';
import 'package:http/http.dart' as http;

class RiskApiService {
  static const String _baseUrl = 'http://127.0.0.1:8000';
  static const Duration _timeout = Duration(seconds: 30);

  static Future<Map<String, dynamic>> predictRisk({
    required double income,
    required double expenses,
    required double loanAmount,
    required int tenureMonths,
    required int repaymentScore,
  }) async {
    final url = Uri.parse('$_baseUrl/predict-risk');

    try {
      final response = await http
          .post(
            url,
            headers: const {
              'Content-Type': 'application/json',
            },
            body: jsonEncode({
              'income': income,
              'expenses': expenses,
              'loan_amount': loanAmount,
              'tenure_months': tenureMonths,
              'repayment_score': repaymentScore,
            }),
          )
          .timeout(_timeout);

      if (response.statusCode != 200) {
        throw Exception(
            'Server error ${response.statusCode}: ${response.body}');
      }

      final decoded = jsonDecode(response.body);

      // ✅ HARD DEFENSIVE CHECK
      if (decoded is! Map<String, dynamic>) {
        throw Exception('Invalid AI response format');
      }

      // ✅ DO NOT enforce optional fields
      return {
        'risk_grade': decoded['risk_grade'] ?? 'C',
        'confidence_percent': decoded['confidence_percent'] ?? 0,
        'risk_score': decoded['risk_score'],
        'shap': decoded['shap'], // may be null
        'lime': decoded['lime'], // may be null
      };
    } catch (e) {
      // ❗ NEVER crash UI — return empty but valid map
      return {};
    }
  }
}

