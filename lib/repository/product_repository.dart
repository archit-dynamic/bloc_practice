import 'package:bloc_practice/models/product.dart';

abstract class ProductRepository {
  Future<Iterable<Product>> getProducts(String url);
}
