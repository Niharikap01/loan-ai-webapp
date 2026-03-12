import 'package:flutter/material.dart';
import '../services/risk_api_service.dart';
import '../widgets/ambient_background.dart';

class BorrowerResultScreen extends StatefulWidget {
  const BorrowerResultScreen({super.key});

  @override
  State<BorrowerResultScreen> createState() => _BorrowerResultScreenState();
}

class _BorrowerResultScreenState extends State<BorrowerResultScreen> {
  String? riskGrade;
  int? confidence;
  bool loading = false;

  void getRiskScore() async {
    setState(() => loading = true);

    try {
      final result = await RiskApiService.predictRisk(
        income: 50000,
        expenses: 20000,
        loanAmount: 100000,
        tenureMonths: 12,
        repaymentScore: 8,
      );

      setState(() {
        riskGrade = result['risk_grade'];
        confidence = result['confidence_percent'];
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error fetching risk score")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: AppBar(title: const Text("Risk Assessment")),
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
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: loading ? null : getRiskScore,
                              child: const Text("Check Risk"),
                            ),

                            const SizedBox(height: 20),

                            if (loading) const CircularProgressIndicator(),

                            if (riskGrade != null) ...[
                              Text(
                                "Risk Grade: $riskGrade",
                                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Confidence: $confidence%",
                                style: const TextStyle(fontSize: 18),
                              ),
                            ]
                          ],
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
