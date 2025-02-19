import 'package:flutter/material.dart';
import 'package:fudo/src/core/features/product/models/cart_items.dart';

import '../../../network/dio_client.dart';

class CartService extends ChangeNotifier {
  List<CartItems> cartItems = [];
  bool isLoading = false;

  int get totalItems => cartItems.length;

  double get totalPrice =>
      cartItems.fold(0.0, (sum, item) => sum + (item.total ?? 0.0));

  Future getCartSummary() async {
    cartItems.clear();
    try {
      isLoading = true;
      final response = await dioClient.get("cart/");

      if (response.statusCode == 200) {
        List data = response.data['cart_items'];
        cartItems.addAll(data.map((e) => CartItems.fromJson(e)));
      } else {
        debugPrint("Failed to fetch cart items: ${response.data}");
      }
    } catch (e) {
      debugPrint("Dio error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> addToCart(CartItems item) async {
    bool success = false;
    try {
      isLoading = true;
      notifyListeners();

      final response = await dioClient.post("cart/add", data: {
        "product_id": item.productId,
        "quantity": item.quantity,
      });

      if (response.statusCode == 200) {
        // Parse the updated cart data from the response
        CartItems data = CartItems.fromJson(response.data);
        cartItems.clear();
        cartItems.add(data);

        debugPrint("Item added to cart successfully.");
        success = true;
      } else {
        debugPrint("Failed to add item to cart: ${response.data}");
      }
    } catch (e) {
      debugPrint("Dio error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
    return success;
  }

  Future<bool> removeFromCart(int productId) async {
    try {
      await dioClient.delete('cart/remove/$productId'); // Call FastAPI backend to remove item
      cartItems.removeWhere((item) => item.productId == productId);
      notifyListeners();
      return true;
    } catch (e) {
      debugPrint("Error removing item: $e");
      return false;
    }
  }

  Future increaseQuantity(int productId)  async{
    cartItems.firstWhere(
      (item) => item.productId == productId,
      orElse: () => CartItems(productId: productId, quantity: 0),
    );
    addToCart(CartItems(productId: productId, quantity: 1));
  }

  Future decreaseQuantity(int productId) async {
    CartItems? item = cartItems.firstWhere(
      (item) => item.productId == productId,
      orElse: () => CartItems(productId: productId, quantity: 0),
    );

    if (item.quantity! > 1) {
      // Decrement quantity
      await decrementCartItem(productId);
    } else {
      // If quantity is 1, remove the item from the cart
      removeFromCart(productId);
    }
  }

  Future<void> decrementCartItem(int productId) async {
    try {
      isLoading = true;
      notifyListeners();

      final response = await dioClient.put("cart/decrement", data: {
        "product_id": productId,
        "quantity": 1,  // Decrease the quantity by 1
      });

      if (response.statusCode == 200) {
        // Update the cart items based on the response
        CartItems updatedItem = CartItems.fromJson(response.data);
        int index = cartItems.indexWhere((item) => item.productId == productId);
        if (index != -1) {
          cartItems[index] = updatedItem;
          debugPrint("Cart item quantity decreased.");
          notifyListeners();
        }
      } else {
        debugPrint("Failed to decrement cart item: ${response.data}");
      }
    } catch (e) {
      debugPrint("Dio error: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
