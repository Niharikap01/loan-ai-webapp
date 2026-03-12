import 'package:flutter/material.dart';
import 'dart:ui';

import '../app.dart';
import '../models/loan_request.dart';
import '../widgets/loan_request_card.dart';
import '../widgets/ambient_background.dart';

class LenderDashboardScreen extends StatefulWidget {
  const LenderDashboardScreen({
    super.key,
    required this.loanRequests,
  });

  final List<LoanRequest> loanRequests;

  @override
  State<LenderDashboardScreen> createState() => _LenderDashboardScreenState();
}

class _LenderDashboardScreenState extends State<LenderDashboardScreen> {
  final Map<LoanRequest, double> _funded = {};

  double _getFunded(LoanRequest loan) => _funded[loan] ?? 0.0;
  double _getRemaining(LoanRequest loan) => (loan.amount - _getFunded(loan)).clamp(0.0, loan.amount);

  Future<void> _openFundingDialog(LoanRequest loan) async {
    final controller = TextEditingController();
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) {
        final already = _getFunded(loan);
        final remaining = _getRemaining(loan);
        return Center(
          child: Material(
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
                child: Container(
                  width: 400,
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.20),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white.withOpacity(0.10)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Fund Loan', style: Theme.of(context).textTheme.titleMedium?.copyWith(color: Colors.white)),
                        const SizedBox(height: 12),
                        DefaultTextStyle.merge(
                          style: const TextStyle(color: Colors.white),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Loan Amount: USD ${loan.amount.toStringAsFixed(0)}'),
                              Text('Amount Already Funded: USD ${already.toStringAsFixed(0)}'),
                              Text('Remaining Amount: USD ${remaining.toStringAsFixed(0)}'),
                              const SizedBox(height: 12),
                              TextField(
                                controller: controller,
                                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                decoration: const InputDecoration(
                                  labelText: 'Funding Amount',
                                  border: OutlineInputBorder(),
                                ),
                                style: const TextStyle(color: Colors.black),
                                cursorColor: Colors.black,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pop(ctx),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 12),
                            FilledButton(
                              onPressed: () {
                                final value = double.tryParse(controller.text.trim());
                                if (value == null || value <= 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Enter a valid amount')),
                                  );
                                  return;
                                }
                                final rem = _getRemaining(loan);
                                if (value > rem) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Amount exceeds remaining (USD ${rem.toStringAsFixed(0)})')),
                                  );
                                  return;
                                }
                                setState(() {
                                  _funded[loan] = _getFunded(loan) + value;
                                });
                                Navigator.pop(ctx);
                              },
                              child: const Text('Confirm Funding'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Lender Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.home_outlined),
            tooltip: 'Home',
            onPressed: () => Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.home,
              (route) => false,
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // ✅ BACKGROUND IMAGE
          const AmbientBackground(
            imagePath: 'lib/theme/assets/images/fintech_bg.jpg',
          ),

          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 1000),
                          child: Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  'Active loan requests',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontSize: (Theme.of(context).textTheme.titleLarge?.fontSize ?? 22) + 5,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Review opportunities with transparent AI risk scoring',
                                  textAlign: TextAlign.center,
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                const SizedBox(height: 20),

                              if (widget.loanRequests.isEmpty)
                                const _EmptyState()
                              else
                                for (final loan in widget.loanRequests)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 12),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(24),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black.withOpacity(0.20),
                                            borderRadius: BorderRadius.circular(24),
                                            border: Border.all(
                                              color: Colors.white.withOpacity(0.10),
                                            ),
                                          ),
                                          child: LoanRequestCard(
                                            loanRequest: loan,
                                            trailing: Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Builder(
                                                  builder: (_) {
                                                    final funded = _getFunded(loan);
                                                    final percent = (funded / loan.amount).clamp(0.0, 1.0);
                                                    final pctText = '${(percent * 100).toStringAsFixed(0)}% funded';
                                                    return Text(pctText, style: Theme.of(context).textTheme.bodySmall);
                                                  },
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    OutlinedButton(
                                                      onPressed: () => _openFundingDialog(loan),
                                                      child: const Text('Fund Loan'),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    FilledButton(
                                                      onPressed: () => Navigator.pushNamed(
                                                        context,
                                                        AppRoutes.loanDetails,
                                                        arguments: loan,
                                                      ),
                                                      child: const Text('View Details'),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(48),
        child: Column(
          children: [
            Icon(
              Icons.search_off_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'No active requests',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Check back later for new lending opportunities',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            OutlinedButton(
              onPressed: () => Navigator.of(context).maybePop(),
              child: const Text('Go Back'),
            ),
          ],
        ),
      ),
    );
  }
}
