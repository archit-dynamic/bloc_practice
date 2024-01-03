class Product {
  int? id;
  String? title;
  /*String? description;
  int? price;
  double? discountPercentage;
  double? rating;
  int? stock;
  String? brand;
  String? category;
  String? thumbnail;
  List<String>? images;*/

  Product({
    this.id,
    this.title,
    /*this.description,
    this.price,
    this.discountPercentage,
    this.rating,
    this.stock,
    this.brand,
    this.category,
    this.thumbnail,
    this.images,*/
  });

  factory Product.fromJson(Map<String, dynamic> json) => Product(
        id: json["id"],
        title: json["title"] ?? "",
        /* description: json["description"] ?? "",
        price: json["price"] ?? 0,
        discountPercentage: (json["discountPercentage"] ?? 0)?.toDouble(),
        rating: (json["rating"] ?? 0)?.toDouble(),
        stock: json["stock"] ?? 0,
        brand: json["brand"] ?? "",
        category: json["category"] ?? "",
        thumbnail: json["thumbnail"] ?? "",
        images: json["images"] == null
            ? []
            : List<String>.from(json["images"].map((x) => x)),*/
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        /*"description": description,
        "price": price,
        "discountPercentage": discountPercentage,
        "rating": rating,
        "stock": stock,
        "brand": brand,
        "category": category,
        "thumbnail": thumbnail,
        "images": List<dynamic>.from(images!.map((x) => x)),*/
      };
}
