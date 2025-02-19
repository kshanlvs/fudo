import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fudo/src/core/features/auth/service/profile_service.dart';
import 'package:fudo/src/core/features/product/models/cart_items.dart';
import 'package:fudo/src/core/features/product/models/product_model.dart';
import 'package:fudo/src/core/features/product/services/product_services.dart';
import 'package:fudo/src/core/router/route_location.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../widgets/cart_summary.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late ConfettiController _confettiController;
  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 5))..play();

    context.read<ProfileService>().getProfile();

    WidgetsBinding.instance
        .addPostFrameCallback((_) => _showWelcomeOfferDialog());
  }

  Path drawStar(Size size) {
    double degToRad(double deg) => deg * (pi / 180.0);
    const points = 5;
    final radius = size.width / 2;
    final innerRadius = radius / 2.5;
    final step = degToRad(360 / points);
    final path = Path()..moveTo(size.width, radius);

    for (double angle = 0; angle < 2 * pi; angle += step) {
      path.lineTo(radius + radius * cos(angle), radius + radius * sin(angle));
      path.lineTo(radius + innerRadius * cos(angle + step / 2),
          radius + innerRadius * sin(angle + step / 2));
    }
    path.close();
    return path;
  }

  void _showWelcomeOfferDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Stack(
        children: [
          Align(
            alignment: Alignment.center,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              emissionFrequency: 0.03,
              numberOfParticles: 10,
              gravity: 0,
              createParticlePath: drawStar,
            ),
          ),
          AlertDialog(
            title: const Text('Welcome to Fudo!'),
            content:
                const Text('We have an exciting welcome offer just for you!'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('Got it!'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: const FloatingCartSummary(),
      appBar: AppBar(
        leadingWidth: 40,
        leading: GestureDetector(
          onTap: () {
            context.go(RouteLocation.profile); // Navigate to Profile Page
          },
          child: const Padding(
            padding: EdgeInsets.only(left: 20),
            child: Icon(Icons.settings, color: Colors.orange),
          ),
        ),
        title: Consumer<ProfileService>(
          builder: (context, value, child) {
            if (value.isLoading) {
              return const CupertinoActivityIndicator();
            } else {
              return Text('Hi,${value.profile?.name?.split(" ")[0]}');
            }
          },
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                context.go(RouteLocation.cart);
              })
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBannerCarousel(),
            _buildSectionTitle('What are you craving?'),
            _buildSearchBar(),
            _buildSectionTitle('Browse Categories'),
            _buildCategoryList(),
            _buildSectionTitle('Popular Dishes'),
            _buildPopularDishes(),
            _buildSectionTitle('Special Offers'),
            _buildSpecialOfferCard(),
            const SizedBox(
              height: 20,
            ),
            _buildPopularDishes(),
            _buildBannerCarousel(),
          ],
        ),
      ),
      // bottomNavigationBar: const RoundedBottomNavBar(),
    );
  }

  Widget _buildBannerCarousel() => SizedBox(
        height: 200,
        child: PageView.builder(
          itemCount: 3,
          itemBuilder: (context, index) => Padding(
            padding: const EdgeInsets.all(10.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset('assets/images/home_banner.png',
                  fit: BoxFit.cover),
            ),
          ),
        ),
      );

  Widget _buildSectionTitle(String title) => Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
      );

  Widget _buildSearchBar() => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search for food, restaurants...',
            prefixIcon: const Icon(Icons.search),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30.0),
              borderSide: const BorderSide(color: Colors.orangeAccent),
            ),
          ),
        ),
      );

  Widget _buildCategoryList() => SizedBox(
        height: 120,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: const [
            _CategoryCard(
                title: 'Pizza',
                icon: Icons.local_pizza,
                color: Colors.redAccent),
            _CategoryCard(
                title: 'Burgers',
                icon: Icons.fastfood,
                color: Colors.blueAccent),
            _CategoryCard(
                title: 'Desserts', icon: Icons.cake, color: Colors.pinkAccent),
            _CategoryCard(
                title: 'Drinks',
                icon: Icons.local_drink,
                color: Colors.greenAccent),
          ],
        ),
      );

// Import your product model

  Widget _buildPopularDishes() => Consumer<ProductService>(
        builder: (context, productService, child) {
          if (productService.isLoading) {
            return SizedBox(
              height: 280,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5, // Show 5 shimmer items as placeholders
                itemBuilder: (context, index) {
                  return _buildShimmerCard();
                },
              ),
            );
          } else {
            return SizedBox(
              height: 320,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: productService.products.length,
                itemBuilder: (context, index) {
                  Products product = productService.products[index];
                  return FoodItemCard(
                    isLoading: product.isLoading,
                    cartQuantity: product.cart?.quantity ?? 0,
                    productId: product.id!,
                    title: product.name ?? '',
                    imagePath: product.image ?? '',
                    price: product.price ?? 0,
                    description: product.description ?? '',
                  );
                },
              ),
            );
          }
        },
      );

  /// **Shimmer Placeholder for Loading State**
  Widget _buildShimmerCard() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade100,
        child: Container(
          width: 160,
          height: 280,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Image Placeholder
              Container(
                width: 160,
                height: 120,
                decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                ),
              ),
              const SizedBox(height: 8),

              /// Title Placeholder
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  width: 100,
                  height: 16,
                  color: Colors.grey,
                ),
              ),

              const SizedBox(height: 6),

              /// Description Placeholder
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Container(
                  width: 120,
                  height: 12,
                  color: Colors.grey,
                ),
              ),

              const Spacer(),

              /// Price & Button Placeholder
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      width: 50,
                      height: 16,
                      color: Colors.grey,
                    ),
                    Container(
                      width: 50,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSpecialOfferCard() => Container(
        padding: const EdgeInsets.all(10),
        margin: const EdgeInsets.symmetric(horizontal: 16.0),
        decoration: BoxDecoration(
            color: Colors.orangeAccent,
            borderRadius: BorderRadius.circular(15)),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.local_offer, color: Colors.white, size: 40),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Get 20% off on first order',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
                Text('Use code FIRST20',
                    style: TextStyle(fontSize: 14, color: Colors.white)),
              ],
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.white),
          ],
        ),
      );
}

class _CategoryCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Color color;

  const _CategoryCard(
      {required this.title, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          color: color,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, color: Colors.white, size: 40),
                const SizedBox(height: 5),
                Text(title,
                    style: const TextStyle(color: Colors.white, fontSize: 16)),
              ],
            ),
          ),
        ),
      );
}

class FoodItemCard extends StatelessWidget {
  final String title;
  final String imagePath;
  final double price;
  final String description;
  final int productId;
  final int cartQuantity;
  final bool isLoading;

  const FoodItemCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.price,
    required this.description,
    required this.productId,
    required this.cartQuantity,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final productService = Provider.of<ProductService>(context);
    int quantity = cartQuantity;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: SizedBox(
        width: 200,
        child: Card(
          color: Colors.white,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(15)),
                child: AspectRatio(
                  aspectRatio: 4 / 3.7,
                  child: CachedNetworkImage(
                    imageUrl: imagePath,
                    fit: BoxFit.cover,
                    errorWidget: (context, url, error) => const Center(
                      child: Icon(Icons.image_not_supported,
                          size: 50, color: Colors.grey),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  description,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const Spacer(),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '₹${price.toStringAsFixed(2)}',
                      style: const TextStyle(
                          fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    quantity == 0
                        ? SizedBox(
                            height: 30, // Ensures uniform height
                            child: ElevatedButton(
                              onPressed: isLoading
                                  ? null
                                  : () => productService.addToCart(
                                        CartItems(
                                            productId: productId, quantity: 1),
                                      ),
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                backgroundColor: Colors.orange,
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      width: 14,
                                      height: 14,
                                      child: CircularProgressIndicator(
                                          color: Colors.white, strokeWidth: 2),
                                    )
                                  : const Text("Add",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.white)),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: Colors.orange.shade100,
                            ),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 2),
                            child: isLoading
                                ? const Padding(
                                    padding: EdgeInsets.all(4),
                                    child: SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2, color: Colors.orange),
                                    ),
                                  )
                                : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.remove,
                                            color: Colors.orange, size: 18),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () => productService
                                            .decreaseQuantity(productId),
                                      ),
                                      Text(
                                        '$quantity',
                                        style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.add,
                                            color: Colors.orange, size: 18),
                                        padding: EdgeInsets.zero,
                                        constraints: const BoxConstraints(),
                                        onPressed: () => productService
                                            .increaseQuantity(productId),
                                      ),
                                    ],
                                  ),
                          ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
