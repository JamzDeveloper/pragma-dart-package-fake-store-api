import 'package:flutter/material.dart';
import 'package:fake_store_client/fake_store_client.dart';

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
