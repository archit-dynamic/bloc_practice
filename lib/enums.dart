enum ProductUrl {
  product1,
  product2,
}

extension UrlString on ProductUrl {
  String get urlString {
    switch (this) {
      case ProductUrl.product1:
        return "https://dummyjson.com/products";
      case ProductUrl.product2:
        return "https://dummyjson.com/products/2";
    }
  }
}
