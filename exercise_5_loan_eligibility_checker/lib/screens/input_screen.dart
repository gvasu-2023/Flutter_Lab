
import 'package:flutter/material.dart';
import '../models/customer.dart';

class InputScreen extends StatefulWidget {
  const InputScreen({super.key});

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _ageController = TextEditingController();
  final _salaryController = TextEditingController();
  final _emiController = TextEditingController();
  final _loanController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _salaryController.dispose();
    _emiController.dispose();
    _loanController.dispose();
    super.dispose();
  }

  String? _required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? _positiveNumber(String? value) {
    final requiredError = _required(value);
    if (requiredError != null) return requiredError;

    final number = double.tryParse(value!.trim());
    if (number == null || !number.isFinite || number <= 0) {
      return 'Enter a valid positive number';
    }
    return null;
  }

  String? _nonNegativeNumber(String? value) {
    final requiredError = _required(value);
    if (requiredError != null) return requiredError;

    final number = double.tryParse(value!.trim());
    if (number == null || !number.isFinite || number < 0) {
      return 'Enter a valid non-negative number';
    }
    return null;
  }

  String? _ageValidator(String? value) {
    final requiredError = _required(value);
    if (requiredError != null) return requiredError;

    final age = int.tryParse(value!.trim());
    if (age == null || age < 1 || age > 120) {
      return 'Enter a realistic age';
    }
    return null;
  }

  void _checkEligibility() {
    if (!_formKey.currentState!.validate()) return;

    final customer = Customer(
      name: _nameController.text.trim(),
      age: int.parse(_ageController.text.trim()),
      monthlySalary: double.parse(_salaryController.text.trim()),
      existingEmi: double.parse(_emiController.text.trim()),
      loanRequested: double.parse(_loanController.text.trim()),
    );

    Navigator.pushNamed(
      context,
      '/result',
      arguments: customer,
    );
  }

  Widget _buildField({
    required String label,
    required TextEditingController controller,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    IconData? icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon == null ? null : Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Eligibility Checker'),
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
                Icons.account_balance,
                size: 65,
                color: Colors.indigo,
              ),
              const SizedBox(height: 12),
              const Text(
                'Customer Details Form',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 23,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),

              _buildField(
                label: 'Customer Name',
                controller: _nameController,
                validator: _required,
                icon: Icons.person,
              ),
              _buildField(
                label: 'Age',
                controller: _ageController,
                validator: _ageValidator,
                keyboardType: TextInputType.number,
                icon: Icons.calendar_today,
              ),
              _buildField(
                label: 'Monthly Salary (₹)',
                controller: _salaryController,
                validator: _positiveNumber,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                icon: Icons.currency_rupee,
              ),
              _buildField(
                label: 'Existing EMI / Debts (₹)',
                controller: _emiController,
                validator: _nonNegativeNumber,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                icon: Icons.payments,
              ),
              _buildField(
                label: 'Loan Amount Requested (₹)',
                controller: _loanController,
                validator: _positiveNumber,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                icon: Icons.account_balance_wallet,
              ),

              const SizedBox(height: 8),
              ElevatedButton.icon(
                onPressed: _checkEligibility,
                icon: const Icon(Icons.calculate),
                label: const Text('Check Loan Eligibility'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(16),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Eligibility criteria: Age 21–60, loan up to 10× monthly salary, and DTI not exceeding 60%.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
