import 'package:flutter/material.dart';

class BorrowerLoanForm extends StatefulWidget {
  const BorrowerLoanForm({super.key});

  @override
  State<BorrowerLoanForm> createState() => _BorrowerLoanFormState();
}

class _BorrowerLoanFormState extends State<BorrowerLoanForm> {
  final _formKey = GlobalKey<FormState>();

  String _purpose = 'Education';
  final _amountController = TextEditingController();
  final _incomeController = TextEditingController();
  final _durationController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _incomeController.dispose();
    _durationController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text('Loan Request Form'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Request a Loan',
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Fill in accurate details to help lenders make informed decisions.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 32),

                  // Purpose
                  DropdownButtonFormField<String>(
                    value: _purpose,
                    decoration: const InputDecoration(
                      labelText: 'Loan Purpose',
                      border: OutlineInputBorder(),
                    ),
                    items: const [
                      DropdownMenuItem(
                        value: 'Education',
                        child: Text('Education'),
                      ),
                      DropdownMenuItem(
                        value: 'Healthcare',
                        child: Text('Healthcare'),
                      ),
                      DropdownMenuItem(
                        value: 'Small Business',
                        child: Text('Small Business'),
                      ),
                      DropdownMenuItem(
                        value: 'Personal',
                        child: Text('Personal'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _purpose = value!;
                      });
                    },
                  ),

                  const SizedBox(height: 20),

                  // Amount
                  TextFormField(
                    controller: _amountController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Requested Amount (₹)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter loan amount';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Income
                  TextFormField(
                    controller: _incomeController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Monthly Income (₹)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter monthly income';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Duration
                  TextFormField(
                    controller: _durationController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Loan Duration (months)',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter duration';
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  // Notes
                  TextFormField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Additional Notes (optional)',
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Submit
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Loan request submitted successfully'),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      },
                      child: const Text('Submit Loan Request'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
