import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EmiSimulatorCard extends StatefulWidget {
  final double loanAmount;
  final int tenureMonths;

  const EmiSimulatorCard({
    super.key,
    required this.loanAmount,
    required this.tenureMonths,
  });

  @override
  State<EmiSimulatorCard> createState() => _EmiSimulatorCardState();
}

class _EmiSimulatorCardState extends State<EmiSimulatorCard> {
  double _interestRate = 10.0;

  double get _emi {
    final monthlyRate = _interestRate / 12 / 100;
    final n = widget.tenureMonths;

    return widget.loanAmount *
        monthlyRate *
        (pow(1 + monthlyRate, n)) /
        (pow(1 + monthlyRate, n) - 1);
  }

  double get _totalPayable => _emi * widget.tenureMonths;

  @override
  Widget build(BuildContext context) {
    final currency =
        NumberFormat.currency(locale: 'en_IN', symbol: '₹');

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white.withOpacity(0.12),
            border: Border.all(
              color: Colors.white.withOpacity(0.25),
            ),
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// EMI Amount
              Text(
                'Estimated EMI',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 6),
              Text(
                currency.format(_emi),
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),

              const SizedBox(height: 16),

              /// Interest Rate Slider
              Text(
                'Interest Rate: ${_interestRate.toStringAsFixed(1)}%',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Slider(
                value: _interestRate,
                min: 6,
                max: 24,
                divisions: 36,
                label: '${_interestRate.toStringAsFixed(1)}%',
                onChanged: (value) {
                  setState(() {
                    _interestRate = value;
                  });
                },
              ),

              const SizedBox(height: 12),

              /// Details Row
              _infoRow(
                'Loan Amount',
                currency.format(widget.loanAmount),
              ),
              _infoRow(
                'Tenure',
                '${widget.tenureMonths} months',
              ),
              _infoRow(
                'Total Payable',
                currency.format(_totalPayable),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

/// Needed for pow()
double pow(double x, int exponent) {
  double result = 1;
  for (int i = 0; i < exponent; i++) {
    result *= x;
  }
  return result;
}
