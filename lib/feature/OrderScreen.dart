import 'package:cafe_app/shared/color/colors.dart';
import 'package:cafe_app/navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  bool _showOrder = true;

  void _goToMenu() {
    Get.find<NavigationController>().goTo(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: AuthTabs(
                isSignIn: _showOrder,
                onChanged: (showOrder) => setState(() => _showOrder = showOrder),
              ).animate().fade(duration: 400.ms).slideY(begin: 0.1, end: 0),
            ),
            Expanded(
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0, 0.05),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
                child: KeyedSubtree(
                  key: ValueKey(_showOrder),
                  child: _showOrder
                      ? _OrderContent(onOrderDrink: _goToMenu)
                      : HistoryScreen(onOrderAgain: _goToMenu),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderContent extends StatelessWidget {
  const _OrderContent({required this.onOrderDrink});

  final VoidCallback onOrderDrink;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 40),
          child: CustomPaint(
            foregroundPainter: _DashedRRectPainter(
              color: AppColors.caramel.withOpacity(0.8),
              radius: 30,
              dashWidth: 3,
              dashGap: 3,
            ),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    decoration: const BoxDecoration(
                      color: AppColors.sand,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Iconsax.receipt,
                      size: 36,
                      color: AppColors.clay,
                    ),
                  ).animate().fade(duration: 400.ms, delay: 150.ms).scale(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                  ),
                  const SizedBox(height: 22),
                  Text(
                    'No active order',
                    style: GoogleFonts.fraunces(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: AppColors.espresso,
                    ),
                  ).animate().fade(duration: 400.ms, delay: 250.ms).slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 12),
                  Text(
                    "Place an order and you'll see live\n progress here.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      height: 1.45,
                      color: AppColors.clay,
                    ),
                  ).animate().fade(duration: 400.ms, delay: 300.ms).slideY(begin: 0.1, end: 0),
                  const SizedBox(height: 26),
                  ElevatedButton(
                    onPressed: onOrderDrink,
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      backgroundColor: AppColors.caramel,
                      foregroundColor: AppColors.espresso,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 28,
                        vertical: 14,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28),
                      ),
                    ),
                    child: Text(
                      'Order a drink',
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ).animate().fade(duration: 400.ms, delay: 350.ms).slideY(begin: 0.1, end: 0),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _DashedRRectPainter extends CustomPainter {
  final Color color;
  final double radius;
  final double dashWidth;
  final double dashGap;

  _DashedRRectPainter({
    required this.color,
    required this.radius,
    this.dashWidth = 5,
    this.dashGap = 4,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(0, 0, size.width, size.height),
      Radius.circular(radius),
    );

    final path = Path()..addRRect(rrect);
    final dashedPath = Path();

    for (final metric in path.computeMetrics()) {
      double distance = 0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        dashedPath.addPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          Offset.zero,
        );
        distance = next + dashGap;
      }
    }

    canvas.drawPath(dashedPath, paint);
  }

  @override
  bool shouldRepaint(covariant _DashedRRectPainter oldDelegate) => false;
}

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key, required this.onOrderAgain});

  final VoidCallback onOrderAgain;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _builddrinkHistory(
              1, 'INV-001', 'Cappuccino', 'Dine-in',
              '2023-08-15 10:30 AM . ', 'Completed',
              Colors.green.withOpacity(0.5), 4.99,
            ).animate().fade(duration: 500.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),
             _builddrinkHistory(
              1, 'INV-001', 'Cappuccino', 'Dine-in',
              '2023-08-15 10:30 AM . ', 'Completed',
              Colors.green.withOpacity(0.5), 4.99,
            ).animate().fade(duration: 500.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),
             _builddrinkHistory(
              1, 'INV-001', 'Cappuccino', 'Dine-in',
              '2023-08-15 10:30 AM . ', 'Completed',
              Colors.green.withOpacity(0.5), 4.99,
            ).animate().fade(duration: 500.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),
          ],
        ),
      ),
    );
  }

  Widget _builddrinkHistory(
    int count, String InvoiceNo, String drinkName,
    String OrderType, String Datetime, String status,
    Color statusColor, double Price,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.sand, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                InvoiceNo,
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.espresso,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                alignment: Alignment.center,
                child: Text(
                  status.toUpperCase(),
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            Datetime + OrderType,
            style: GoogleFonts.inter(
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.clay,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$count x $drinkName',
                style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: AppColors.clay,
                ),
              ),
              Text(
                '\$ $Price',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.espresso,
                ),
              ),
            ],
          ),
          Container(
            margin: const EdgeInsets.only(top: 20, bottom: 20),
            height: 0.5,
            color: AppColors.caramel.withOpacity(0.5),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '\$ $Price',
                style: GoogleFonts.inter(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.espresso,
                ),
              ),
              ElevatedButton(
                onPressed: onOrderAgain,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: AppColors.white,
                  foregroundColor: AppColors.espresso,
                  padding: const EdgeInsets.all(10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(28),
                    side: const BorderSide(color: AppColors.espresso, width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.refresh, size: 18, color: AppColors.espresso),
                    const SizedBox(width: 6),
                    Text(
                      ' Order again',
                      style: GoogleFonts.inter(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class AuthTabs extends StatelessWidget {
  const AuthTabs({
    super.key,
    required this.isSignIn,
    required this.onChanged,
  });

  final bool isSignIn;
  final ValueChanged<bool> onChanged;

  static const _radius = 14.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: AppColors.sand,
        borderRadius: BorderRadius.circular(18),
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final tabWidth = constraints.maxWidth / 2;

          return Stack(
            children: [
              AnimatedPositioned(
                duration: const Duration(milliseconds: 320),
                curve: Curves.easeOutCubic,
                left: isSignIn ? 0 : tabWidth,
                top: 0,
                bottom: 0,
                width: tabWidth,
                child: Container(
                  decoration: BoxDecoration(
                    color: AppColors.espresso,
                    borderRadius: BorderRadius.circular(_radius),
                  ),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: _tab(
                      icon: Iconsax.receipt,
                      label: 'Order',
                      selected: isSignIn,
                      onTap: () => onChanged(true),
                    ),
                  ),
                  Expanded(
                    child: _tab(
                      icon: Icons.history_outlined,
                      label: 'History',
                      selected: !isSignIn,
                      onTap: () => onChanged(false),
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _tab({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    final textTheme = GoogleFonts.interTextTheme();
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(_radius),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, size: 18, color: selected ? Colors.white : AppColors.clay),
            const SizedBox(width: 6),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              style: (textTheme.bodyMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: selected ? Colors.white : AppColors.clay,
                  )) ??
                  const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.clay,
                  ),
              child: Text(label),
            ),
          ],
        ),
      ),
    );
  }
}
