import numpy as np
from lime.lime_tabular import LimeTabularExplainer

FEATURES = [
    "income",
    "expenses",
    "loan_amount",
    "tenure_months",
    "repayment_score"
]

def get_lime_explanation(predict_fn, data: dict):
    training_data = np.random.rand(200, len(FEATURES))

    explainer = LimeTabularExplainer(
        training_data,
        feature_names=FEATURES,
        mode="regression"
    )

    instance = np.array([data[f] for f in FEATURES])

    explanation = explainer.explain_instance(
        instance,
        predict_fn,
        num_features=3
    )

    return [rule for rule, _ in explanation.as_list()]
