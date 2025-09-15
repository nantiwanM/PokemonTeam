import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class CreateProductDialog extends StatefulWidget {
  final PocketBase client;
  const CreateProductDialog({super.key, required this.client});

  @override
  _CreateProductDialogState createState() => _CreateProductDialogState();
}

class _CreateProductDialogState extends State<CreateProductDialog> {
  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _imageUrlController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Create Product'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: const InputDecoration(labelText: 'Name'),
          ),
          TextField(
            controller: _priceController,
            decoration: const InputDecoration(labelText: 'Price'),
            keyboardType: TextInputType.number,
          ),
          TextField(
            controller: _imageUrlController,
            decoration: const InputDecoration(labelText: 'Image URL'),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            try {
              await widget.client
                  .collection('products')
                  .create(
                    body: {
                      'name': _nameController.text,
                      'price': double.tryParse(_priceController.text) ?? 0,
                      'imageUrl': _imageUrlController.text,
                    },
                  );

              Navigator.pop(context);
            } catch (e) {
              print('Error creating product: $e');
            }
          },
          child: const Text('Create'),
        ),
      ],
    );
  }
}
