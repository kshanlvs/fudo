import 'package:flutter/material.dart';
import 'package:fudo/src/core/features/product/services/product_services.dart';
import 'package:provider/provider.dart';
import 'package:fudo/src/core/router/route_location.dart';
import 'package:go_router/go_router.dart';

class FloatingCartSummary extends StatelessWidget {
  const FloatingCartSummary({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ProductService>(
      builder: (context, productService, child) {
        if (productService.totalCartPrice == 0) return const SizedBox.shrink();

        return Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () => context.go(RouteLocation.cart),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              margin: const EdgeInsets.only(bottom: 20, left: 16, right: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6200EA), Color(0xFFB388FF)], // Deep Blue to Purple
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.purple.withOpacity(0.5),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    clipBehavior: Clip.none,
                    children: [
                      const Icon(Icons.shopping_cart, color: Colors.white, size: 28),
                      Positioned(
                        right: -6,
                        top: -6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Color(0xFF00E5FF), // Bright Cyan Badge
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            "${productService.totalCartItems}",
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "${productService.totalCartItems} items",
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "\u{20B9}${productService.totalCartPrice.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
