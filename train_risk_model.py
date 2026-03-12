import pandas as pd
from sklearn.model_selection import train_test_split
from sklearn.ensemble import RandomForestClassifier
from sklearn.preprocessing import LabelEncoder
import joblib

# Load dataset
data = pd.read_csv("borrower_data.csv")

features = [
    "income",
    "expenses",
    "loan_amount",
    "tenure_months",
    "repayment_score"
]

X = data[features]
y = data["risk_grade"]

# Encode labels
label_encoder = LabelEncoder()
y_encoded = label_encoder.fit_transform(y)

# Train model
model = RandomForestClassifier(
    n_estimators=200,
    random_state=42
)

model.fit(X, y_encoded)

# Save model and encoder
joblib.dump(model, "risk_model.pkl")
joblib.dump(label_encoder, "label_encoder.pkl")

print("✅ Model trained and saved successfully")
