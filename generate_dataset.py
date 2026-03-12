import random
import pandas as pd

data = []

for _ in range(500):  # 500 borrowers
    income = random.randint(10000, 80000)
    expenses = random.randint(5000, min(60000, income))
    loan_amount = random.randint(5000, 100000)
    tenure_months = random.choice([6, 9, 12, 18, 24])
    repayment_score = round(random.uniform(0.0, 1.0), 2)

    # Risk logic
    if repayment_score >= 0.8 and income > expenses:
        risk = 'A'
    elif repayment_score >= 0.5:
        risk = 'B'
    else:
        risk = 'C'

    data.append([
        income,
        expenses,
        loan_amount,
        tenure_months,
        repayment_score,
        risk
    ])

columns = [
    'income',
    'expenses',
    'loan_amount',
    'tenure_months',
    'repayment_score',
    'risk_grade'
]

df = pd.DataFrame(data, columns=columns)
df.to_csv('borrower_data.csv', index=False)

print("Dataset created: borrower_data.csv")
