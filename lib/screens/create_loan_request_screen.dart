import 'package:flutter/material.dart';

import '../app.dart';
import '../services/ai_risk_service.dart';
import '../widgets/risk_result_dialog.dart';

class CreateLoanRequestScreen extends StatefulWidget {
  const CreateLoanRequestScreen({super.key});

  @override
  State<CreateLoanRequestScreen> createState() =>
      _CreateLoanRequestScreenState();

}

class _CreateLoanRequestScreenState extends State<CreateLoanRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _incomeController = TextEditingController();
  final _expensesController = TextEditingController();
  final _loanAmountController = TextEditingController();
  final _tenureController = TextEditingController();
  final _repaymentScoreController = TextEditingController();

  bool _isLoading = false;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _incomeController.addListener(_validateForm);
    _expensesController.addListener(_validateForm);
    _loanAmountController.addListener(_validateForm);
    _tenureController.addListener(_validateForm);
    _repaymentScoreController.addListener(_validateForm);
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _expensesController.dispose();
    _loanAmountController.dispose();
    _tenureController.dispose();
    _repaymentScoreController.dispose();
    super.dispose();
  }

  void _validateForm() {
    final income = double.tryParse(_incomeController.text);
    final expenses = double.tryParse(_expensesController.text);
    final loanAmount = double.tryParse(_loanAmountController.text);
    final tenure = int.tryParse(_tenureController.text);
    final repaymentScore = int.tryParse(_repaymentScoreController.text);

    final isValid = _incomeController.text.isNotEmpty &&
        _expensesController.text.isNotEmpty &&
        _loanAmountController.text.isNotEmpty &&
        _tenureController.text.isNotEmpty &&
        _repaymentScoreController.text.isNotEmpty &&
        income != null &&
        income > 0 &&
        expenses != null &&
        expenses > 0 &&
        loanAmount != null &&
        loanAmount > 0 &&
        tenure != null &&
        tenure > 0 &&
        repaymentScore != null &&
        repaymentScore >= 0 &&
        repaymentScore <= 100;

    if (_isFormValid != isValid) {
      setState(() {
        _isFormValid = isValid;
      });
    }
  }

  Future<void> _submitForm() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await AiRiskService.predictRisk(
        income: double.parse(_incomeController.text),
        expenses: double.parse(_expensesController.text),
        loanAmount: double.parse(_loanAmountController.text),
        tenureMonths: int.parse(_tenureController.text),
        repaymentScore: int.parse(_repaymentScoreController.text),
      );

      if (!mounted) return;

      final riskGrade = (result['risk_grade'] ?? '').toString();
      final confidenceAny = result['confidence_percent'];
      final confidence = confidenceAny is num ? confidenceAny.toInt() : 0;
      if (riskGrade.isEmpty) {
        throw Exception('AI service returned no risk grade. Please try again.');
      }

      await showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => RiskResultDialog(
          riskGrade: riskGrade,
          confidence: confidence,
          onClose: () {
            Navigator.pop(context);
            Navigator.popUntil(
              context,
              ModalRoute.withName(AppRoutes.borrowerDashboard),
            );
          },
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // 🔴 TEMPORARY API TEST METHOD
  Future<void> _testApi() async {
    try {
      final result = await AiRiskService.predictRisk(
        income: 30000,
        expenses: 10000,
        loanAmount: 120000,
        tenureMonths: 24,
        repaymentScore: 70,
      );

      debugPrint('TEST API RESULT: $result');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'API OK → Risk: ${result['risk_grade']} (${result['confidence_percent']}%)',
          ),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      debugPrint('TEST API ERROR: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('API FAILED: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Loan Request')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Loan Request',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 32),

                        _NumberField(
                          controller: _incomeController,
                          label: 'Monthly Income',
                          prefix: '\$',
                        ),
                        const SizedBox(height: 20),
                        _NumberField(
                          controller: _expensesController,
                          label: 'Monthly Expenses',
                          prefix: '\$',
                        ),
                        const SizedBox(height: 20),
                        _NumberField(
                          controller: _loanAmountController,
                          label: 'Loan Amount',
                          prefix: '\$',
                        ),
                        const SizedBox(height: 20),
                        _IntegerField(
                          controller: _tenureController,
                          label: 'Loan Tenure',
                          suffix: 'months',
                        ),
                        const SizedBox(height: 20),
                        _IntegerField(
                          controller: _repaymentScoreController,
                          label: 'Repayment Score',
                          maxValue: 100,
                        ),

                        const SizedBox(height: 32),

                        // ✅ SUBMIT BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed:
                                _isFormValid && !_isLoading ? _submitForm : null,
                            child: _isLoading
                                ? const SizedBox(
                                    width: 22,
                                    height: 22,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                : const Text('Submit Request'),
                          ),
                        ),

                        const SizedBox(height: 12),

                        
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NumberField extends StatelessWidget {
  const _NumberField({
    required this.controller,
    required this.label,
    this.prefix,
  });

  final TextEditingController controller;
  final String label;
  final String? prefix;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: InputDecoration(labelText: label, prefixText: prefix),
      validator: (v) =>
          v == null || double.tryParse(v) == null ? 'Invalid number' : null,
    );
  }
}

class _IntegerField extends StatelessWidget {
  const _IntegerField({
    required this.controller,
    required this.label,
    this.suffix,
    this.maxValue,
  });

  final TextEditingController controller;
  final String label;
  final String? suffix;
  final int? maxValue;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label, suffixText: suffix),
      validator: (v) =>
          v == null || int.tryParse(v) == null ? 'Invalid number' : null,
    );
  }
}
