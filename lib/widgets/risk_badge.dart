import 'package:flutter/material.dart';

import '../models/loan_request.dart';

class RiskBadge extends StatelessWidget {
  const RiskBadge({super.key, required this.riskGrade});

  final RiskGrade riskGrade;

  @override
  Widget build(BuildContext context) {
    final color = _colorForGrade(riskGrade);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color, width: 1),
      ),
      child: Text(
        'Risk ${riskGrade.name.toUpperCase()}',
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color _colorForGrade(RiskGrade grade) {
    switch (grade) {
      case RiskGrade.a:
        return const Color(0xFF16A34A); // Green
      case RiskGrade.b:
        return const Color(0xFFEA580C); // Orange
      case RiskGrade.c:
        return const Color(0xFFDC2626); // Red
    }
  }
}
