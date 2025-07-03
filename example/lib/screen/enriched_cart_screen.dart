import 'package:flutter/material.dart';
import 'package:fake_store_client/fake_store_client.dart';

class EnrichedCartScreen extends StatefulWidget {
  const EnrichedCartScreen({super.key});

  @override
  State<EnrichedCartScreen> createState() => _EnrichedCartScreenState();
}

class _EnrichedCartScreenState extends State<EnrichedCartScreen> {
  final _client = FakeStoreClient();
  late Future<EnrichedCart?> _cartFuture;

  @override
  void initState() {
    super.initState();
    _cartFuture = _loadCart();
  }

  Future<EnrichedCart?> _loadCart() async {
    final result = await _client.getEnrichedCartById(1);
    return result.fold((err) {
      debugPrint('❌ Error al obtener carrito: $err');
      return null;
    }, (cart) => cart);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<EnrichedCart?>(
        future: _cartFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final cart = snapshot.data;
          if (cart == null) {
            return const Center(child: Text("❌ No se pudo obtener el carrito"));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                // Info del usuario
                Card(
                  elevation: 4,
                  child: ListTile(
                    leading: const Icon(Icons.person),
                    title: Text(
                      '${cart.user.name.firstname} ${cart.user.name.lastname}',
                    ),
                    subtitle: Text(cart.user.email),
                  ),
                ),
                const SizedBox(height: 16),

                // Lista de productos
                const Text(
                  'Productos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.products.length,
                    itemBuilder: (context, index) {
                      final item = cart.products[index];
                      final total = item.price * item.quantity;

                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Imagen del producto
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  item.image, // 🔁 Nuevo campo que debes retornar en ProductCart
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.contain,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(
                                            Icons.broken_image,
                                            size: 60,
                                          ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Información del producto
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4),
                                    Text('Cantidad: ${item.quantity}'),
                                  ],
                                ),
                              ),
                              // Precio total
                              Text(
                                '\$${(item.price * item.quantity).toStringAsFixed(2)}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
