import 'package:bloc_practice/models/product.dart';
import 'package:bloc_practice/product_bloc/product_bloc.dart';
import 'package:flutter/material.dart';

@immutable
class FetchResult {
  final Iterable<Product> products;
  final bool isRetrievedFromCache;

  const FetchResult(
      {required this.isRetrievedFromCache, required this.products});

  @override
  String toString() =>
      "FetchResult (isRetrievedFromCache = $isRetrievedFromCache, product = $products)";

  @override
  bool operator ==(covariant FetchResult other) =>
      products.isEqualIgnoringOrdering(other.products) &&
      isRetrievedFromCache == other.isRetrievedFromCache;

  @override
  int get hashCode => Object.hash(
        products,
        isRetrievedFromCache,
      );
}
