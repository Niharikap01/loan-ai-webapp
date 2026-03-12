import 'package:flutter/material.dart';

import 'mock_data.dart';
import 'models/loan_request.dart';
import 'screens/borrower_dashboard.dart';
import 'screens/create_loan_request_screen.dart';
import 'screens/home_screen.dart';
import 'screens/lender_dashboard.dart';
import 'screens/loan_details_screen.dart';
import 'theme/app_theme.dart';

class AppRoutes {
  static const home = '/';
  static const borrowerDashboard = '/borrower';
  static const createLoanRequest = '/borrower/create';
  static const lenderDashboard = '/lender';
  static const loanDetails = '/loan';
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Microloan Marketplace',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      initialRoute: AppRoutes.home,
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case AppRoutes.home:
            return MaterialPageRoute(builder: (_) => const HomeScreen());
          case AppRoutes.borrowerDashboard:
            return MaterialPageRoute(
              builder: (_) => BorrowerDashboardScreen(
                loanRequests: borrowerLoanRequests,
              ),
            );
          case AppRoutes.createLoanRequest:
            return MaterialPageRoute(
              builder: (_) => const CreateLoanRequestScreen(),
            );
          case AppRoutes.lenderDashboard:
            return MaterialPageRoute(
              builder: (_) => LenderDashboardScreen(
                loanRequests: activeLoanRequests,
              ),
            );
          case AppRoutes.loanDetails:
            final loan = settings.arguments as LoanRequest?;
            return MaterialPageRoute(
              builder: (_) => LoanDetailsScreen(loanRequest: loan),
            );
          default:
            return MaterialPageRoute(
              builder: (_) => Scaffold(
                appBar: AppBar(title: const Text('Page Not Found')),
                body: const Center(
                  child: Text('The requested page could not be found.'),
                ),
              ),
            );
        }
      },
    );
  }
}
