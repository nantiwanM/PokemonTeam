import 'dart:math';
import 'package:pocketbase/pocketbase.dart';

Future<void> generateAndSaveProductsToPocketbase() async {
  final client = PocketBase('http://127.0.0.1:8090'); // URL PocketBase ของคุณ

  // login admin / superuser
  try {
    await client.collection('_superusers').authWithPassword(
      'admin@gmail.com',
      'admin123456789',
    );
    print('Logged in as superuser!');
  } catch (e) {
    print('Login failed: $e');
    return;
  }

  final random = Random();
  final productNames = [
    'T-Shirt', 'Jeans', 'Shoes', 'Hat', 'Jacket',
    'Bag', 'Watch', 'Sunglasses', 'Dress', 'Skirt'
  ];

  for (int i = 0; i < 100; i++) {
    final name = productNames[random.nextInt(productNames.length)];
    final price = (random.nextInt(5000) + 100) + 0.99;
    final imageUrl = 'https://picsum.photos/200?random=$i';

    try {
      await client.collection('products').create(
        body: {
          'name': name,
          'price': price,
          'imageUrl': imageUrl,
        },
      );
      print('Created product: $name');
    } catch (e) {
      print('Error creating product $name: $e');
    }
  }

  print('Done creating 100 products!');
}

void main() async {
  await generateAndSaveProductsToPocketbase();
}
