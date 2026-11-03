import 'package:flutter/material.dart';
import '../services/firestore_service.dart';

class BookSearchScreen extends StatefulWidget {
  const BookSearchScreen({super.key});

  @override
  State<BookSearchScreen> createState() => _BookSearchScreenState();
}

class _BookSearchScreenState extends State<BookSearchScreen> {
  final FirestoreService _service = FirestoreService();
  final TextEditingController _titleController = TextEditingController();

  Map<String, dynamic>? _book;
  bool _isLoading = false;
  String? _message;

  Future<void> _searchBook() async {
    final title = _titleController.text.trim();

    if (title.isEmpty) {
      setState(() {
        _book = null;
        _message = 'Please enter a book title.';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _book = null;
      _message = null;
    });

    try {
      final result = await _service.searchBook(title);

      if (!mounted) return;

      setState(() {
        _book = result;
        if (result == null) {
          _message = 'Book not found';
        }
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _message = 'Search failed. Check your connection and try again.';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final copies = _book?['copies'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Library Book Search'),
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
                  Icons.local_library,
                  size: 75,
                  color: Colors.teal,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Library Book Search System',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 28),

                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Enter Book Title',
                    hintText: 'Example: Flutter Programming',
                    prefixIcon: Icon(Icons.book),
                    border: OutlineInputBorder(),
                  ),
                  onSubmitted: (_) => _searchBook(),
                ),
                const SizedBox(height: 16),

                ElevatedButton.icon(
                  onPressed: _isLoading ? null : _searchBook,
                  icon: const Icon(Icons.search),
                  label: const Text('Search'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.all(15),
                  ),
                ),

                if (_isLoading) ...[
                  const SizedBox(height: 24),
                  const Center(child: CircularProgressIndicator()),
                ],

                if (_book != null) ...[
                  const SizedBox(height: 24),
                  Card(
                    elevation: 3,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
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
                          const SizedBox(height: 10),
                          Text('Author: ${_book!['author']}'),
                          const SizedBox(height: 10),
                          Text('Copies Available: $copies'),
                          if (copies == 0) ...[
                            const SizedBox(height: 16),
                            const Text(
                              'Not Available – All Copies Issued',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ],

                if (_message != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    _message!,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _message == 'Book not found'
                          ? Colors.red
                          : Colors.redAccent,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}