import 'package:bloc_practice/constants.dart';
import 'package:bloc_practice/product_bloc/fetch_result.dart';
import 'package:bloc_practice/product_bloc/load_product_action.dart';
import 'package:bloc_practice/product_bloc/product_bloc.dart';
import 'package:bloc_practice/repository/product_repository_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

extension Subscript<T> on Iterable<T> {
  T? operator [](int index) => length > index ? elementAt(index) : null;
}

class FirstBlocExampleHome extends StatefulWidget {
  const FirstBlocExampleHome({Key? key}) : super(key: key);

  @override
  State<FirstBlocExampleHome> createState() => _FirstBlocExampleHomeState();
}

class _FirstBlocExampleHomeState extends State<FirstBlocExampleHome> {
  final productRepository = ProductRepositoryImpl();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("First Bloc Example"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              TextButton(
                onPressed: () {
                  debugPrint("Load Json 1");
                  context.read<ProductBloc>().add(
                        LoadProductsAction(
                          url: Constants.person1Url,
                          loader: productRepository.getProducts,
                        ),
                      );
                },
                child: const Text("Load Json 1"),
              ),
              TextButton(
                onPressed: () {
                  debugPrint("Load Json 2");
                  context.read<ProductBloc>().add(
                        LoadProductsAction(
                          url: Constants.person2Url,
                          loader: productRepository.getProducts,
                        ),
                      );
                },
                child: const Text("Load Json 2"),
              ),
            ],
          ),
          BlocBuilder<ProductBloc, FetchResult?>(
            buildWhen: (previousResult, currentResult) {
              return previousResult?.products != currentResult?.products;
            },
            builder: (context, fetchResult) {
              final products = fetchResult?.products;
              if (products == null) {
                return const SizedBox();
              }
              return Expanded(
                child: ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return ListTile(
                      title: Text(
                        product?.title ?? "",
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
