import 'package:flutter/material.dart';

import '../models/loan_request.dart';
import 'risk_badge.dart';

class LoanRequestCard extends StatelessWidget {
  const LoanRequestCard({
    super.key,
    required this.loanRequest,
    this.onTap,
    this.trailing,
  });

  final LoanRequest loanRequest;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                          loanRequest.borrowerName,
                            style: Theme.of(context).textTheme.titleMedium,
                              ),
                        ),
                        const SizedBox(width: 12),
                        RiskBadge(riskGrade: loanRequest.riskGrade),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      loanRequest.purpose,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _Chip(label: loanRequest.formattedAmount),
                        _Chip(label: loanRequest.formattedDuration),
                        _Chip(
                          label: loanRequest.statusLabel,
                          color: loanRequest.statusColor.withOpacity(0.1),
                          textColor: loanRequest.statusColor,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (trailing != null) ...[
                const SizedBox(width: 16),
                trailing!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    this.color,
    this.textColor,
  });

  final String label;
  final Color? color;
  final Color? textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.35),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
