import joblib

# load trained model
model = joblib.load("model.pkl")

FEATURE_NAMES = [
    "income",
    "expenses",
    "loan_amount",
    "tenure_months",
    "repayment_score"
]
