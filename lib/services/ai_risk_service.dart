// lib/services/ai_risk_service.dart
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

/// AI Risk Service for calling the FastAPI backend
///
/// Sends POST request to FastAPI /predict_risk (or /predict-risk)
/// with financial data and returns risk assessment.
///
/// Designed for Flutter web compatibility (Chrome/Edge).
class AiRiskService {
  // IMPORTANT for Flutter Web:
  // Use 127.0.0.1 explicitly (per requirement) and allow it via FastAPI CORS.
  static const String _baseUrl = 'http://127.0.0.1:8000';
  // Prefer contract endpoint; backend also supports /predict-risk for compatibility.
  static const String _endpoint = '/predict_risk';
  static const Duration _timeout = Duration(seconds: 15);

  /// Predicts risk grade based on financial data
  ///
  /// Request schema (must match backend):
  /// - income (double)
  /// - expenses (double)
  /// - loan_amount (double)
  /// - tenure_months (int)
  /// - repayment_score (int)
  static Future<Map<String, dynamic>> predictRisk({
    required double income,
    required double expenses,
    required double loanAmount,
    required int tenureMonths,
    required int repaymentScore,
  }) async {
    // Construct full URL with endpoint
    final url = Uri.parse('$_baseUrl$_endpoint');

    try {
      final requestBody = jsonEncode({
        'income': income,
        'expenses': expenses,
        'loan_amount': loanAmount,
        'tenure_months': tenureMonths,
        'repayment_score': repaymentScore,
      });

      // Make POST request with proper headers
      final response = await http
          .post(
            url,
            headers: const {
              'Content-Type': 'application/json',
              'Accept': 'application/json',
            },
            body: requestBody,
          )
          .timeout(_timeout);

      if (response.statusCode != 200) {
        final message = _extractErrorMessage(response.body) ??
            'AI service returned an error (${response.statusCode}).';
        throw AiServiceException(message);
      }

      try {
        final decoded = jsonDecode(response.body);
        if (decoded is! Map) {
          throw const FormatException('Response is not a JSON object.');
        }
        return decoded.cast<String, dynamic>();
      } on FormatException {
        throw const AiServiceException(
          'AI service returned an invalid response. Please try again.',
        );
      }
    } on http.ClientException {
      throw const AiServiceException(
        'Unable to reach the AI service. Please ensure the backend is running.',
      );
    } on AiServiceException {
      rethrow;
    } on TimeoutException {
      throw const AiServiceException(
        'AI service timed out. Please try again.',
      );
    } catch (e) {
      throw AiServiceException(
        'Unexpected error contacting AI service: ${e.toString()}',
      );
    }
  }

  static String? _extractErrorMessage(String body) {
    try {
      final decoded = jsonDecode(body);
      if (decoded is Map && decoded['detail'] is String) {
        return decoded['detail'] as String;
      }
    } catch (_) {
      // ignore
    }
    return null;
  }
}

class AiServiceException implements Exception {
  const AiServiceException(this.message);
  final String message;

  @override
  String toString() => message;
}