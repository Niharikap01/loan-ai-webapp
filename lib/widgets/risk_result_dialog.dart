import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class RiskResultDialog extends StatelessWidget {
  const RiskResultDialog({
    super.key,
    required this.riskGrade,
    required this.confidence,
    required this.onClose,
  });

  final String riskGrade;
  final int confidence;
  final VoidCallback onClose;

  Color get _riskColor {
    switch (riskGrade.toUpperCase()) {
      case 'A':
        return const Color(0xFF16A34A);
      case 'B':
        return const Color(0xFFEA580C);
      case 'C':
        return const Color(0xFFDC2626);
      default:
        return AppTheme.textSecondary;
    }
  }

  String get _riskDescription {
    switch (riskGrade.toUpperCase()) {
      case 'A':
        return 'Low risk - Excellent repayment capacity';
      case 'B':
        return 'Medium risk - Good repayment capacity';
      case 'C':
        return 'High risk - Requires careful consideration';
      default:
        return 'Risk assessment completed';
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.surface,
      surfaceTintColor: AppTheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      title: const Text('AI Risk Assessment'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          Center(
            child: Column(
              children: [
                Text(
                  riskGrade.toUpperCase(),
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontSize: 48,
                        fontWeight: FontWeight.w800,
                        color: _riskColor,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Risk grade',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Center(
            child: Text(
              _riskDescription,
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF0F3F8),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE5E7EB)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Confidence',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '$confidence%',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: AppTheme.textPrimary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        FilledButton(
          onPressed: onClose,
          child: const Text('Continue'),
        ),
      ],
    );
  }
}

