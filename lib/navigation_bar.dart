import 'package:cafe_app/feature/HomeScreem.dart';
import 'package:cafe_app/feature/MenuItem.dart';
import 'package:cafe_app/feature/OrderScreen.dart';
import 'package:cafe_app/feature/ScanScreen.dart';

import 'package:cafe_app/shared/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:get/get.dart';
import 'dart:io';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}
class _NavigationMenuState extends State<NavigationMenu> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    
    return Scaffold(
      backgroundColor: AppColors.cream,
      bottomNavigationBar: Obx(
        () => SafeArea(
          top: false,
          child: Container(
            height: 72,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.cream,
               border: Border(
                top: BorderSide(
                  color: AppColors.sand,
                  width: 2,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _navigationItem(controller, 0, Iconsax.home, 'Home'),
                _navigationItem(controller, 1, Iconsax.coffee, 'Menu'),
                _navigationItem(controller, 2, Iconsax.scanner, 'Scan'),
                _navigationItem(controller, 3, Iconsax.receipt, 'Orders'),
                _navigationItem(controller, 4, Iconsax.user, 'Profile'),
              ],
            ),
          ),
        ),
      ),
      body: Obx(() {
        final currentIndex = controller.selectedIndex.value;
        return Stack(
          children: [
            // Only use fade or just show the screen directly since widgets will animate in
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: KeyedSubtree(
                key: ValueKey(currentIndex),
                child: controller.screens[currentIndex],
              ),
            ),
            Positioned.fill(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: controller.isLoading.value
                    ? _PageSkeleton(
                        key: ValueKey('loading_${controller.loadingIndex.value}'),
                        screenIndex: controller.loadingIndex.value,
                      )
                    : const SizedBox.shrink(key: ValueKey('empty')),
              ),
            ),
          ],
        );
      }),
    );
  }
  Widget _navigationItem(
    NavigationController controller,
    int index,
    IconData icon,
    String label,
  ) {
    final selected = controller.selectedIndex.value == index ||
        (controller.isLoading.value && controller.loadingIndex.value == index);

    return InkWell(
      onTap: () => controller.goTo(index),
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        width: selected ? 100 : 52,
        height: 56,
        decoration: BoxDecoration(
          color: selected ? AppColors.espresso : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: selected ? AppColors.white : AppColors.clay, size: 22),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.white : AppColors.clay,
                fontSize: 11,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final RxInt selectedIndex = 0.obs;
  final RxBool isLoading = false.obs;
  final RxInt loadingIndex = (-1).obs;
  int _navigationRequest = 0;

  final screens = [
    HomeScreen(),
    MenuItem(), // Menu
    ScanScreen(), // Scan
    OrderScreen(), 
    Container(), // Profile
  ];

  Future<void> goTo(int index) async {
    if (index == selectedIndex.value) return;

    final request = ++_navigationRequest;
    
    // Check internet connection speed/availability
    bool isFastInternet = false;
    try {
      // If DNS lookup finishes within 200ms, consider internet as 'fast'
      final result = await InternetAddress.lookup('google.com')
          .timeout(const Duration(milliseconds: 200));
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        isFastInternet = true;
      }
    } catch (_) {
      // Timeout or SocketException implies slow or no internet
      isFastInternet = false;
    }

    if (isFastInternet) {
      // Switch immediately without skeleton if internet is fast
      if (request == _navigationRequest) {
        isLoading.value = false;
        loadingIndex.value = -1;
        selectedIndex.value = index;
      }
      return;
    }

    // Show loading skeleton for slow or no internet
    loadingIndex.value = index;
    isLoading.value = true;

    // Minimum display time for the skeleton so it doesn't flash awkwardly
    await Future<void>.delayed(const Duration(milliseconds: 600));
    
    if (request == _navigationRequest) {
      isLoading.value = false;
      loadingIndex.value = -1;
      // Allow the skeleton to fade out before switching the screen
      await Future<void>.delayed(const Duration(milliseconds: 50));
      if (request == _navigationRequest) selectedIndex.value = index;
    }
  }
}

class _PageSkeleton extends StatefulWidget {
  const _PageSkeleton({super.key, required this.screenIndex});

  final int screenIndex;

  @override
  State<_PageSkeleton> createState() => _PageSkeletonState();
}

class _PageSkeletonState extends State<_PageSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1500),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: ColoredBox(
        color: AppColors.cream,
        child: SafeArea(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              final xOffset = (_controller.value * 2) - 1.0;
              return ShaderMask(
                blendMode: BlendMode.srcATop,
                shaderCallback: (bounds) {
                  return LinearGradient(
                    colors: [
                      AppColors.sand.withOpacity(0.3),
                      AppColors.white.withOpacity(0.8),
                      AppColors.sand.withOpacity(0.3),
                    ],
                    stops: const [0.1, 0.5, 0.9],
                    begin: Alignment(xOffset - 1, 0),
                    end: Alignment(xOffset + 1, 0),
                  ).createShader(bounds);
                },
                child: child,
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: _layoutFor(widget.screenIndex, 0.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _layoutFor(int screenIndex, double value) {
    if (screenIndex == 0) return _homeLayout(value);
    if (screenIndex == 1) return _menuLayout(value);
    if (screenIndex == 2) return _scanLayout(value);
    if (screenIndex == 3) return _ordersLayout(value);
    return _profileLayout(value);
  }

  Widget _homeLayout(double value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonBlock(width: 145, height: 24, value: value),
          const SizedBox(height: 22),
          _SkeletonBlock(width: double.infinity, height: 170, value: value),
          const SizedBox(height: 26),
          _SkeletonBlock(width: 110, height: 20, value: value),
          const SizedBox(height: 14),
          _SkeletonBlock(width: double.infinity, height: 115, value: value),
        ],
      );

  Widget _menuLayout(double value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SkeletonBlock(width: 100, height: 25, value: value),
          const SizedBox(height: 20),
          _SkeletonBlock(width: double.infinity, height: 45, value: value),
          const SizedBox(height: 22),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              childAspectRatio: .78,
              children: List.generate(
                4,
                (_) => _SkeletonBlock(width: double.infinity, height: double.infinity, value: value),
              ),
            ),
          ),
        ],
      );

  Widget _scanLayout(double value) => Column(
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: _SkeletonBlock(width: 100, height: 25, value: value),
          ),
          const Spacer(),
          _SkeletonBlock(width: 230, height: 230, value: value),
          const SizedBox(height: 18),
          _SkeletonBlock(width: 190, height: 16, value: value),
          const Spacer(),
        ],
      );

  Widget _ordersLayout(double value) => Column(
        children: [
          const SizedBox(height: 24),
          _SkeletonBlock(width: double.infinity, height: 52, value: value),
          const SizedBox(height: 28),
          _SkeletonBlock(width: double.infinity, height: 360, value: value),
        ],
      );

  Widget _profileLayout(double value) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: _SkeletonBlock(width: 86, height: 86, circle: true, value: value)),
          const SizedBox(height: 16),
          Center(child: _SkeletonBlock(width: 130, height: 20, value: value)),
          const SizedBox(height: 34),
          ...List.generate(
            4,
            (_) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: _SkeletonBlock(width: double.infinity, height: 58, value: value),
            ),
          ),
        ],
      );
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({
    required this.width,
    required this.height,
    required this.value,
    this.circle = false,
  });

  final double width;
  final double height;
  final double value;
  final bool circle;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.sand,
        shape: circle ? BoxShape.circle : BoxShape.rectangle,
        borderRadius: circle ? null : BorderRadius.circular(8),
      ),
    );
  }
}
