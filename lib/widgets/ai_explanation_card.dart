import 'dart:ui';
import 'package:flutter/material.dart';
import '../models/ai_explanation.dart';

class AiExplanationCard extends StatelessWidget {
  final AiExplanation explanation;

  const AiExplanationCard({super.key, required this.explanation});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.35),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withOpacity(0.15)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Why this risk score?',
                style: Theme.of(context)
                    .textTheme
                    .titleMedium
                    ?.copyWith(color: Colors.white),
              ),
              const SizedBox(height: 16),

              /// SHAP
              const Text('Key Factors (SHAP)',
                  style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),

              ...explanation.shap.map((item) {
                final positive = item.impact >= 0;
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.feature,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ),
                      SizedBox(
                        width: 120,
                        child: LinearProgressIndicator(
                          value: item.impact.abs().clamp(0, 1),
                          backgroundColor: Colors.white12,
                          valueColor: AlwaysStoppedAnimation(
                            positive ? Colors.redAccent : Colors.greenAccent,
                          ),
                        ),
                      )
                    ],
                  ),
                );
              }),

              const SizedBox(height: 16),

              /// LIME
              const Text('Local Explanation (LIME)',
                  style: TextStyle(color: Colors.white70)),
              const SizedBox(height: 8),

              ...explanation.lime.map(
                (reason) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('• ', style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
