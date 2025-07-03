import 'package:fake_store_client/fake_store_client.dart';

void main() async {
  var awesome = FakeStoreClient();

  final result = await awesome.getEnrichedCartById(1);
  final userResult = await awesome.getUser(1);
  final productResult = await awesome.getProduct(1);

  productResult.fold(
    (err) {
      print(err);
    },
    (result) {
      print(result);
    },
  );
  userResult.fold(
    (err) {
      print(err);
    },
    (result) {
      print(result);
    },
  );
  result.fold(
    (err) {
      print("err:${err}");
    },
    (data) {
      print(data.toString());
    },
  );
}
