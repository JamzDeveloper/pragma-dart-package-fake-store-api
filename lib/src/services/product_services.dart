import 'dart:convert';
import 'package:fake_store_client/src/config/environment.dart';
import 'package:fake_store_client/src/models/failure.dart';
import 'package:http/http.dart' as http;
import 'package:dartz/dartz.dart';
import '../models/product.dart';

class ProductService {
  Future<Either<String, ProductModel>> getProduct(int id) async {
    try {
      final response = await http.get(
        Uri.parse('${Environment.baseUrlApiService}/products/$id'),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final product = ProductModel.fromJson(json);
        return Right(product);
      } else {
        return Left('Error HTTP: ${response.statusCode}');
      }
    } catch (e) {
      return Left('Excepción: $e');
    }
  }

  Future<Either<Failure, List<ProductModel>>> fetchProducts() async {
    try {
      final url = Uri.parse("${Environment.baseUrlApiService}/products");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List list = jsonDecode(response.body);
        final products = list.map((e) => ProductModel.fromJson(e)).toList();

        return Right(products);
      } else {
        return Left(Failure('Error ${response.statusCode}: ${response.body}'));
      }
    } catch (err) {
      return Left(Failure('Excepcion $err'));
    }
  }
}
