import 'package:flutter/material.dart';

void main() {
  runApp(const DynamicListViewApp());
}

class Student {
  final String name;
  final String registerNumber;
  final String department;

  const Student({
    required this.name,
    required this.registerNumber,
    required this.department,
  });
}

class DynamicListViewApp extends StatelessWidget {
  const DynamicListViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dynamic ListView',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: const StudentListScreen(),
    );
  }
}

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _registerController = TextEditingController();
  final _departmentController = TextEditingController();

  final List<Student> _students = [
    const Student(
      name: 'Arun Kumar',
      registerNumber: 'STU001',
      department: 'Computer Science',
    ),
    const Student(
      name: 'Priya Sharma',
      registerNumber: 'STU002',
      department: 'Information Technology',
    ),
    const Student(
      name: 'Rahul',
      registerNumber: 'STU003',
      department: 'Electronics',
    ),
  ];

  void _addStudent() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final name = _nameController.text.trim();
    final registerNumber = _registerController.text.trim();
    final department = _departmentController.text.trim();

    final alreadyExists = _students.any(
      (student) =>
          student.registerNumber.toLowerCase() ==
          registerNumber.toLowerCase(),
    );

    if (alreadyExists) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This register number already exists.'),
        ),
      );
      return;
    }

    setState(() {
      _students.insert(
        0,
        Student(
          name: name,
          registerNumber: registerNumber,
          department: department,
        ),
      );
    });

    _nameController.clear();
    _registerController.clear();
    _departmentController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Student added successfully!'),
      ),
    );
  }

  void _deleteStudent(int index) {
    final deletedStudent = _students[index];

    setState(() {
      _students.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${deletedStudent.name} removed successfully.'),
      ),
    );
  }

  String? _validateField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required Key fieldKey,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        key: fieldKey,
        controller: controller,
        validator: _validateField,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _registerController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dynamic ListView'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.groups,
                  size: 65,
                  color: Colors.indigo,
                ),
                const SizedBox(height: 10),
                const Text(
                  'Student Record Manager',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Add, view and remove student records dynamically.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),

                // Form for entering student details.
                Card(
                  elevation: 3,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Add Student Details',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 18),

                          _buildInputField(
                            label: 'Student Name',
                            controller: _nameController,
                            fieldKey: const ValueKey('studentName'),
                            icon: Icons.person,
                          ),

                          _buildInputField(
                            label: 'Register Number',
                            controller: _registerController,
                            fieldKey: const ValueKey('registerNumber'),
                            icon: Icons.badge,
                          ),

                          _buildInputField(
                            label: 'Department',
                            controller: _departmentController,
                            fieldKey: const ValueKey('department'),
                            icon: Icons.school,
                          ),

                          ElevatedButton.icon(
                            onPressed: _addStudent,
                            icon: const Icon(Icons.person_add),
                            label: const Text('Add Student'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.indigo,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.all(15),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Dynamic student list heading.
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Student Records',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Chip(
                      label: Text('${_students.length} Students'),
                      backgroundColor: Colors.indigo.shade50,
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                // ListView.builder dynamically generates list items.
                if (_students.isEmpty)
                  const Card(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 45,
                            color: Colors.grey,
                          ),
                          SizedBox(height: 10),
                          Text('No student records available.'),
                        ],
                      ),
                    ),
                  )
                else
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _students.length,
                    itemBuilder: (context, index) {
                      final student = _students[index];

                      return Card(
                        margin: const EdgeInsets.only(bottom: 10),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.indigo.shade100,
                            child: Text(
                              '${index + 1}',
                              style: const TextStyle(
                                color: Colors.indigo,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          title: Text(
                            student.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            'Register No: ${student.registerNumber}\n'
                            'Department: ${student.department}',
                          ),
                          isThreeLine: true,
                          trailing: IconButton(
                            key: ValueKey(
                              'delete-${student.registerNumber}',
                            ),
                            tooltip: 'Delete student',
                            onPressed: () => _deleteStudent(index),
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}