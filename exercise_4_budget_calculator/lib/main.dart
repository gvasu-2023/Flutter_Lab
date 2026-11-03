
import 'package:flutter/material.dart';

void main() {
  runApp(const BudgetCalculatorApp());
}

class BudgetCalculatorApp extends StatelessWidget {
  const BudgetCalculatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Budget Calculator',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
        useMaterial3: true,
      ),
      home: const BudgetCalculatorScreen(),
    );
  }
}

class BudgetCalculatorScreen extends StatefulWidget {
  const BudgetCalculatorScreen({super.key});

  @override
  State<BudgetCalculatorScreen> createState() =>
      _BudgetCalculatorScreenState();
}

class _BudgetCalculatorScreenState extends State<BudgetCalculatorScreen> {
  final _formKey = GlobalKey<FormState>();

  final _incomeController = TextEditingController();
  final _rentController = TextEditingController();
  final _foodController = TextEditingController();
  final _transportController = TextEditingController();
  final _otherController = TextEditingController();

  double? _remainingBalance;

  String? _validateIncome(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your monthly income';
    }

    final amount = double.tryParse(value.trim());

    if (amount == null || !amount.isFinite || amount <= 0) {
      return 'Enter a valid positive amount';
    }

    return null;
  }

  String? _validateExpense(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter this expense';
    }

    final amount = double.tryParse(value.trim());

    if (amount == null || !amount.isFinite || amount < 0) {
      return 'Enter a valid non-negative amount';
    }

    return null;
  }

  void _calculateBalance() {
    if (!_formKey.currentState!.validate()) {
      setState(() {
        _remainingBalance = null;
      });
      return;
    }

    final income = double.parse(_incomeController.text.trim());
    final rent = double.parse(_rentController.text.trim());
    final food = double.parse(_foodController.text.trim());
    final transport = double.parse(_transportController.text.trim());
    final other = double.parse(_otherController.text.trim());

    final balance = income - (rent + food + transport + other);

    setState(() {
      _remainingBalance = balance;
    });
  }

  void _resetForm() {
    _formKey.currentState?.reset();

    _incomeController.clear();
    _rentController.clear();
    _foodController.clear();
    _transportController.clear();
    _otherController.clear();

    setState(() {
      _remainingBalance = null;
    });
  }

  @override
  void dispose() {
    _incomeController.dispose();
    _rentController.dispose();
    _foodController.dispose();
    _transportController.dispose();
    _otherController.dispose();
    super.dispose();
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: const TextInputType.numberWithOptions(decimal: true),
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          prefixText: '₹ ',
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isOverspending =
        _remainingBalance != null && _remainingBalance! < 0;

    final isBalanced =
        _remainingBalance != null && _remainingBalance == 0;

    final resultColor = isOverspending ? Colors.red : Colors.green;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Budget Calculator'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Icon(
                Icons.account_balance_wallet,
                size: 65,
                color: Colors.indigo,
              ),
              const SizedBox(height: 12),
              const Text(
                'Monthly Budget Planner',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your monthly income and expenses to calculate your remaining balance.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),

              _buildInputField(
                label: 'Monthly Income',
                controller: _incomeController,
                validator: _validateIncome,
                icon: Icons.account_balance,
              ),
              _buildInputField(
                label: 'Rent / EMI',
                controller: _rentController,
                validator: _validateExpense,
                icon: Icons.home,
              ),
              _buildInputField(
                label: 'Food Expenses',
                controller: _foodController,
                validator: _validateExpense,
                icon: Icons.restaurant,
              ),
              _buildInputField(
                label: 'Transport Expenses',
                controller: _transportController,
                validator: _validateExpense,
                icon: Icons.directions_bus,
              ),
              _buildInputField(
                label: 'Other Expenses',
                controller: _otherController,
                validator: _validateExpense,
                icon: Icons.shopping_bag,
              ),

              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _calculateBalance,
                icon: const Icon(Icons.calculate),
                label: const Text('Calculate Balance'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),

              if (_remainingBalance != null) ...[
                const SizedBox(height: 24),
                Card(
                  color: isOverspending
                      ? Colors.red.shade50
                      : Colors.green.shade50,
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          isOverspending
                              ? Icons.warning_rounded
                              : Icons.check_circle,
                          color: resultColor,
                          size: 45,
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Remaining Balance',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '₹${_remainingBalance!.toStringAsFixed(2)}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: resultColor,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          isOverspending
                              ? 'You are overspending!'
                              : isBalanced
                                  ? 'Your income and expenses are balanced.'
                                  : 'Good job! You have money remaining.',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: resultColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _resetForm,
                icon: const Icon(Icons.refresh),
                label: const Text('Reset'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.all(14),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
