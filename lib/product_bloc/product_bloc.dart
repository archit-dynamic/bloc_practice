import 'package:bloc/bloc.dart';
import 'package:bloc_practice/models/product.dart';
import 'package:bloc_practice/product_bloc/fetch_result.dart';
import 'package:bloc_practice/product_bloc/load_action.dart';
import 'package:bloc_practice/product_bloc/load_product_action.dart';
import 'package:flutter/material.dart';

extension IsEqualIgnoringOrdering<T> on Iterable<T> {
  bool isEqualIgnoringOrdering(Iterable<T> other) =>
      length == other.length &&
      {...this}.intersection({...other}).length == length;
}

class ProductBloc extends Bloc<LoadAction, FetchResult?> {
  final Map<String, Iterable<Product>> _cache = {};

  ProductBloc() : super(null) {
    on<LoadProductsAction>(
      (event, emit) async {
        final url = event.url;
        if (_cache.containsKey(url)) {
          final cachedProduct = _cache[url]!;
          debugPrint("cachedProduct $cachedProduct");
          final result = FetchResult(
            isRetrievedFromCache: true,
            products: cachedProduct,
          );
          emit(result);
        } else {
          final loader = event.loader;
          final products = await loader(url);
          debugPrint("products $products");
          _cache[url] = products;
          final result = FetchResult(
            isRetrievedFromCache: false,
            products: products,
          );
          emit(result);
        }
      },
    );
  }
}
