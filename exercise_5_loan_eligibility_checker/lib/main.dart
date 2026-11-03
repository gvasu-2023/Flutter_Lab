
import 'package:flutter/material.dart';
import 'screens/input_screen.dart';
import 'screens/result_screen.dart';
import 'models/customer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LoanEligibilityApp());
}

class LoanEligibilityApp extends StatelessWidget {
  const LoanEligibilityApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Loan Eligibility Checker',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const InputScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/result') {
          final customer = settings.arguments as Customer;
          return MaterialPageRoute(
            builder: (context) => ResultScreen(customer: customer),
            settings: settings,
          );
        }
        return null;
      },
    );
  }
}
