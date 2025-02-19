class Products {
  int? id;
  String? name;
  double? price;
  String? image;
  String? description;
  Category? category;
  Cart? cart;
  bool isLoading = false;

  Products({
    this.id,
    this.name,
    this.price,
    this.image,
    this.description,
    this.category,
    this.cart,
    required this.isLoading,
  });

  Products.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    price = json['price'];
    image = json['image_url'];
    description = json['description'];
    isLoading = false;  
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    cart = json['cart'] != null ? Cart.fromJson(json['cart']) : null;
  }

  Products copyWith({
    int? id,
    String? name,
    double? price,
    String? image,
    String? description,
    Category? category,
    Cart? cart,
    bool? isLoading,
  }) {
    return Products(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      image: image ?? this.image,
      description: description ?? this.description,
      category: category ?? this.category,
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class Category {
  int? id;
  String? name;

  Category({this.id, this.name});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }

  Category copyWith({int? id, String? name}) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}

class Cart {
  int? quantity;

  Cart({this.quantity});

  Cart.fromJson(Map<String, dynamic> json) {
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    return {
      'quantity': quantity,
    };
  }

  Cart copyWith({int? quantity}) {
    return Cart(
      quantity: quantity ?? this.quantity,
    );
  }
}
