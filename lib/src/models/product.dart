import 'dart:convert';

ProductModel productFromJson(String str) =>
    ProductModel.fromJson(json.decode(str));

String productToJson(ProductModel data) => json.encode(data.toJson());

class ProductModel {
  int id;
  String title;
  double price;
  String description;
  String category;
  String image;
  Rating rating;

  ProductModel({
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    required this.category,
    required this.image,
    required this.rating,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
    id: json["id"],
    title: json["title"],
    price: json["price"]?.toDouble(),
    description: json["description"],
    category: json["category"],
    image: json["image"],
    rating: Rating.fromJson(json["rating"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "price": price,
    "description": description,
    "category": category,
    "image": image,
    "rating": rating.toJson(),
  };
  String toString() {
    return '''
🛍️ Producto: $title
💲 Precio: \$${price.toStringAsFixed(2)}
📄 Descripción: $description
📦 Categoría: $category
🌟 Rating: ${rating.rate} (${rating.count} reviews)
🖼️ Imagen: $image
''';
  }
}

class Rating {
  double rate;
  int count;

  Rating({required this.rate, required this.count});

  factory Rating.fromJson(Map<String, dynamic> json) =>
      Rating(rate: json["rate"]?.toDouble(), count: json["count"]);

  Map<String, dynamic> toJson() => {"rate": rate, "count": count};
}
