import 'package:flutter/material.dart';
import 'dart:ui';

import '../app.dart';
import '../models/loan_request.dart';
import '../widgets/loan_request_card.dart';
import '../widgets/full_screen_background.dart';
import 'borrower_profile_setup_screen.dart';

class BorrowerDashboardScreen extends StatefulWidget {
  const BorrowerDashboardScreen({
    super.key,
    required this.loanRequests,
  });

  final List<LoanRequest> loanRequests;

  @override
  State<BorrowerDashboardScreen> createState() => _BorrowerDashboardScreenState();
}

class _BorrowerDashboardScreenState extends State<BorrowerDashboardScreen> {
  static bool _profileCompleted = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_profileCompleted) {
        final completed = await Navigator.push<bool>(
          context,
          MaterialPageRoute(builder: (_) => const BorrowerProfileSetupScreen()),
        );
        if (completed == true) {
          setState(() => _profileCompleted = true);
        } else {
          if (mounted) {
            Navigator.pop(context);
          }
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        title: const Text('Borrower Dashboard'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: FilledButton.icon(
              onPressed: () {
                Navigator.pushNamed(context, AppRoutes.createLoanRequest);
              },
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Create Request'),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          const FullScreenBackground(
            imagePath: 'lib/theme/assets/images/fintech_bg.jpg',
          ),
          SafeArea(
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints:
                        BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: ConstrainedBox(
                          constraints:
                              const BoxConstraints(maxWidth: 1000),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _ProfileSummary(),
                              const SizedBox(height: 36),

                              /// ✅ CENTERED HEADER SECTION (FIX)
                              Center(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Your loan requests',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                            fontSize:
                                                (Theme.of(context)
                                                            .textTheme
                                                            .titleLarge
                                                            ?.fontSize ??
                                                        22) +
                                                    5,
                                          ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      'Track funding status and manage repayments',
                                      textAlign: TextAlign.center,
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge
                                          ?.copyWith(
                                            color: Colors.white,
                                          ),
                                    ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 28),

                              if (widget.loanRequests.isEmpty)
                                const _EmptyState()
                              else
                                ...widget.loanRequests.map(
                                  (loan) => Padding(
                                    padding:
                                        const EdgeInsets.only(bottom: 12),
                                    child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.circular(24),
                                      child: BackdropFilter(
                                        filter: ImageFilter.blur(
                                            sigmaX: 24, sigmaY: 24),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black
                                                .withOpacity(0.20),
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            border: Border.all(
                                              color: Colors.white
                                                  .withOpacity(0.08),
                                            ),
                                          ),
                                          child: LoanRequestCard(
                                            loanRequest: loan,
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
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileSummary extends StatelessWidget {
  const _ProfileSummary();

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.22),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Colors.white.withOpacity(0.10)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: Theme.of(context)
                      .colorScheme
                      .primary
                      .withOpacity(0.1),
                  child: Icon(
                    Icons.person,
                    color:
                        Theme.of(context).colorScheme.primary,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Amara Lee',
                        style: Theme.of(context)
                            .textTheme
                            .titleMedium
                            ?.copyWith(
                              color: Colors.white
                                  .withOpacity(0.95),
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'SME Owner • Ghana',
                        style: Theme.of(context)
                            .textTheme
                            .bodyLarge
                            ?.copyWith(
                              color: Colors.white
                                  .withOpacity(0.85),
                            ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Wrap(
                  spacing: 12,
                  children: const [
                    _Metric(label: 'On-time', value: '98%'),
                    _Metric(label: 'Active', value: '3'),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Metric extends StatelessWidget {
  const _Metric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding:
          const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceVariant
            .withOpacity(0.35),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style:
                  Theme.of(context).textTheme.bodyMedium),
          const SizedBox(height: 2),
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
              Icons.receipt_long_outlined,
              size: 48,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withOpacity(0.6),
            ),
            const SizedBox(height: 16),
            Text(
              'No loan requests yet',
              style:
                  Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Create your first loan request to get started',
              textAlign: TextAlign.center,
              style:
                  Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}
