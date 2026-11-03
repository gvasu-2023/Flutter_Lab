
import 'package:flutter/material.dart';
import '../models/customer.dart';

class ResultScreen extends StatelessWidget {
  final Customer customer;

  const ResultScreen({super.key, required this.customer});

  Widget _detail(String label, String value) {
    return ListTile(
      dense: true,
      title: Text(label),
      trailing: Text(
        value,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final eligible = customer.isEligible;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Eligibility Result'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    const Text(
                      'Customer Details',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _detail('Name', customer.name),
                    _detail('Age', '${customer.age} years'),
                    _detail(
                      'Monthly Salary',
                      '₹${customer.monthlySalary.toStringAsFixed(2)}',
                    ),
                    _detail(
                      'Existing EMI / Debts',
                      '₹${customer.existingEmi.toStringAsFixed(2)}',
                    ),
                    _detail(
                      'Loan Requested',
                      '₹${customer.loanRequested.toStringAsFixed(2)}',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: eligible ? Colors.green.shade50 : Colors.red.shade50,
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Icon(
                      eligible ? Icons.check_circle : Icons.cancel,
                      size: 55,
                      color: eligible ? Colors.green : Colors.red,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      eligible ? 'LOAN ELIGIBLE' : 'NOT ELIGIBLE',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: eligible ? Colors.green.shade800 : Colors.red,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _detail(
                      'New Monthly EMI',
                      '₹${customer.newEmi.toStringAsFixed(2)}',
                    ),
                    _detail(
                      'Debt-to-Income Ratio',
                      '${customer.dti.toStringAsFixed(2)}%',
                    ),
                    if (eligible) ...[
                      _detail(
                        'Approved Loan Amount',
                        '₹${customer.approvedAmount.toStringAsFixed(2)}',
                      ),
                      _detail(
                        'Interest Rate',
                        '10% per annum',
                      ),
                      _detail(
                        'Loan Tenure',
                        '5 years (60 months)',
                      ),
                    ] else ...[
                      const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Reasons for rejection:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      ...customer.eligibilityReasons.map(
                        (reason) => ListTile(
                          dense: true,
                          leading: const Icon(
                            Icons.warning,
                            color: Colors.red,
                          ),
                          title: Text(reason),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushNamedAndRemoveUntil(
                  context,
                  '/',
                  (route) => false,
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('Reset / Check Another Customer'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.indigo,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
