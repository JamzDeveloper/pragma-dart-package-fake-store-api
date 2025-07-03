
import 'package:dartz/dartz.dart';
import 'package:fake_store_client/src/models/enriched_cart.dart';
import 'package:fake_store_client/src/models/product.dart';
import 'package:fake_store_client/src/models/user.dart';
import 'package:fake_store_client/src/services/cart_service.dart';
import 'package:fake_store_client/src/services/product_services.dart';
import 'package:fake_store_client/src/services/user_services.dart';

class FakeStoreClient {
  final ProductService productService;
  final UserService userService;
  final CartService cartService;

  FakeStoreClient({
    ProductService? productService,
    UserService? userService,
    CartService? cartService,
  }) : productService = productService ?? ProductService(),
       userService = userService ?? UserService(),
       cartService = cartService ?? CartService();

  Future<Either<String, ProductModel>> getProduct(int id) =>
      productService.getProduct(id);

  Future<Either<String, UserModel>> getUser(int id) => userService.getUser(id);

  Future<Either<String, EnrichedCart>> getEnrichedCartById(int cartId) async {
    final cartResult = await cartService.getCartById(cartId);

    return await cartResult.fold(
      (error) => Left("❌ Error al obtener carrito: $error"),
      (cart) async {
        // Obtener usuario
        final userResult = await userService.getUser(cart.userId);
        final user = await userResult.fold<UserModel?>(
          (error) => null,
          (user) => user,
        );

        if (user == null) {
          return Left("❌ Usuario no encontrado");
        }

        // Obtener productos en paralelo
        final productFutures =
            cart.products.map((prod) async {
              final productResult = await productService.getProduct(
                prod.productId,
              );
              return productResult.fold<ProductCart?>(
                (error) => null,
                (product) => ProductCart(
                  productId: product.id,
                  quantity: prod.quantity,
                  title: product.title,
                  price: product.price,
                  image: product.image
                ),
              );
            }).toList();

        final enrichedProducts = await Future.wait(productFutures);

        final filteredProducts =
            enrichedProducts
                .where((element) => element != null)
                .cast<ProductCart>()
                .toList();

        final enrichedCart = EnrichedCart(
          id: cart.id,
          user: user,
          date: cart.date,
          products: filteredProducts,
          v: 0, // puedes modificar según backend
        );

        return Right(enrichedCart);
      },
    );
  }
}
