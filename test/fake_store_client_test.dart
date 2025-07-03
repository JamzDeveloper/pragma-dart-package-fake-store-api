import 'package:fake_store_client/fake_store_client.dart';
import 'package:test/test.dart';

void main() {
  test('should create an instance', () {
    final client = FakeStoreClient();
    expect(client, isNotNull);
  });
}
