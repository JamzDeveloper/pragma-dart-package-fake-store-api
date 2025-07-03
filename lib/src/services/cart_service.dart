import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:fake_store_client/src/config/environment.dart';
import 'package:fake_store_client/src/models/cart.dart';
import 'package:http/http.dart' as http;

class CartService {
  final String _baseUrl = '${Environment.baseUrlApiService}/carts';

  Future<Either<String, CartModel>> getCartById(int id) async {
    try {
      final response = await http.get(Uri.parse('$_baseUrl/$id'));

      if (response.statusCode == 200) {
        final cart = CartModel.fromJson(jsonDecode(response.body));
        return Right(cart);
      } else {
        return Left('Error: código ${response.statusCode}');
      }
    } catch (e) {
      return Left('Excepción: ${e.toString()}');
    }
  }
}
