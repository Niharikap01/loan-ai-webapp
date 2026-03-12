import shap
import numpy as np

FEATURES = [
    "income",
    "expenses",
    "loan_amount",
    "tenure_months",
    "repayment_score"
]

# -------------------------
# Prediction function (acts like a model)
# -------------------------
def risk_model(X):
    """
    X shape: (n_samples, n_features)
    Returns risk probability
    """
    income = X[:, 0]
    expenses = X[:, 1]
    loan_amount = X[:, 2]
    tenure = X[:, 3]
    repayment = X[:, 4]

    score = (
        0.00002 * loan_amount
        - 0.00001 * income
        + 0.00002 * expenses
        - 0.01 * tenure
        - 0.02 * repayment
    )

    return score.reshape(-1, 1)

# -------------------------
# SHAP explanation
# -------------------------
def get_shap_explanation(data: dict):
    X = np.array([[data[f] for f in FEATURES]])

    explainer = shap.Explainer(risk_model, X)
    shap_values = explainer(X)

    explanations = []
    for i, feature in enumerate(FEATURES):
        explanations.append({
            "feature": feature.replace("_", " ").title(),
            "impact": round(float(shap_values.values[0][i]), 4)
        })

    return explanations
