
import 'package:flutter/material.dart';
import 'database_helper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const BankAccountApp());
}

class BankAccountApp extends StatelessWidget {
  final AccountStore? store;

  const BankAccountApp({
    super.key,
    this.store,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bank Account Manager',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.indigo,
        ),
        useMaterial3: true,
      ),
      home: BankAccountScreen(store: store),
    );
  }
}

class BankAccountScreen extends StatefulWidget {
  final AccountStore? store;

  const BankAccountScreen({
    super.key,
    this.store,
  });

  @override
  State<BankAccountScreen> createState() =>
      _BankAccountScreenState();
}

class _BankAccountScreenState extends State<BankAccountScreen> {
  final TextEditingController _nameController =
      TextEditingController();

  final TextEditingController _balanceController =
      TextEditingController();

  late final AccountStore _store;

  List<Map<String, dynamic>> _accounts = [];
  double _totalBalance = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();

    _store = widget.store ?? DatabaseHelper.instance;

    _loadAccounts();
  }

  Future<void> _loadAccounts() async {
    try {
      final accounts = await _store.getAccounts();
      final total = await _store.getTotalBalance();

      if (!mounted) return;

      setState(() {
        _accounts = accounts;
        _totalBalance = total;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to load accounts: $e'),
        ),
      );
    }
  }

  Future<void> _saveAccount() async {
    final name = _nameController.text.trim();

    final balance = double.tryParse(
      _balanceController.text.trim(),
    );

    if (name.isEmpty || balance == null || balance < 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Enter a valid account holder name and balance.',
          ),
        ),
      );
      return;
    }

    try {
      await _store.insertAccount({
        'accountHolder': name,
        'balance': balance,
      });

      _nameController.clear();
      _balanceController.clear();

      await _loadAccounts();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Account saved successfully!'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Unable to save account: $e'),
        ),
      );
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bank Account Manager'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Icon(
                    Icons.account_balance,
                    size: 65,
                    color: Colors.indigo,
                  ),

                  const SizedBox(height: 10),

                  const Text(
                    'Simple Bank Account Manager',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 23,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  TextField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Account Holder Name',
                      prefixIcon: Icon(Icons.person),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 14),

                  TextField(
                    controller: _balanceController,
                    keyboardType:
                        const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    decoration: const InputDecoration(
                      labelText: 'Initial Balance',
                      prefixIcon: Icon(Icons.currency_rupee),
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 16),

                  ElevatedButton.icon(
                    onPressed: _saveAccount,
                    icon: const Icon(Icons.save),
                    label: const Text('Save Account'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.all(15),
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'Account Details',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 10),

                  if (_accounts.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(20),
                      child: Text(
                        'No accounts added yet.',
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics:
                          const NeverScrollableScrollPhysics(),
                      itemCount: _accounts.length,
                      itemBuilder: (context, index) {
                        final account = _accounts[index];

                        final balance =
                            (account['balance'] as num)
                                .toDouble();

                        final isLowBalance = balance == 0;

                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor:
                                  Colors.indigo.shade100,
                              child: const Icon(
                                Icons.person,
                                color: Colors.indigo,
                              ),
                            ),
                            title: Text(
                              account['accountHolder'].toString(),
                            ),
                            subtitle: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Account ID: ${account['id']}',
                                ),
                                Text(
                                  'Balance: ₹${balance.toStringAsFixed(2)}',
                                ),
                                if (isLowBalance)
                                  const Text(
                                    'Low Balance!',
                                    style: TextStyle(
                                      color: Colors.red,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                  const SizedBox(height: 16),

                  Card(
                    color: Colors.indigo.shade50,
                    child: Padding(
                      padding: const EdgeInsets.all(18),
                      child: Column(
                        children: [
                          const Text(
                            'Total Money in Bank',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            '₹${_totalBalance.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: Colors.indigo,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
