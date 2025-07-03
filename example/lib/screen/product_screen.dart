import 'package:flutter/material.dart';
import 'package:fake_store_client/fake_store_client.dart';

class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final _client = FakeStoreClient();

  late Future<ProductModel?> _productFuture;

  @override
  void initState() {
    super.initState();
    _productFuture = _loadProduct();
  }

  Future<ProductModel?> _loadProduct() async {
    final result = await _client.getProduct(1);
    return result.fold(
      (error) {
        debugPrint('❌ Error al obtener producto: $error');
        return null;
      },
      (product) => product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<ProductModel?>(
        future: _productFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("❌ Error inesperado"));
          }

          final product = snapshot.data;
          if (product == null) {
            return const Center(child: Text("⚠️ Producto no disponible"));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 12),
                Image.network(
                  product.image,
                  height: 160,
                  fit: BoxFit.contain,
                ),
                ListTile(
                  title: Text(product.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(product.description),
                  trailing: Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 18, color: Colors.green),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Text(
                    '⭐ ${product.rating.rate}   •   ${product.rating.count} reviews',
                    style: const TextStyle(color: Colors.grey),
                  ),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
