
import 'package:flutter/material.dart';
import 'products/list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('DSSiShop', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        actions: [
          IconButton(icon: const Icon(Icons.search), onPressed: () {}),
          IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {}),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Shops Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Top Shops',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            SizedBox(
              height: 120,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: const [
                  ShopCard(name: 'Fashion Hub'),
                  ShopCard(name: 'Gadget World'),
                  ShopCard(name: 'Beauty Store'),
                  ShopCard(name: 'Home Essentials'),
                ],
              ),
            ),
            // Top Products Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Top Products',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              padding: const EdgeInsets.all(8.0),
              childAspectRatio: 0.7,
              children: const [
                ProductCard(
                    name: 'Perfume',
                    price: 70.99,
                    imageUrl: 'https://via.placeholder.com/150?text=Perfume'),
                ProductCard(
                    name: 'T-shirt',
                    price: 73.99,
                    imageUrl: 'https://via.placeholder.com/150?text=T-shirt'),
                ProductCard(
                    name: 'Coffee Maker',
                    price: 576.99,
                    imageUrl:
                        'https://via.placeholder.com/150?text=Coffee+Maker'),
              ],
            ),
            // Button to ProductListPage
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 16.0),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProductListPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                ),
                child: const Text('View All Products'),
              ),
            ),
            // Popular Reviews Section
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Popular Reviews',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: const [
                ReviewCard(
                  username: 'A',
                  comment: 'Great quality and fast delivery!',
                  rating: 0.0,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ShopCard extends StatelessWidget {
  final String name;

  const ShopCard({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            const SizedBox(height: 60), // Placeholder for image
            const SizedBox(height: 4),
            Text(
              name,
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final String name;
  final double price;
  final String imageUrl;

  const ProductCard(
      {super.key, required this.name, required this.price, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.network(
            imageUrl,
            height: 150,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              '\$${price.toStringAsFixed(2)}',
              style: const TextStyle(
                  color: Colors.orange, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewCard extends StatelessWidget {
  final String username;
  final String comment;
  final double rating;

  const ReviewCard({
    super.key,
    required this.username,
    required this.comment,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(width: 50, height: 50), // Placeholder for product image
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(username,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text(comment),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 