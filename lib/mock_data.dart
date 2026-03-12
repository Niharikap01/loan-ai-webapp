import 'models/loan_request.dart';

final List<LoanRequest> borrowerLoanRequests = [
  LoanRequest(
    borrowerName: 'Amara Lee',
    purpose: 'Grow small retail shop',
    amount: 8000,
    durationMonths: 12,
    status: LoanStatus.pending,
    riskGrade: RiskGrade.a,
    income: 60000,
    expenses: 30000,
repaymentScore: 85,
tenureMonths: 24,

  ),
  LoanRequest(
    borrowerName: 'Daniel Mensah',
    purpose: 'Purchase delivery bike',
    amount: 3500,
    durationMonths: 10,
    status: LoanStatus.partiallyFunded,
    riskGrade: RiskGrade.b,
    income: 60000,
    expenses: 30000,
repaymentScore: 85,
tenureMonths: 24,

  ),
  LoanRequest(
    borrowerName: 'Lina Alvarez',
    purpose: 'Inventory for bakery',
    amount: 5000,
    durationMonths: 14,
    status: LoanStatus.funded,
    riskGrade: RiskGrade.c,
    income: 60000,
    expenses: 30000,
repaymentScore: 85,
tenureMonths: 24,

  ),
  LoanRequest(
    borrowerName: 'Niran Patel',
    purpose: 'Refinance equipment purchase',
    amount: 6200,
    durationMonths: 12,
    status: LoanStatus.repaid,
    riskGrade: RiskGrade.b,
    income: 60000,
    expenses: 30000,
    repaymentScore: 85,
    tenureMonths: 24,

  ),
];

final List<LoanRequest> activeLoanRequests = [
  LoanRequest(
    borrowerName: 'Kwesi Boateng',
    purpose: 'Expand mobile money kiosk',
    amount: 4200,
    durationMonths: 9,
    status: LoanStatus.pending,
    riskGrade: RiskGrade.a,
    income: 60000,
    expenses: 30000,
    repaymentScore: 85,
    tenureMonths: 24,

  ),
  LoanRequest(
    borrowerName: 'Mary Okoro',
    purpose: 'Add solar panels to clinic',
    amount: 12000,
    durationMonths: 18,
    status: LoanStatus.partiallyFunded,
    riskGrade: RiskGrade.b,
    income: 60000,
    expenses: 30000,
    repaymentScore: 85,
    tenureMonths: 24,

  ),
  LoanRequest(
    borrowerName: 'Issa Diallo',
    purpose: 'Scale agritech inputs',
    amount: 7000,
    durationMonths: 12,
    status: LoanStatus.pending,
    riskGrade: RiskGrade.c,
    income: 60000,
expenses: 30000,
repaymentScore: 85,
tenureMonths: 24,

  ),
];
