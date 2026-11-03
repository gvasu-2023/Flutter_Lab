
import 'package:flutter/material.dart';

void main() {
  runApp(const CustomListViewApp());
}

class CustomListViewApp extends StatelessWidget {
  const CustomListViewApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Custom List View',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ProductListScreen(),
    );
  }
}

class Product {
  final String name;
  final double price;
  final String imageUrl;
  final String emoji;

  const Product({
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.emoji,
  });
}

const List<Product> products = [
  Product(
    name: 'Apple',
    price: 180,
    imageUrl:
        'https://images.unsplash.com/photo-1560806887-1e4cd0b6cbd6?w=400',
    emoji: '🍎',
  ),
  Product(
    name: 'Orange',
    price: 100,
    imageUrl:
        'https://images.unsplash.com/photo-1547514701-42782101795e?w=400',
    emoji: '🍊',
  ),
  Product(
    name: 'Mango',
    price: 70,
    imageUrl:
        'https://images.unsplash.com/photo-1553279768-865429fa0078?w=400',
    emoji: '🥭',
  ),
  Product(
    name: 'Pomegranate',
    price: 250,
    imageUrl:
        'https://images.unsplash.com/photo-1541344999736-5a5b1d4c0a31?w=400',
    emoji: '🍎',
  ),
];

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Custom List View',
          style: TextStyle(letterSpacing: 3),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: ListView(
      padding: const EdgeInsets.all(12),
      children: products.map((product) {
      return MyListItem(product: product);
      }).toList(),
    ),
    );
  }
}

class MyListItem extends StatelessWidget {
  final Product product;

  const MyListItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 14),
      clipBehavior: Clip.antiAlias,
      child: SizedBox(
        height: 150,
        child: Row(
          children: [
            SizedBox(
              width: 145,
              height: 150,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.deepPurple.shade50,
                    alignment: Alignment.center,
                    child: Text(
                      product.emoji,
                      style: const TextStyle(fontSize: 65),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '₹${product.price.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ElevatedButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${product.name} selected!'),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 8,
                        ),
                      ),
                      child: const Text('Buy Now'),
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
