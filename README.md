# Peer-to-Peer Microloan Marketplace with AI Risk Scoring

A full-stack fintech web application that connects borrowers with community lenders through a transparent peer-to-peer microloan platform.  
An AI-based risk scoring engine evaluates borrower profiles and assigns risk grades (A/B/C) to help lenders make informed funding decisions.

## Features

### Borrower Dashboard
- Create borrower profile
- Submit loan requests
- Track loan application status

### Lender Dashboard
- Browse borrower loan requests
- View borrower profiles
- Partially or fully fund loans

### AI Risk Scoring
- Machine learning model evaluates borrower data
- Assigns risk grades:
  - A → Low Risk
  - B → Medium Risk
  - C → High Risk
- Explainable AI insights for transparency

## Tech Stack

Frontend: Flutter Web  
Backend: FastAPI  
Machine Learning: Python (Scikit-learn)  
API Server: Uvicorn  
Version Control: Git + GitHub  

## Project Structure

loan-ai-webapp
│
├── ai_backend
│   ├── main.py
│   └── model.py
│
├── lib
│   ├── screens
│   ├── services
│   └── widgets
│
├── web
└── pubspec.yaml

## Run Backend

cd ai_backend  
pip install -r requirements.txt  
uvicorn main:app --reload  

## Run Frontend

flutter pub get  
flutter run -d chrome  

## Author

Niharika  
GitHub: https://github.com/Niharikap01
