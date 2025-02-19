import 'package:flutter/material.dart';
import 'package:fudo/src/core/features/auth/models/profile.dart';
import 'package:fudo/src/core/features/auth/service/profile_service.dart';
import 'package:fudo/src/core/router/route_location.dart';
import 'package:fudo/src/utils.dart/token_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  void initState() {
    context.read<ProfileService>().getProfile();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("My Profile",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {}, // Settings action
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Consumer<ProfileService>(
            builder: (context, value, child) {
              if (value.isLoading) {
                return _buildShimmerLoading(); // Use shimmer instead of CircularProgressIndicator
              } else {
                return Column(
                  children: [
                    _buildProfileHeader(value.profile!),
                    const SizedBox(height: 10),
                    _buildProfileMenu(context),
                    const SizedBox(height: 20),
                    const Text("App Version 2.3",
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                    const SizedBox(height: 10),
                  ],
                );
              }
            },
          ),
        ),
      ),
    );
  }

  /// **Shimmer Loading Effect**
  Widget _buildShimmerLoading() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 20),
      child: Column(
        children: [
          Shimmer.fromColors(
            baseColor: Colors.grey[300]!,
            highlightColor: Colors.grey[100]!,
            child: const CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
            ),
          ),
          const SizedBox(height: 10),
          _shimmerContainer(height: 20, width: 150),
          const SizedBox(height: 5),
          _shimmerContainer(height: 14, width: 200),
          const SizedBox(height: 20),
          _shimmerContainer(height: 40, width: 120),
          const SizedBox(height: 30),
          for (int i = 0; i < 5; i++) ...[
            _shimmerListTile(),
            if (i < 4) _buildDivider(),
          ],
        ],
      ),
    );
  }

  /// **Shimmer for Menu Items**
  Widget _shimmerListTile() {
    return ListTile(
      leading: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: const CircleAvatar(radius: 20, backgroundColor: Colors.white),
      ),
      title: _shimmerContainer(height: 16, width: 150),
      trailing: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: const Icon(Icons.arrow_forward_ios, size: 16),
      ),
    );
  }

  /// **Reusable Shimmer Container**
  Widget _shimmerContainer({double height = 20, double width = double.infinity}) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(Profile profile) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            const CircleAvatar(
              radius: 40,
              child: Icon(Icons.person), // Replace with actual image
            ),
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.blue.shade600,
              ),
              padding: const EdgeInsets.all(5),
              child: const Icon(Icons.camera_alt, size: 16, color: Colors.white),
            ),
          ],
        ),
        const SizedBox(height: 10),
         Text(
          profile.name ?? '',
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
        ),
         Text(profile.email ?? '',
            style: const TextStyle(color: Colors.grey, fontSize: 14)),
        const SizedBox(height: 15),
      ],
    );
  }

  Widget _buildProfileMenu(BuildContext context) {
    return Column(
      children: [
        _buildMenuItem(Icons.favorite_border, "Favourites", onTap: () {}),
        _buildDivider(),
        _buildMenuItem(Icons.location_on_outlined, "Location", onTap: () {}),
        _buildMenuItem(Icons.subscriptions, "Subscription", onTap: () {}),
        _buildDivider(),
        _buildMenuItem(Icons.shop, "My Orders", onTap: () => {}),
        _buildMenuItem(Icons.history, "Clear History", onTap: () {}),
        _buildMenuItem(Icons.logout, "Log Out", isDestructive: true,
            onTap: () async {
          await TokenStorage.instance.deleteToken();
          if (context.mounted) {
            context.go(RouteLocation.loginScreen);
          }
        }),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title,
      {bool isDestructive = false, required Function() onTap}) {
    return ListTile(
      leading: Icon(icon, color: isDestructive ? Colors.red : Colors.black),
      title: Text(title,
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: isDestructive ? Colors.red : Colors.black)),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: onTap,
    );
  }

  Widget _buildDivider() {
    return const Divider(thickness: 1, indent: 16, endIndent: 16, color: Colors.grey);
  }
}
