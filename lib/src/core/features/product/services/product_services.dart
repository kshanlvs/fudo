import 'package:flutter/material.dart';
import 'package:fudo/src/core/features/product/models/cart_items.dart';
import 'package:fudo/src/core/features/product/models/product_model.dart';
import 'package:fudo/src/core/network/dio_client.dart';

class ProductService extends ChangeNotifier {
  ProductService() {
    fetchProducts();
  }

  List<Products> products = [];
  bool isLoading = false;

  double get totalCartPrice {
    return products.fold(0.0, (total, product) {
      return total + (product.cart?.quantity ?? 0) * (product.price ?? 0.0);
    });
  }

  int get totalCartItems {
    return products.fold(0, (total, product) {
      return total + (product.cart?.quantity ?? 0);
    });
  }

  /// Fetch Products from API
  Future<void> fetchProducts() async {
    products.clear();
    isLoading = true;
    notifyListeners();

    try {
      final response = await dioClient.get("products/");
      if (response.statusCode == 200) {
        List data = response.data['products'];
        products = data.map((e) => Products.fromJson(e)).toList();
      } else {
        debugPrint("Failed to fetch products: ${response.data}");
      }
    } catch (e) {
      debugPrint("Dio error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  /// Track Loading State for Individual Products
  void updateProductLoading(int productId, bool isLoading) {
    int index = products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      products[index] = products[index].copyWith(isLoading: isLoading);
      notifyListeners();
    }
  }

  /// Add Item to Cart
  Future<bool> addToCart(CartItems item) async {
    bool success = false;
    int index = products.indexWhere((p) => p.id == item.productId);

    if (index == -1 || products[index].isLoading) {
      return false; // Prevent duplicate API calls
    }

    updateProductLoading(item.productId!, true);

    try {
      final response = await dioClient.post("cart/add", data: {
        "product_id": item.productId,
        "quantity": item.quantity,
      });

      if (response.statusCode == 200) {
        final updatedCart = response.data;
        products[index] = products[index].copyWith(
          cart: Cart.fromJson(updatedCart),
          isLoading: false,
        );
        success = true;
      } else {
        debugPrint("Failed to add item to cart: ${response.data}");
      }
    } catch (e) {
      debugPrint("Dio error: $e");
    } finally {
      updateProductLoading(item.productId!, false);
    }

    return success;
  }

  /// Increase Quantity of Item in Cart
  void increaseQuantity(int productId) {
    int index = products.indexWhere((p) => p.id == productId);
    if (index != -1 && !products[index].isLoading) {
      addToCart(CartItems(productId: productId, quantity: 1));
    }
  }

  /// Decrease Quantity of Item in Cart
  void decreaseQuantity(int productId) async {
    int index = products.indexWhere((p) => p.id == productId);
    if (index != -1 && !products[index].isLoading) {
      // Ensure that the cart is not null and quantity is greater than 1 before decreasing
      int quantity = products[index].cart?.quantity ?? 0;

      if (quantity > 1) {
        // Decrease the quantity by 1 by calling the decrement API
        await _decrementCartItem(productId);
      } else if (quantity == 1) {
        // If quantity is 1, remove the item from the cart
        await _removeItemFromCart(productId);
      }
    }
  }

  /// Call the API to decrement the cart item quantity
  Future<void> _decrementCartItem(int productId) async {
    updateProductLoading(productId, true);

    try {
      // Get the product index
      int index = products.indexWhere((p) => p.id == productId);
      if (index == -1) return;  // If product not found, do nothing

      // Get the current quantity
      int currentQuantity = products[index].cart?.quantity ?? 0;

      // If the quantity is greater than 1, decrement the quantity
      if (currentQuantity > 1) {
        final response = await dioClient.put(
          "cart/decrement",
          data: {"product_id": productId, "quantity": 1},
        );

        if (response.statusCode == 200) {
          final updatedCartItem = response.data;
          products[index] = products[index].copyWith(
            cart: Cart.fromJson(updatedCartItem),
            isLoading: false,
          );
          notifyListeners();
        } else {
          debugPrint("Failed to decrement cart item: ${response.data}");
        }
      }
    } catch (e) {
      debugPrint("Dio error: $e");
    } finally {
      updateProductLoading(productId, false);
    }
  }

  /// Call the API to remove the item from the cart
  Future<void> _removeItemFromCart(int productId) async {
    updateProductLoading(productId, true);

    try {
      final response =  await dioClient.delete('cart/remove/$productId');

      if (response.statusCode == 200) {
        // After removing the item, we need to update the products list
        int index = products.indexWhere((p) => p.id == productId);
        if (index != -1) {
          products.removeAt(index);
          notifyListeners();
        }
      } else {
        debugPrint("Failed to remove item from cart: ${response.data}");
      }
    } catch (e) {
      debugPrint("Dio error: $e");
    } finally {
      updateProductLoading(productId, false);
    }
  }
}
