import 'package:bloc_practice/models/product.dart';
import 'package:bloc_practice/repository/product_repository.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class ProductRepositoryImpl extends ProductRepository {
  @override
  Future<Iterable<Product>> getProducts(String url) async {
    final dio = Dio();
    List<Product> productList = [];
    try {
      final response = await dio.get(url);
      debugPrint("response ${response.data}");
      if (response.data["products"] is List) {
        response.data["products"].forEach((element) {
          productList.add(Product.fromJson(element));
        });
      } else {
        productList.add(Product.fromJson(response.data));
      }
    } on DioException catch (e) {
      debugPrint("$e");
    }
    return productList;
  }
}
