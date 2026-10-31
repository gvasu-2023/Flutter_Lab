import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({super.key});

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final FirestoreService _firestoreService = FirestoreService();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _copiesController = TextEditingController();

  Map<String, dynamic>? _book;
  bool _isLoading = false;

  Future<void> _searchBook() async {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      _showMessage('Please enter a book title.');
      return;
    }

    setState(() {
      _isLoading = true;
      _book = null;
      _copiesController.clear();
    });

    try {
      final result = await _firestoreService.searchBook(title);

      if (!mounted) return;

      setState(() {
        _book = result;
        if (result != null) {
          _copiesController.text = result['copies'].toString();
        }
      });

      if (result == null) {
        _showMessage('Book not found.');
      }
    } catch (e) {
      if (mounted) {
        _showMessage('Search failed: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _updateBook() async {
    if (_book == null) return;

    final copies = int.tryParse(_copiesController.text.trim());

    if (copies == null || copies < 0) {
      _showMessage('Enter a valid non-negative whole number.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _firestoreService.updateCopies(
        _book!['documentId'],
        copies,
      );

      if (!mounted) return;

      setState(() {
        _book!['copies'] = copies;
      });

      _showMessage('Book copies updated successfully.');
    } catch (e) {
      if (mounted) {
        _showMessage('Update failed: $e');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _copiesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Book Copies'),
        backgroundColor: Colors.teal,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 500),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.menu_book,
                  size: 70,
                  color: Colors.teal,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Library Book Management',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 24),

                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Book Title',
                    hintText: 'Enter the exact book title',
                    prefixIcon: Icon(Icons.book),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _searchBook,
                  icon: const Icon(Icons.search),
                  label: const Text('Search Book'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(15),
                  ),
                ),

                if (_book != null) ...[
                  const SizedBox(height: 28),
                  Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Book Details',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(),
                          Text('Title: ${_book!['title']}'),
                          const SizedBox(height: 8),
                          Text('Author: ${_book!['author']}'),
                          const SizedBox(height: 8),
                          Text('Available Copies: ${_book!['copies']}'),
                          const SizedBox(height: 20),

                          TextField(
                            controller: _copiesController,
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: 'Updated Copies',
                              prefixIcon: Icon(Icons.numbers),
                              border: OutlineInputBorder(),
                            ),
                          ),
                          const SizedBox(height: 16),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              onPressed:
                                  _isLoading ? null : _updateBook,
                              icon: const Icon(Icons.update),
                              label: const Text('Update Copies'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.all(15),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                if (_isLoading) ...[
                  const SizedBox(height: 20),
                  const Center(child: CircularProgressIndicator()),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}