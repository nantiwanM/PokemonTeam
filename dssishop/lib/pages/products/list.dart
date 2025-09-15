import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'create.dart';
import 'update.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      price: (json['price'] as num).toDouble(),
      imageUrl: json['imageUrl'],
    );
  }
}

class ProductListPage extends StatefulWidget {
  const ProductListPage({super.key});

  @override
  _ProductListPageState createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  final PocketBase _client = PocketBase('http://127.0.0.1:8090');
  final List<Product> _products = [];
  int _page = 1;
  final int _perPage = 20;
  bool _isLoading = false;
  bool _hasMore = true;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _init();
  }

  Future<void> _init() async {
    try {
      await _authenticate();
      await _loadProducts();
      _setupRealtimeSubscription();
    } catch (e) {
      print('Initialization failed: $e');
    }
  }

  Future<void> _authenticate() async {
    try {
      await _client.collection('_superusers').authWithPassword(
            'admin@gmail.com',
            'admin123456789',
          );
      print('Authenticated successfully');
    } catch (e) {
      print('Authentication failed: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Failed to authenticate. Please check credentials.'),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: _init,
          ),
        ),
      );
      rethrow;
    }
  }

  Future<void> _loadProducts() async {
    if (_isLoading || !_hasMore) return;

    setState(() => _isLoading = true);

    try {
      final response = await _client.collection('products').getList(
            page: _page,
            perPage: _perPage,
            sort: '-created',
          );

      final newProducts = response.items
          .map((item) => Product.fromJson(item.toJson()))
          .toList();

      setState(() {
        _page++;
        _products.addAll(newProducts);
        _hasMore = response.items.length == _perPage;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading products: $e'),
          action: SnackBarAction(
            label: 'Retry',
            onPressed: _loadProducts,
          ),
        ),
      );
    }
  }

  void _setupRealtimeSubscription() {
    _client.collection('products').subscribe('*', (event) {
      if (event.record == null) return;
      final product = Product.fromJson(event.record!.toJson());

      setState(() {
        if (event.action == 'create') {
          _products.insert(0, product);
          _scrollController.animateTo(0, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
        } else if (event.action == 'update') {
          final index = _products.indexWhere((p) => p.id == product.id);
          if (index != -1) _products[index] = product;
        } else if (event.action == 'delete') {
          _products.removeWhere((p) => p.id == product.id);
        }
      });
    });
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadProducts();
    }
  }

  @override
  void dispose() {
    _client.collection('products').unsubscribe();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _deleteProduct(Product product) async {
    try {
      await _client.collection('products').delete(product.id);
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Colors.deepPurple,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (_) => CreateProductDialog(client: _client),
        ),
        child: const Icon(Icons.add),
      ),
      body: _products.isEmpty && _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              controller: _scrollController,
              itemCount: _products.length + (_hasMore ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _products.length && _hasMore) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                final product = _products[index];
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: ListTile(
                    leading: Image.network(
                      product.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => const Icon(Icons.error),
                    ),
                    title: Text(product.name),
                    subtitle: Text('\$${product.price.toStringAsFixed(2)}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.orange),
                          onPressed: () => showDialog(
                            context: context,
                            builder: (_) => EditProductDialog(client: _client, product: product),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteProduct(product),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
