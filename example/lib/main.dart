
import 'package:fake_store_client/fake_store_client.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const FakeStoreExampleApp());
}

class FakeStoreExampleApp extends StatelessWidget {
  const FakeStoreExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Fake Store Example',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: true),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    ProductScreen(),
    UserScreen(),
    EnrichedCartScreen(),
  ];

  final List<String> _titles = const ['Detalle del Producto', 'Detalle del usuario', 'Carrito'];

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_selectedIndex])),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.deepPurple,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Producto',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Usuario'),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Carrito',
          ),
        ],
      ),
    );
  }
}





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






class UserScreen extends StatefulWidget {
  const UserScreen({super.key});

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {
  final _client = FakeStoreClient();

  late Future<UserModel?> _userFuture;

  @override
  void initState() {
    super.initState();
    _userFuture = _loadUser();
  }

  Future<UserModel?> _loadUser() async {
    final result = await _client.getUser(2);
    return result.fold(
      (err) {
        debugPrint('❌ Error al obtener usuario: $err');
        return null;
      },
      (user) => user,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<UserModel?>(
        future: _userFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return const Center(child: Text("❌ Error inesperado"));
          }

          final user = snapshot.data;
          if (user == null) {
            return const Center(child: Text("⚠️ Usuario no disponible"));
          }

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 6,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 12),
                  const Icon(Icons.person, size: 72, color: Colors.blueAccent),
                  Text(
                    '${user.name.firstname} ${user.name.lastname}',
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(user.email, style: const TextStyle(color: Colors.grey)),
                  const SizedBox(height: 16),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: Text(user.phone),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: Text(
                      '${user.address.street}, ${user.address.city}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    subtitle: Text('Zipcode: ${user.address.zipcode}'),
                  ),
                  const SizedBox(height: 12),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
