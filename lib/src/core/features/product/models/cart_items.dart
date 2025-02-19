

class CartItems {
  int? productId;
  String? name;
  int? quantity;
  double? price;
  double? total;
  String? imageUrl;

  CartItems(
      {this.productId,
      this.name,
      this.quantity,
      this.price,
      this.total,
      this.imageUrl});

  CartItems.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    name = json['name'];
    quantity = json['quantity'];
    price = json['price'];
    total = json['total'];
    imageUrl = json['image_url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['name'] = name;
    data['quantity'] = quantity;
    data['price'] = price;
    data['total'] = total;
    data['image_url'] = imageUrl;
    return data;
  }
}
