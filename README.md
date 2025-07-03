# 🛍️ Fake Store Client

**Fake Store Client** es un cliente Dart que permite consumir la API de [Fake Store API](https://fakestoreapi.com/) de forma sencilla y rápida. Ideal para pruebas, ejemplos o aplicaciones que requieran productos ficticios, usuarios y carritos de compras.

## 🚀 Características

- Obtener productos por ID: `getProduct(id)`
- Obtener usuarios por ID: `getUser(id)`
- Obtener carritos enriquecidos con productos y usuarios: `getEnrichedCartById(id)`

## 💻 Ejemplo de uso

```dart
import 'package:fake_store_client/fake_store_client.dart';

void main() async {
  final client = FakeStoreClient();

  final product = await client.getProduct(1);
  product.fold(
    (err) => print('Error: $err'),
    (data) => print('Producto: $data'),
  );
}

```

## 📦 Instalacion

Agrega esta dependencia a tu archivo pubspec.yaml:


```bash
dependencies:
  fake_store_client: ^1.0.0
  ```

Luego ejecutar

```bash
dart pub get
```

-- Puedes ver ejemplos de uso en el directorio example/.

## 📚 Estructura del código

La librería contiene lo siguiente:

- `lib/fake_store_client.dart`: entrada principal
- `lib/src/models/`: contiene modelos como `Product`, `Cart`, `User`, etc.
- `lib/src/services/`: lógica de negocio para obtener datos desde la API
- `lib/src/fake_store_client_base.dart`: lógica del cliente

Puedes revisar el archivo [`example/lib/main.dart`](https://pub.dev/packages/fake_store_client/example) para ver una implementación completa.
