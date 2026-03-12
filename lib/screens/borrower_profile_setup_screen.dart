import 'package:flutter/material.dart';
import 'dart:ui';

import '../widgets/full_screen_background.dart';

class BorrowerProfileSetupScreen extends StatefulWidget {
  const BorrowerProfileSetupScreen({super.key});

  @override
  State<BorrowerProfileSetupScreen> createState() => _BorrowerProfileSetupScreenState();
}

class _BorrowerProfileSetupScreenState extends State<BorrowerProfileSetupScreen> {
  final _formKey = GlobalKey<FormState>();

  final _fullName = TextEditingController();
  final _country = TextEditingController();
  final _occupation = TextEditingController();

  final _income = TextEditingController();
  final _expenses = TextEditingController();
  final _employmentType = TextEditingController();

  final _preferredAmount = TextEditingController();
  final _preferredTenure = TextEditingController();

  @override
  void dispose() {
    _fullName.dispose();
    _country.dispose();
    _occupation.dispose();
    _income.dispose();
    _expenses.dispose();
    _employmentType.dispose();
    _preferredAmount.dispose();
    _preferredTenure.dispose();
    super.dispose();
  }

  String? _required(String? v) => (v == null || v.trim().isEmpty) ? 'Required' : null;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Profile Setup'),
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
                    constraints: BoxConstraints(minHeight: constraints.maxHeight),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 700),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                _GlassSection(
                                  title: 'Personal Details',
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _fullName,
                                        decoration: const InputDecoration(labelText: 'Full Name'),
                                        validator: _required,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        controller: _country,
                                        decoration: const InputDecoration(labelText: 'Country'),
                                        validator: _required,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        controller: _occupation,
                                        decoration: const InputDecoration(labelText: 'Occupation'),
                                        validator: _required,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _GlassSection(
                                  title: 'Income Details',
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _income,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        decoration: const InputDecoration(labelText: 'Monthly Income'),
                                        validator: _required,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        controller: _expenses,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        decoration: const InputDecoration(labelText: 'Monthly Expenses'),
                                        validator: _required,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        controller: _employmentType,
                                        decoration: const InputDecoration(labelText: 'Employment Type'),
                                        validator: _required,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 16),
                                _GlassSection(
                                  title: 'Loan Preference',
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _preferredAmount,
                                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                        decoration: const InputDecoration(labelText: 'Preferred Loan Amount'),
                                        validator: _required,
                                      ),
                                      const SizedBox(height: 12),
                                      TextFormField(
                                        controller: _preferredTenure,
                                        keyboardType: TextInputType.number,
                                        decoration: const InputDecoration(labelText: 'Preferred Tenure (months)'),
                                        validator: _required,
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  height: 48,
                                  child: FilledButton(
                                    onPressed: () {
                                      if (_formKey.currentState?.validate() ?? false) {
                                        Navigator.pop(context, true);
                                      }
                                    },
                                    child: const Text('Continue to Dashboard'),
                                  ),
                                ),
                                const SizedBox(height: 8),
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

class _GlassSection extends StatelessWidget {
  const _GlassSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 22, sigmaY: 22),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.20),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.10)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                      ),
                ),
                const SizedBox(height: 12),
                DefaultTextStyle.merge(
                  style: const TextStyle(color: Colors.white),
                  child: child,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
