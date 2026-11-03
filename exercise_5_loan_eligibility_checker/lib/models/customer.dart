
class Customer {
  final String name;
  final int age;
  final double monthlySalary;
  final double existingEmi;
  final double loanRequested;

  static const double annualInterestRate = 0.10;
  static const int tenureYears = 5;

  const Customer({
    required this.name,
    required this.age,
    required this.monthlySalary,
    required this.existingEmi,
    required this.loanRequested,
  });

  double get monthlyInterestRate => annualInterestRate / 12;

  int get tenureMonths => tenureYears * 12;

  double get newEmi {
    final rate = monthlyInterestRate;
    final months = tenureMonths;

    if (rate == 0) return loanRequested / months;

    final factor = _power(1 + rate, months);

    return loanRequested * rate * factor / (factor - 1);
  }

  double _power(double base, int exponent) {
    double result = 1;
    for (int i = 0; i < exponent; i++) {
      result *= base;
    }
    return result;
  }

  double get dti =>
      ((existingEmi + newEmi) / monthlySalary) * 100;

  List<String> get eligibilityReasons {
    final reasons = <String>[];

    if (age < 21 || age > 60) {
      reasons.add('Age must be between 21 and 60 years.');
    }

    if (loanRequested > monthlySalary * 10) {
      reasons.add('Requested loan exceeds 10 times monthly salary.');
    }

    if (dti > 60) {
      reasons.add('Debt-to-Income Ratio exceeds 60%.');
    }

    return reasons;
  }

  bool get isEligible => eligibilityReasons.isEmpty;

  double get approvedAmount => isEligible ? loanRequested : 0;
}
