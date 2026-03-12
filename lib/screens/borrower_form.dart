import 'package:flutter/material.dart';

class BorrowerFormScreen extends StatefulWidget {
  const BorrowerFormScreen({super.key});

  @override
  State<BorrowerFormScreen> createState() => _BorrowerFormScreenState();
}

class _BorrowerFormScreenState extends State<BorrowerFormScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController incomeController = TextEditingController();
  final TextEditingController expensesController = TextEditingController();
  final TextEditingController loanAmountController = TextEditingController();
  final TextEditingController tenureController = TextEditingController();
  final TextEditingController repaymentScoreController = TextEditingController();

  @override
  void dispose() {
    incomeController.dispose();
    expensesController.dispose();
    loanAmountController.dispose();
    tenureController.dispose();
    repaymentScoreController.dispose();
    super.dispose();
  }

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      // For now just print values
      print("Income: ${incomeController.text}");
      print("Expenses: ${expensesController.text}");
      print("Loan Amount: ${loanAmountController.text}");
      print("Tenure: ${tenureController.text}");
      print("Repayment Score: ${repaymentScoreController.text}");

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Form validated successfully")),
      );
    }
  }

  InputDecoration inputStyle(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Borrower Details"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [

              TextFormField(
                controller: incomeController,
                keyboardType: TextInputType.number,
                decoration: inputStyle("Monthly Income"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter income";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: expensesController,
                keyboardType: TextInputType.number,
                decoration: inputStyle("Monthly Expenses"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter expenses";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: loanAmountController,
                keyboardType: TextInputType.number,
                decoration: inputStyle("Loan Amount"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter loan amount";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: tenureController,
                keyboardType: TextInputType.number,
                decoration: inputStyle("Tenure (Months)"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter tenure";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 15),

              TextFormField(
                controller: repaymentScoreController,
                keyboardType: TextInputType.number,
                decoration: inputStyle("Repayment Score (0–100)"),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Enter repayment score";
                  }
                  final score = int.tryParse(value);
                  if (score == null || score < 0 || score > 100) {
                    return "Score must be between 0 and 100";
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: submitForm,
                  child: const Text("Check Risk"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
