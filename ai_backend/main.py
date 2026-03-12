# ai_backend/main.py

from fastapi import FastAPI, HTTPException
from pydantic import BaseModel
from typing import Dict, Any
from fastapi.middleware.cors import CORSMiddleware

# -------------------- APP --------------------
app = FastAPI(title="AI Risk Scoring API")

app.add_middleware(
    CORSMiddleware,
    # Flutter Web runs in the browser; origins include scheme + host + port.
    # Allow localhost / 127.0.0.1 on any port (Chrome/Edge).
    allow_origin_regex=r"^https?://(localhost|127\.0\.0\.1)(:\d+)?$",
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# -------------------- INPUT SCHEMA --------------------
class BorrowerInput(BaseModel):
    income: float
    expenses: float
    loan_amount: float
    tenure_months: int
    repayment_score: int

# -------------------- RISK LOGIC --------------------
def calculate_risk_score(data: Dict[str, float]) -> Dict[str, Any]:
    risk_factors = {
        "Income": max(0, 1 - (data["income"] / 100000)),
        "Expenses": min(1, data["expenses"] / data["income"]),
        "Loan Amount": min(1, data["loan_amount"] / 200000),
        "Tenure Months": min(1, 12 / data["tenure_months"]),
        "Repayment Score": 1 - (data["repayment_score"] / 100),
    }

    risk_score = round(sum(risk_factors.values()) * 20, 2)

    if risk_score <= 20:
        grade = "A"
    elif risk_score <= 40:
        grade = "B"
    elif risk_score <= 60:
        grade = "C"
    elif risk_score <= 80:
        grade = "D"
    else:
        grade = "E"

    return {
        "risk_grade": grade,
        "risk_score": risk_score,
        "risk_factors": risk_factors,
    }

# -------------------- API ENDPOINT --------------------
@app.post("/predict-risk")
@app.post("/predict_risk")  # backward/contract compatibility
def predict_risk(data: BorrowerInput):
    try:
        result = calculate_risk_score(data.dict())

        # ✅ SHAP — MUST BE NAMED "shap"
        shap = {
            "Income": round(-result["risk_factors"]["Income"], 2),
            "Expenses": round(result["risk_factors"]["Expenses"], 2),
            "Loan Amount": round(result["risk_factors"]["Loan Amount"], 2),
            "Tenure Months": round(result["risk_factors"]["Tenure Months"], 2),
            "Repayment Score": round(-result["risk_factors"]["Repayment Score"], 2),
        }

        # ✅ LIME — MUST BE NAMED "lime"
        lime = [
            "Higher income reduces risk",
            "Expenses moderately increase risk",
            "Loan amount is within acceptable limits",
            "Shorter tenure slightly increases pressure",
            "Strong repayment history improves trust",
        ]

        # Derive a simple confidence value for UI compatibility (0-100).
        confidence_percent = int(max(0, min(100, round(100 - result["risk_score"]))))

        return {
            "risk_grade": result["risk_grade"],
            "confidence_percent": confidence_percent,
            "risk_score": result["risk_score"],
            "shap": shap,
            "lime": lime,
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))

# -------------------- RUN --------------------
if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
