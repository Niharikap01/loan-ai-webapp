import 'package:flutter/material.dart';

enum LoanStatus { pending, funded, partiallyFunded, repaid }

enum RiskGrade { a, b, c }

class LoanRequest {
  LoanRequest({
    required this.borrowerName,
    required this.purpose,
    required this.amount,
    required this.durationMonths,
    required this.status,
    required this.riskGrade,
    required this.income,
    required this.expenses,
  required this.repaymentScore,
  required this.tenureMonths,
  });

  final String borrowerName;
  final String purpose;
  final double amount;
  final int durationMonths;
  final LoanStatus status;
  final RiskGrade riskGrade;
  final double income;
final double expenses;
final double repaymentScore;
final int tenureMonths;
  


  String get formattedAmount => 'USD ${amount.toStringAsFixed(0)}';

  String get formattedDuration => '$durationMonths months';

  String get statusLabel {
    switch (status) {
      case LoanStatus.pending:
        return 'Pending';
      case LoanStatus.funded:
        return 'Funded';
      case LoanStatus.partiallyFunded:
        return 'Partially Funded';
      case LoanStatus.repaid:
        return 'Repaid';
    }
  }

  Color get statusColor {
    switch (status) {
      case LoanStatus.pending:
        return Colors.amber.shade700;
      case LoanStatus.funded:
        return Colors.green.shade600;
      case LoanStatus.partiallyFunded:
        return Colors.blue.shade600;
      case LoanStatus.repaid:
        return Colors.teal.shade700;
    }
  }

  String get riskLabel {
    switch (riskGrade) {
      case RiskGrade.a:
        return 'A';
      case RiskGrade.b:
        return 'B';
      case RiskGrade.c:
        return 'C';
    }
  }

  Color get riskColor {
    switch (riskGrade) {
      case RiskGrade.a:
        return Colors.green.shade600;
      case RiskGrade.b:
        return Colors.orange.shade700;
      case RiskGrade.c:
        return Colors.red.shade600;
    }
  }
}
