import 'package:flutter/material.dart';
import '../services/risk_api_service.dart';
import '../widgets/emi_simulator_card.dart';

import '../models/loan_request.dart';
import '../widgets/risk_badge.dart';
import '../widgets/ambient_background.dart';

class LoanDetailsScreen extends StatelessWidget {
  const LoanDetailsScreen({super.key, required this.loanRequest});

  final LoanRequest? loanRequest;

  @override
  Widget build(BuildContext context) {
    final loan = loanRequest;

    if (loan == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loan Details')),
        body: const Center(child: Text('No loan selected')),
      );
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Loan Details'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Stack(
        children: [
          const AmbientBackground(
            imagePath: 'lib/theme/assets/images/fintech_bg.jpg',
          ),
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Borrower Summary
                      _SectionCard(
                        title: 'Borrower Summary',
                        child: Row(
                          children: [
                            CircleAvatar(
                              radius: 28,
                              backgroundColor: Theme.of(context)
                                  .colorScheme
                                  .primary
                                  .withOpacity(0.12),
                              child: Icon(
                                Icons.person,
                                size: 28,
                                color:
                                    Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    loan.borrowerName,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Verified borrower • Profile completeness: 92%',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// Loan Details
                      _SectionCard(
                        title: 'Loan Details',
                        child: Column(
                          children: [
                            _InfoRow(
                                label: 'Purpose',
                                value: loan.purpose),
                            _InfoRow(
                                label: 'Amount',
                                value: loan.formattedAmount),
                            _InfoRow(
                                label: 'Duration',
                                value: loan.formattedDuration),
                            _InfoRow(
                                label: 'Status',
                                value: loan.statusLabel),
                            const SizedBox(height: 16),
                            RiskBadge(riskGrade: loan.riskGrade),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      /// Risk Assessment
                      _SectionCard(
                        title: 'Risk Assessment (Explainable AI)',
                        child: FutureBuilder<Map<String, dynamic>>(
  future: RiskApiService.predictRisk(
    income: loan.income,
    expenses: loan.expenses,
    loanAmount: loan.amount,
    tenureMonths: loan.tenureMonths,
    repaymentScore: (loan.repaymentScore is num)
        ? (loan.repaymentScore as num).round()
        : 0,
  ),
  builder: (context, snapshot) {
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const Center(child: CircularProgressIndicator());
    }

    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const Text('Risk explanation unavailable');
    }

    final data = snapshot.data!;
    final shapRaw = data['shap_values'] ?? data['shap'];
    final limeRaw = data['lime_explanation'] ?? data['lime'];

    final Map<String, dynamic> shap =
        shapRaw is Map ? shapRaw.cast<String, dynamic>() : {};
    final List<dynamic> lime = limeRaw is List ? limeRaw : [];

    if (shap.isEmpty && lime.isEmpty) {
      return const Text('Risk explanation unavailable');
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (shap.isNotEmpty) ...[
          Text('Global Feature Impact (SHAP)',
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 12),
          ...shap.entries.map((e) {
            final num val = e.value is num ? e.value as num : 0;
            final double pct = val.abs().clamp(0.0, 1.0).toDouble();
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  Expanded(child: Text(e.key)),
                  SizedBox(
                    width: 120,
                    child: LinearProgressIndicator(
                      value: pct,
                      backgroundColor: Colors.white12,
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(height: 20),
        ],
        if (lime.isNotEmpty) ...[
          Text('Local Explanation (LIME)',
              style: Theme.of(context).textTheme.titleSmall),
          const SizedBox(height: 8),
          ...lime.map((item) => Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Text(item?.toString() ?? ''),
              )),
        ],
      ],
    );
  },
)
                      ),

                      const SizedBox(height: 16),

                      /// EMI Simulator
                      _SectionCard(
                        title: 'Loan Repayment Simulator',
                        child: EmiSimulatorCard(
                          loanAmount: loan.amount,
                          tenureMonths: loan.tenureMonths,
                        ),
                      ),

                      const SizedBox(height: 24),

                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                              const SnackBar(
                                content: Text(
                                    'Funding initiated (demo action)'),
                              ),
                            );
                          },
                          child: const Text('Fund Loan'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  Theme.of(context).textTheme.bodySmall),
          Text(
            value,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: Theme.of(context).cardColor.withOpacity(0.85),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleMedium),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}
