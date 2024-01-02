import 'package:bloc_practice/models/product.dart';
import 'package:bloc_practice/product_bloc/load_action.dart';
import 'package:flutter/material.dart';

typedef ProductLoader = Future<Iterable<Product>> Function(String url);

@immutable
class LoadProductsAction implements LoadAction {
  final String url;
  final ProductLoader loader;

  const LoadProductsAction({
    required this.url,
    required this.loader,
  }) : super();
}
