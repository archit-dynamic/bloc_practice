import 'package:bloc_practice/models/product.dart';
import 'package:bloc_practice/product_bloc/fetch_result.dart';
import 'package:bloc_practice/product_bloc/load_product_action.dart';
import 'package:bloc_practice/product_bloc/product_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

final mockedProducts1 = [
  Product(
    id: 1,
    title: "1",
  ),
  Product(
    id: 2,
    title: "2",
  ),
];

final mockedProducts2 = [
  Product(
    id: 3,
    title: "3",
  ),
  Product(
    id: 4,
    title: "4",
  ),
];

Future<Iterable<Product>> mockGetProduct1(String _) =>
    Future.value(mockedProducts1);

Future<Iterable<Product>> mockGetProduct2(String _) =>
    Future.value(mockedProducts2);

void main() {
  group("Testing bloc", () {
    //write our tests

    late ProductBloc bloc;

    setUp(() {
      bloc = ProductBloc();
    });

    blocTest<ProductBloc, FetchResult?>(
      "Test initial state",
      build: () => bloc,
      verify: (bloc) => expect(
        bloc.state,
        null,
      ),
    );

    //fetch mock data (product1) and compare it with FetchResult
    blocTest<ProductBloc, FetchResult?>(
      "Mock retrieving product from first iterable",
      build: () => bloc,
      act: (bloc) {
        bloc.add(
          const LoadProductsAction(
            url: "dummy_url_1",
            loader: mockGetProduct1,
          ),
        );
        bloc.add(
          const LoadProductsAction(
            url: "dummy_url_1",
            loader: mockGetProduct1,
          ),
        );
      },
      expect: () => [
        FetchResult(
          isRetrievedFromCache: false,
          products: mockedProducts1,
        ),
        FetchResult(
          isRetrievedFromCache: true,
          products: mockedProducts1,
        ),
      ],
    );

    //fetch mock data (product2) and compare it with FetchResult
    blocTest<ProductBloc, FetchResult?>(
      "Mock retrieving product from second iterable",
      build: () => bloc,
      act: (bloc) {
        bloc.add(
          const LoadProductsAction(
            url: "dummy_url_2",
            loader: mockGetProduct2,
          ),
        );
        bloc.add(
          const LoadProductsAction(
            url: "dummy_url_2",
            loader: mockGetProduct2,
          ),
        );
      },
      expect: () => [
        FetchResult(
          isRetrievedFromCache: false,
          products: mockedProducts2,
        ),
        FetchResult(
          isRetrievedFromCache: true,
          products: mockedProducts2,
        ),
      ],
    );
  });
}
