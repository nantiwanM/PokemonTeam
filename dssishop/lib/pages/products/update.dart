import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';
import 'list.dart';

class EditProductDialog extends StatefulWidget {
  final PocketBase client;
  final Product product;
  const EditProductDialog({
    super.key,
    required this.client,
    required this.product,
  });

  @override
  _EditProductDialogState createState() => _EditProductDialogState();
}

class _EditProductDialogState extends State<EditProductDialog> {
  late final TextEditingController _nameController;
  late final TextEditingController _priceController;
  late final TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.product.name);
    _priceController = TextEditingController(
      text: widget.product.price.toString(),
    );
    _imageUrlController = TextEditingController(text: widget.product.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Edit Product'),
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
                  .update(
                    widget.product.id,
                    body: {
                      'name': _nameController.text,
                      'price': double.tryParse(_priceController.text) ?? 0,
                      'imageUrl': _imageUrlController.text,
                    },
                  );

              Navigator.pop(context);
            } catch (e) {
              print('Error updating product: $e');
            }
          },
          child: const Text('Update'),
        ),
      ],
    );
  }
}
