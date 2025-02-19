import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:fudo/src/core/features/product/models/cart_items.dart';
import 'package:fudo/src/core/features/product/services/cart_service.dart';
import 'package:provider/provider.dart'; 
import 'package:shimmer/shimmer.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  CartPageState createState() => CartPageState();
}

class CartPageState extends State<CartPage> {
  @override
  void initState() {
    super.initState();
    context.read<CartService>().getCartSummary();
  }

  @override
  Widget build(BuildContext context) {
    final cartService = context.watch<CartService>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text("Cart", style: TextStyle(color: Colors.black)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: cartService.isLoading
            ? _buildShimmerEffect()
            : cartService.cartItems.isEmpty
                ? const Center(
                    child: Text(
                      "Your cart is empty 🛒",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  )
                : ListView.builder(
                    itemCount: cartService.cartItems.length,
                    itemBuilder: (context, index) {
                      return CartItemWidget(
                        item: cartService.cartItems[index],
                        onRemove: () async {
                          if (await cartService.removeFromCart(
                              cartService.cartItems[index].productId!)) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Item removed from cart")),
                            );
                          }
                        },
                        onIncrease: () {
                          cartService.increaseQuantity(cartService.cartItems[index].productId!);
                        },
                        onDecrease: () {
                          cartService.decreaseQuantity(cartService.cartItems[index].productId!);
                        },
                      );
                    },
                  ),
      ),
      floatingActionButton: cartService.cartItems.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () {
                print("Proceed to checkout");
              },
              backgroundColor: Colors.orange,
              icon: const Icon(Icons.payment),
              label: Text(
                "Checkout ₹${cartService.totalPrice.toStringAsFixed(2)}",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            )
          : null,
    );
  }

  /// Shimmer effect while cart items are loading
  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 3,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 12.0),
          child: Row(
            children: [
              Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 16,
                        width: double.infinity,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Shimmer.fromColors(
                      baseColor: Colors.grey[300]!,
                      highlightColor: Colors.grey[100]!,
                      child: Container(
                        height: 12,
                        width: 150,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final CartItems item;
  final VoidCallback onRemove;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;

  const CartItemWidget({
    required this.item,
    required this.onRemove,
    required this.onIncrease,
    required this.onDecrease,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8.0),
            child: CachedNetworkImage(
              imageUrl: item.imageUrl ?? '',
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              placeholder: (context, url) => const CircularProgressIndicator(),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text("₹${item.price?.toStringAsFixed(2)}", style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: onDecrease, // Decrement quantity
              ),
              Text(item.quantity.toString(), style: const TextStyle(fontSize: 16)),
              IconButton(
                icon: const Icon(Icons.add, color: Colors.orange),
                onPressed: onIncrease, // Increment quantity
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: onRemove, // Remove item from cart
              ),
            ],
          ),
        ],
      ),
    );
  }
}