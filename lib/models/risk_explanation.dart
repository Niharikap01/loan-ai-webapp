class RiskExplanation {
  final String factor;
  final double contributionScore;
  final String impactLevel;

  RiskExplanation({
    required this.factor,
    required this.contributionScore,
    required this.impactLevel,
  });

  factory RiskExplanation.fromJson(Map<String, dynamic> json) {
    return RiskExplanation(
      factor: json['factor'],
      contributionScore: (json['contribution_score'] as num).toDouble(),
      impactLevel: json['impact_level'],
    );
  }
}
