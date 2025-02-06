import 'dart:math';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import '../widgets/rounded_bottom_nav_bar.dart';

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
      appBar: AppBar(
        title: const Text('Hi, Kishan'),
        actions: [
          IconButton(icon: const Icon(Icons.shopping_cart), onPressed: () {})
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
          ],
        ),
      ),
      bottomNavigationBar: const RoundedBottomNavBar(),
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

  Widget _buildPopularDishes() => SizedBox(
        height: 250,
     
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: const [
            FoodItemCard(
                title: 'Chicken Biryani',
                imagePath: 'assets/images/biryani.jpg',
                price: 200),
            FoodItemCard(
                title: 'Sattu ki Litti',
                imagePath: 'assets/images/litti.jpg',
                price: 100),
            FoodItemCard(
                title: 'Chocolate Cake',
                imagePath: 'assets/images/biryani.jpg',
                price: 500),
          ],
        ),
      );

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

class FoodItemCard extends StatefulWidget {
  final String title;
  final String imagePath;
  final double price;

  const FoodItemCard({
    super.key,
    required this.title,
    required this.imagePath,
    required this.price,
  });

  @override
  State<FoodItemCard> createState() => _FoodItemCardState();
}

class _FoodItemCardState extends State<FoodItemCard> {
  int itemCount = 0;

  void _incrementItemCount() {
    setState(() {
      itemCount++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Card(
          color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.asset(
                  widget.imagePath,
                
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  widget.title,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              const Padding(
              padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('Product Description goes here',style: TextStyle(color: Colors.grey,fontSize: 10),),
              ),
           
              const SizedBox(height: 5),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Row(
                  children: [
                    Text(
                      '\u{20B9} ${widget.price.toStringAsFixed(2)}',
                      style: const TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
      
              // Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(10),
              //   ),
              //   padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              //   child: Row(
              //     mainAxisSize: MainAxisSize.min,
              //     children: [
              //       IconButton(
              //         icon: const Icon(Icons.remove_circle_outline,
              //             color: Colors.grey),
              //         onPressed: () {},
              //       ),
              //       Padding(
              //         padding: const EdgeInsets.symmetric(horizontal: 10),
              //         child: Text(
              //           '$itemCount',
              //           style: const TextStyle(
              //               fontSize: 16, fontWeight: FontWeight.bold),
              //         ),
              //       ),
              //       IconButton(
              //         icon: const Icon(Icons.add_circle_outline,
              //             color: Colors.grey),
              //         onPressed: _incrementItemCount,
              //       ),
              //     ],
              //   ),
              // ),
           
            ],
          ),
        ),
      ),
    );
  }
}
