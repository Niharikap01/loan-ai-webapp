import 'package:flutter/material.dart';
import '../widgets/ambient_background.dart';

class RiskExplanationScreen extends StatelessWidget {
  const RiskExplanationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('AI Risk Assessment'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          const AmbientBackground(
            imagePath: 'lib/theme/assets/images/ambient_bg.jpg',
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
                          constraints: const BoxConstraints(maxWidth: 900),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                // Risk Grade
                _RiskGradeCard(),

                const SizedBox(height: 32),

                // SHAP Explanation
                Text(
                  'Why this risk score?',
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),

                _ExplanationCard(
                  title: 'Global Factors (SHAP)',
                  description:
                      'These factors had the highest impact on the borrower’s risk score.',
                  items: const [
                    ExplanationItem(
                      label: 'Stable Monthly Income',
                      impact: 'Positive',
                    ),
                    ExplanationItem(
                      label: 'Low Debt-to-Income Ratio',
                      impact: 'Positive',
                    ),
                    ExplanationItem(
                      label: 'Short Credit History',
                      impact: 'Negative',
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // LIME Explanation
                _ExplanationCard(
                  title: 'This Case Explanation (LIME)',
                  description:
                      'For this specific borrower, the AI model focused on:',
                  items: const [
                    ExplanationItem(
                      label: 'Consistent income for last 6 months',
                      impact: 'Positive',
                    ),
                    ExplanationItem(
                      label: 'No previous defaults',
                      impact: 'Positive',
                    ),
                    ExplanationItem(
                      label: 'Higher requested amount than average',
                      impact: 'Negative',
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // Trust note
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blueGrey.withOpacity(0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Icon(Icons.info_outline, size: 20),
                      SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'This AI score is designed to support human decision-making, not replace it. Lenders are encouraged to review borrower details carefully.',
                        ),
                      ),
                    ],
                  ),
                )
              ],
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

// --------------------
// Widgets
// --------------------

class _RiskGradeCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: Colors.green.withOpacity(0.15),
              child: const Text(
                'A',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.green,
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Low Risk Borrower',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Based on income stability, repayment behavior, and loan duration.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExplanationCard extends StatelessWidget {
  final String title;
  final String description;
  final List<ExplanationItem> items;

  const _ExplanationCard({
    required this.title,
    required this.description,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(description),
            const SizedBox(height: 16),
            ...items.map((item) => _ExplanationRow(item: item)),
          ],
        ),
      ),
    );
  }
}

class _ExplanationRow extends StatelessWidget {
  final ExplanationItem item;

  const _ExplanationRow({required this.item});

  @override
  Widget build(BuildContext context) {
    final isPositive = item.impact == 'Positive';

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Icon(
            isPositive ? Icons.arrow_upward : Icons.arrow_downward,
            color: isPositive ? Colors.green : Colors.red,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(child: Text(item.label)),
          Text(
            item.impact,
            style: TextStyle(
              color: isPositive ? Colors.green : Colors.red,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

// --------------------
// Model
// --------------------

class ExplanationItem {
  final String label;
  final String impact;

  const ExplanationItem({
    required this.label,
    required this.impact,
  });
}
