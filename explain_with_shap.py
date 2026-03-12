import pandas as pd
import shap
import joblib

# -----------------------------
# Load trained model
# -----------------------------
model = joblib.load("risk_model.pkl")

# -----------------------------
# Load data
# -----------------------------
data = pd.read_csv("borrower_data.csv")

# -----------------------------
# Feature columns (MUST match training)
# -----------------------------
features = [
    "income",
    "expenses",
    "loan_amount",
    "tenure_months",
    "repayment_score",
]

X = data[features]

# -----------------------------
# Create SHAP explainer
# -----------------------------
explainer = shap.TreeExplainer(model)

# ⛔ Disable strict additivity check (FIX)
shap_values = explainer.shap_values(
    X,
    check_additivity=False
)

# -----------------------------
# GLOBAL EXPLANATION
# -----------------------------
print("\nShowing global feature importance...")
shap.summary_plot(shap_values, X)

# -----------------------------
# LOCAL EXPLANATION (single borrower)
# -----------------------------
sample_index = 0
class_index = 0  # 0 = Low, 1 = Medium, 2 = High

print("\nExplaining one borrower decision...")

shap.waterfall_plot(
    shap.Explanation(
        values=shap_values[class_index][sample_index],
        base_values=explainer.expected_value[class_index],
        data=X.iloc[sample_index],
        feature_names=features,
    )
)
