class Student {
  final String name;
  final String registerNumber;
  final String department;

  const Student({
    required this.name,
    required this.registerNumber,
    required this.department,
  });

  factory Student.fromMap(Map<String, dynamic> data) {
    return Student(
      name: data['name'] as String? ?? '',
      registerNumber: data['registerNumber'] as String? ?? '',
      department: data['department'] as String? ?? '',
    );
  }
}
