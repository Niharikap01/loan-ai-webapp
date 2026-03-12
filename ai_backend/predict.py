import numpy as np
from model import model

def predict_risk(features: dict):
    X = np.array([[ 
        features["income"],
        features["expenses"],
        features["loan_amount"],
        features["tenure_months"],
        features["repayment_score"]
    ]])

    probability = model.predict_proba(X)[0][1]

    if probability < 0.3:
        grade = "A"
    elif probability < 0.6:
        grade = "B"
    else:
        grade = "C"

    return grade, probability
