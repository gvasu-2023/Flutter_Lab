import 'package:flutter/material.dart';

import '../models/student.dart';
import '../services/student_repository.dart';

class StudentScreen extends StatefulWidget {
  final StudentRepository? repository;

  const StudentScreen({super.key, this.repository});

  @override
  State<StudentScreen> createState() => _StudentScreenState();
}

class _StudentScreenState extends State<StudentScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _registerController = TextEditingController();
  final _departmentController = TextEditingController();

  late final StudentRepository _repository;
  late final Stream<List<Student>> _studentsStream;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();

    _repository = widget.repository ?? FirestoreStudentRepository();
    _studentsStream = _repository.watchStudents();
  }

  String? _validateField(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }

    return null;
  }

  Future<void> _addStudent() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final student = Student(
      name: _nameController.text.trim(),
      registerNumber: _registerController.text.trim().toUpperCase(),
      department: _departmentController.text.trim(),
    );

    setState(() {
      _isSaving = true;
    });

    try {
      final exists = await _repository.registerNumberExists(
        student.registerNumber,
      );

      if (!mounted) return;

      if (exists) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Register number already exists.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      await _repository.addStudent(student);

      if (!mounted) return;

      _nameController.clear();
      _registerController.clear();
      _departmentController.clear();
      _formKey.currentState!.reset();

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Student saved to Firestore successfully!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to save student: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSaving = false;
        });
      }
    }
  }

  Widget _buildInputField({
    required String label,
    required TextEditingController controller,
    required String fieldKey,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        key: ValueKey(fieldKey),
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
        title: const Text('Firestore Student Records'),
        centerTitle: true,
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(Icons.cloud, size: 65, color: Colors.teal),
                const SizedBox(height: 10),
                const Text(
                  'Student Record Management',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Store and retrieve student information using Google Firestore.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                const SizedBox(height: 24),

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
                            'Enter Student Details',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 18),

                          _buildInputField(
                            label: 'Student Name',
                            controller: _nameController,
                            fieldKey: 'studentName',
                            icon: Icons.person,
                          ),

                          _buildInputField(
                            label: 'Register Number',
                            controller: _registerController,
                            fieldKey: 'registerNumber',
                            icon: Icons.badge,
                          ),

                          _buildInputField(
                            label: 'Department',
                            controller: _departmentController,
                            fieldKey: 'department',
                            icon: Icons.school,
                          ),

                          ElevatedButton.icon(
                            key: const ValueKey('saveStudentButton'),
                            onPressed: _isSaving ? null : _addStudent,
                            icon: _isSaving
                                ? const SizedBox(
                                    height: 18,
                                    width: 18,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.white,
                                    ),
                                  )
                                : const Icon(Icons.cloud_upload),
                            label: Text(
                              _isSaving ? 'Saving...' : 'Save Student',
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.teal,
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

                const Text(
                  'Stored Student Records',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 12),

                StreamBuilder<List<Student>>(
                  stream: _studentsStream,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Text(
                            'Unable to retrieve records: ${snapshot.error}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        ),
                      );
                    }

                    if (snapshot.connectionState == ConnectionState.waiting &&
                        !snapshot.hasData) {
                      return const Padding(
                        padding: EdgeInsets.all(25),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }

                    final students = snapshot.data ?? [];

                    if (students.isEmpty) {
                      return const Card(
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
                              Text('No student records found.'),
                              Text(
                                'Add a student to see the record here.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      );
                    }

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Align(
                          alignment: Alignment.centerRight,
                          child: Chip(
                            label: Text('${students.length} Students'),
                            backgroundColor: Colors.teal.shade50,
                          ),
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: students.length,
                          itemBuilder: (context, index) {
                            final student = students[index];

                            return Card(
                              key: ValueKey(student.registerNumber),
                              margin: const EdgeInsets.only(bottom: 10),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.teal.shade100,
                                  child: Text('${index + 1}'),
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
                                trailing: const Icon(
                                  Icons.cloud_done,
                                  color: Colors.green,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
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
