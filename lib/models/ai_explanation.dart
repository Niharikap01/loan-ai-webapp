class ShapItem {
  final String feature;
  final double impact;

  ShapItem({required this.feature, required this.impact});

  factory ShapItem.fromJson(Map<String, dynamic> json) {
    return ShapItem(
      feature: json['feature'],
      impact: (json['impact'] as num).toDouble(),
    );
  }
}

class AiExplanation {
  final List<ShapItem> shap;
  final List<String> lime;

  AiExplanation({required this.shap, required this.lime});

  factory AiExplanation.fromJson(Map<String, dynamic> json) {
    return AiExplanation(
      shap: (json['shap'] as List)
          .map((e) => ShapItem.fromJson(e))
          .toList(),
      lime: List<String>.from(json['lime']),
    );
  }
}
