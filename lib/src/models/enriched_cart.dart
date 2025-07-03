import 'dart:convert';

import 'package:fake_store_client/src/models/user.dart';

EnrichedCart enrichedCartFromJson(String str) =>
    EnrichedCart.fromJson(json.decode(str));

String enrichedCartToJson(EnrichedCart data) => json.encode(data.toJson());

class EnrichedCart {
  final int id;
  final UserModel user;
  final DateTime date;
  final List<ProductCart> products;
  final int v;

  EnrichedCart({
    required this.id,
    required this.user,
    required this.date,
    required this.products,
    required this.v,
  });

  factory EnrichedCart.fromJson(Map<String, dynamic> json) => EnrichedCart(
    id: json["id"],
    user: UserModel.fromJson(json["user"]),
    date: DateTime.parse(json["date"]),
    products: List<ProductCart>.from(
      json["products"].map((x) => ProductCart.fromJson(x)),
    ),
    v: json["__v"] ?? 0, // opcionalmente puedes remover si no lo usas
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user": user.toJson(),
    "date": date.toIso8601String(),
    "products": List<dynamic>.from(products.map((x) => x.toJson())),
    "__v": v,
  };

  @override
  String toString() {
    final buffer = StringBuffer();
    buffer.writeln("🛒 Carrito ID: $id");
    buffer.writeln("📅 Fecha: ${date.toIso8601String()}");
    buffer.writeln(user); // usa el toString() de UserModel
    buffer.writeln("🧾 Productos:");
    for (final product in products) {
      buffer.writeln("  - $product"); // usa el toString() de ProductCart
    }
    return buffer.toString();
  }
}

class ProductCart {
  final int productId;
  final int quantity;
  final String title;
  final double price;
  final String image;

  ProductCart({
    required this.productId,
    required this.quantity,
    required this.title,
    required this.price,
    required this.image,
  });

  factory ProductCart.fromJson(Map<String, dynamic> json) => ProductCart(
    productId: json["productId"],
    quantity: json["quantity"],
    title: json["title"],
    price: json["price"],
    image: json["image"],
  );

  Map<String, dynamic> toJson() => {
    "productId": productId,
    "quantity": quantity,
    "title": title,
    "price": price,
    "image": image,
  };

  String toString() {
    return '🛍️ Producto: $title (ID: $productId) - 🧾 Cantidad: $quantity - 💵 Price: $price';
  }
}
