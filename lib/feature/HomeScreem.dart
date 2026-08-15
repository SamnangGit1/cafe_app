import 'dart:ui';

import 'package:cafe_app/shared/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String txtmessage = '';

  int selectedIndex = 0;

  late final PageController _pageController;
  double _currentPage = 0;

 final List<_MenuData> _menuItems = [
    _MenuData(
      badge: 'ðŸ”¥ #1 THIS WEEK',
      title: 'Signature Iced Latte',
      subtitle: 'Double shot, oat-friendly, layered over ice',
      price: 3.75,
      image: const AssetImage('assets/images/coffeeImage.jpg'),
      category: 'Iced Coffee',
    ),
 ];
 final List<_PostData> _posts = [
    _PostData(
      badge: 'New',
      title: 'Ethiopia Yirgacheffe just landed',
      badgeColor: AppColors.caramel,
      badgeTextColor: AppColors.espresso,
      subtitle: 'Our new single origin brings jasmine, peach and a syrupy body. Roasted Tuesday, on the bar Wednesday.',
      image: const NetworkImage('https://cdn.magicpatterns.com/patterns/generated-images/b23fd88a-4759-4d0f-bc07-2cb1661cd7ac.jpg'),
      Datetime: 'Aug 4 Â· 3 min read',
      body: 'We cup dozens of lots each season and this Yirgacheffe stopped the room. Grown at 2,050m in the Gedeb woreda and washed at the Worka mill, it lands with jasmine on the nose, ripe peach in the cup and a syrupy sweetness that holds up beautifully as it cools.\n\nAsk your barista for it as a filter to taste it at its clearest, or try it as the base of an iced latte â€” the stone-fruit sweetness cuts straight through milk. Bags of 340g are available at the counter while the lot lasts.',
    ),
    _PostData(
      badge: 'Event',
      title: 'Latte art night â€” every Thursday',
      badgeColor: Colors.transparent,
      badgeTextColor: Colors.green,
      subtitle: 'Two hours behind the bar with our head barista. Free for Gold members, \$8 for everyone else.',
      image: const NetworkImage('https://cdn.magicpatterns.com/patterns/generated-images/c02ec6f2-4f70-4461-9bd9-7e628d8e1692.jpg'),
      Datetime: 'Jul 30 Â· 2 min read',
      body: 'Join us every Thursday evening for two hours of hands-on latte art with our head barista. You will learn the basics of milk steaming, free-pour rosettas and tulips, and walk away with enough technique to impress at home.\n\nGold members attend free. All others pay \$8 at the door â€” just walk in, no reservation needed. Runs 6 PM to 8 PM.',
    ),
  ];
  
  final List<_PromotionData> _promotions = [
    _PromotionData(
      promotionName: '15% OFF',
      txtTag: 'DISCOUNT',
      title: 'Early Riser',
      subtitle: 'Every espresso drink, 15% off before 10:00 AM.',
      txtBtn: 'EARLY15',
      image: const AssetImage('assets/images/promotionImage.jpg'),
    ),
    _PromotionData(
      promotionName: 'BUY 4',
      txtTag: 'BUNDLE',
      title: 'Fifth Cup Free',
      subtitle: 'Buy 4 iced coffees, get the 5th one free.',
      txtBtn: 'FIFTHCUP',
      image: const AssetImage('assets/images/promotionImage2.jpg'),
    ),
    _PromotionData(
      promotionName: '10% OFF',
      txtTag: 'WEEKEND',
      title: 'Matcha Weekend',
      subtitle: 'All matcha drinks 10% off, Saturday & Sunday.',
      txtBtn: 'MATCHA10',
      image: const AssetImage('assets/images/promotionImage3.jpg'),
    ),
  ];

  @override
  void initState() {
    super.initState();
    messagetime();
    _pageController = PageController(viewportFraction: 1.0);
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void messagetime() {
    if (DateTime.now().hour >= 6 && DateTime.now().hour < 12) {
      txtmessage = "Good morning";
    } else if (DateTime.now().hour >= 12 && DateTime.now().hour < 18) {
      txtmessage = "Good afternoon";
    } else {
      txtmessage = "Good evening";
    }
  }

 

  Widget _buildPromoBottomSheet(BuildContext context, _PromotionData promo) {
    final screenHeight = MediaQuery.sizeOf(context).height;
    final isCompact = screenHeight < 700;

    return Container(
      padding: EdgeInsets.all(isCompact ? 16 : 20),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.clay.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                promo.title,
                style: GoogleFonts.fraunces(
                  color: AppColors.espresso,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.sand,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close,
                      color: AppColors.espresso, size: 20),
                ),
              )
            ],
          ),
          SizedBox(height: 8),
          Text(
            promo.txtTag,
            style: GoogleFonts.inter(
              color: AppColors.clay,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          SizedBox(height: 12),
          Container(
            width: double.infinity,
            height: 1,
            color: AppColors.clay.withOpacity(0.2),
          ),
          SizedBox(height: isCompact ? 12 : 16),
          Container(
            width: double.infinity,
            height: isCompact ? 120 : 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              image: DecorationImage(
                image: promo.image,
                fit: BoxFit.cover,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.caramel,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Iconsax.tag,
                            color: AppColors.espresso, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          promo.promotionName,
                          style: GoogleFonts.inter(
                            color: AppColors.espresso,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: isCompact ? 12 : 16),
          Text(
            promo.subtitle,
            style: GoogleFonts.inter(
              color: AppColors.espresso,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          SizedBox(height: isCompact ? 12 : 16),
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: AppColors.sand,
              borderRadius: BorderRadius.circular(16),
            ),
            child: CustomPaint(
              foregroundPainter: _DashedRRectPainter(
                color: AppColors.clay.withOpacity(0.5),
                radius: 16,
                dashWidth: 6,
                dashGap: 4,
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'PROMO CODE',
                          style: GoogleFonts.inter(
                            color: AppColors.clay,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.0,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          promo.txtBtn,
                          style: GoogleFonts.fraunces(
                            color: AppColors.espresso,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.5,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {},
                      child: Row(
                        children: [
                          const Icon(Icons.copy_outlined,
                              color: AppColors.clay, size: 20),
                          const SizedBox(width: 6),
                          Text(
                            'Copy',
                            style: GoogleFonts.inter(
                              color: AppColors.clay,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: isCompact ? 12 : 16),
          _buildCardPromotion(Iconsax.calendar_tick,
              'Valid Period'.toUpperCase(), 'Jul 1 - Aug 31, 2024'),
          SizedBox(height: isCompact ? 10 : 16),
          _buildCardPromotion(Iconsax.info_circle, 'Terms',
              'Dine in or takeaway Â· Espresso category only'),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              color: AppColors.espresso,
              borderRadius: BorderRadius.circular(15),
            ),
            child: Center(
              child: Text(
                'Start an order',
                style: GoogleFonts.inter(
                  color: AppColors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCardPromotion(IconData icon, String title, String date) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.clay.withOpacity(0.2), width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.espresso.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.caramel.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, color: AppColors.clay, size: 24),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    color: AppColors.clay,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  date,
                  style: GoogleFonts.inter(
                    color: AppColors.espresso,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: 220,
                    width: double.infinity,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage('assets/images/WelcomImage.jpg'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          AppColors.espresso.withOpacity(0.95),
                          AppColors.espresso.withOpacity(0.75),
                          Colors.transparent,
                        ],
                        stops: const [0.0, 0.5, 1.0],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    top: 45,
                    child: Row(
                      children: [
                        const Icon(Iconsax.shop,
                            size: 22, color: AppColors.caramel),
                        const SizedBox(width: 8),
                        Text(
                          'Umber & Ash Cafe  Â·  Open till 9AM'.toUpperCase(),
                          style: GoogleFonts.inter(
                            color: AppColors.caramel,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 45,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$txtmessage, Sophea',
                          style: GoogleFonts.inter(
                            color: AppColors.caramel,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'What are we brewing today?',
                          style: GoogleFonts.fraunces(
                            color: AppColors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: -24,
                    child: Container(
                      height: 52,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.espresso.withOpacity(0.15),
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(Iconsax.search_normal,
                              size: 20, color: AppColors.clay),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              style: GoogleFonts.inter(
                                  color: AppColors.espresso, fontSize: 14),
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintText: 'Search latte, matcha, croissant...',
                                hintStyle: GoogleFonts.inter(
                                  color: AppColors.clay.withOpacity(0.6),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 48),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Offer today',
                      style: GoogleFonts.fraunces(
                        color: AppColors.espresso,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${_promotions.length} running',
                      style: GoogleFonts.inter(
                        color: AppColors.espresso,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(padding:EdgeInsetsGeometry.only(left: 20,right: 20),
              child:  SizedBox(
                height: 220,
                
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _promotions.length,
                  itemBuilder: (context, index) {
                    final double delta =
                        (_currentPage - index).abs().clamp(0.0, 1.0);
                    final double scale = 1 - (delta * 0.15);
                    final double opacity = 1 - (delta * 0.4);
                    final promo = _promotions[index];

                    return Center(
                      child: Opacity(
                        opacity: opacity,
                        child: Transform.scale(
                          scale: scale,
                          child: _PromotionCard(
                            promotionname: promo.promotionName,
                            txtTag: promo.txtTag,
                            title: promo.title,
                            subtitle: promo.subtitle,
                            txtbtn: promo.txtBtn,
                            image: promo.image,
                            onTap: () {
                              showModalBottomSheet(
                                context: context,
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                builder: (context) =>
                                    _buildPromoBottomSheet(context, promo),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ).animate().fade(duration: 500.ms, delay: 100.ms).slideY(begin: 0.1, end: 0),),
             
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(_promotions.length, (index) {
                  final bool isActive = _currentPage.round() == index;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 3),
                    height: 6,
                    width: isActive ? 18 : 6,
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppColors.espresso
                          : AppColors.clay.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(3),
                    ),
                  );
                }),
              ),
              SizedBox(height: 15),
              Padding(padding: EdgeInsets.only(left: 20,right: 20),
              child:
              _PromotionMessage(icon: Iconsax.gift, title: 'Get a free drink', Subtitle: 'Get a free drink on your birthday. Sign in to your account to claim it.').animate().fade(duration: 500.ms, delay: 150.ms).slideY(begin: 0.1, end: 0),
              ),
                SizedBox(height: 15),
              _buildTitleSection(Iconsax.cup, 'Best Drinks in this Week', 'See all'),
              SizedBox(height: 12),
              Container(
                height: 380,
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _MenuCard(
                  badge: _menuItems.first.badge,
                  title: _menuItems.first.title,
                  subtitle: _menuItems.first.subtitle,
                  price: _menuItems.first.price,
                  image: _menuItems.first.image,
                  heroTag: 'menu_${_menuItems.first.category}_0',
                  onImageTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (_) => _MenuDetailSheet(item: _menuItems.first),
                    );
                  },
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: Colors.transparent,
                      isScrollControlled: true,
                      builder: (_) => _MenuDetailSheet(item: _menuItems.first),
                    );
                  },
                ),
              ).animate().fade(duration: 500.ms, delay: 200.ms).slideY(begin: 0.1, end: 0),
              SizedBox(height: 20),
              Padding(padding:EdgeInsetsGeometry.only(left: 20,right: 20),
           child:  Column(
                children:[
                  const _TopMenuItem(number: '2', image: AssetImage('assets/images/coffeeImage.jpg'), title: 'Signature Iced Latte', price: 3.75, sold: '412 sold this week').animate().fade(duration: 500.ms, delay: 250.ms).slideY(begin: 0.1, end: 0),
                  const _TopMenuItem(number: '3', image: AssetImage('assets/images/coffeeImage.jpg'), title: 'Signature Iced Latte', price: 3.75, sold: '412 sold this week').animate().fade(duration: 500.ms, delay: 300.ms).slideY(begin: 0.1, end: 0),
                  const _TopMenuItem(number: '4', image: AssetImage('assets/images/coffeeImage.jpg'), title: 'Signature Iced Latte', price: 3.75, sold: '412 sold this week').animate().fade(duration: 500.ms, delay: 350.ms).slideY(begin: 0.1, end: 0),
                ]

              )
              ),
              SizedBox(height: 20),
              _buildTitleSection2( 'From the Caefe ', '3 Updates'),
              SizedBox(height: 12),
              Column(
                children: List.generate(_posts.length, (index) {
                  final post = _posts[index];
                  return Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20, bottom: 16),
                    child: SizedBox(
                      height: 290,
                      child: _PostCard(
                        badge: post.badge,
                        badgeColor: post.badgeColor,
                        badgeTextColor: post.badgeTextColor,
                        title: post.title,
                        subtitle: post.subtitle,
                        image: post.image,
                        Datetime: post.Datetime,
                        heroTag: 'post_$index',
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            builder: (_) => _PostDetailSheet(
                              badge: post.badge,
                              title: post.title,
                              image: post.image,
                              Datetime: post.Datetime,
                              body: post.body,
                            ),
                          );
                        },
                      ),
                    ),
                  ).animate().fade(duration: 500.ms, delay: (400 + index * 100).ms).slideY(begin: 0.1, end: 0);
                }),
              ),
              
             
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildTitleSection(IconData icon,String title,String viewmore){
    return 
    Padding(
      padding: EdgeInsetsGeometry.only(left: 20,right: 20),
      child:
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Icon(icon, color: AppColors.caramel, size: 20),
            const SizedBox(width: 8),
            Text(
              title,
              style: GoogleFonts.fraunces(
                color: AppColors.espresso,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            
          },
          child: Text(
            viewmore,
            style: GoogleFonts.inter(
              color: AppColors.clay,
              fontSize: 14,
              fontWeight: FontWeight.w600,
               decoration: TextDecoration.underline,
               decorationColor: AppColors.clay,
          ),
          )
       

        ),
      ],
    )
    );
  }
  Widget _buildTitleSection2(String title,String viewmore){
    return 
    Padding(
      padding: EdgeInsetsGeometry.only(left: 20,right: 20),
      child:
    Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        
        Text(
              title,
              style: GoogleFonts.fraunces(
                color: AppColors.espresso,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
        TextButton(
          onPressed: () {
            
          },
          child: Text(
            viewmore,
            style: GoogleFonts.inter(
              color: AppColors.clay,
              fontSize: 14,
              fontWeight: FontWeight.w600,
               
          ),
          )
       

        ),
      ],
    )
    );
  }
  
}

class _TopMenuItem extends StatefulWidget {
  final String number;
  final AssetImage image;
  final String title;
  final double price;
  final String sold;

  const _TopMenuItem({
    required this.number,
    required this.image,
    required this.title,
    required this.price,
    required this.sold,
  });

  @override
  State<_TopMenuItem> createState() => _TopMenuItemState();
}

class _TopMenuItemState extends State<_TopMenuItem> {
  bool _isActive = false;

  void _setActive(bool value) {
    if (_isActive != value) setState(() => _isActive = value);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _setActive(true),
      onExit: (_) => _setActive(false),
      child: GestureDetector(
        onTapDown: (_) => _setActive(true),
        onTapUp: (_) => _setActive(false),
        onTapCancel: () => _setActive(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            border: Border.all(
              color: _isActive ? AppColors.clay.withOpacity(0.2) : AppColors.caramel.withOpacity(0.2), 
              width: 1
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.caramel.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                widget.number, 
                style: GoogleFonts.fraunces(
                  color: AppColors.clay,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(width: 16),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: widget.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title, 
                      style: GoogleFonts.inter(
                        color: AppColors.espresso,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star, color: AppColors.caramel, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          '4.9', 
                          style: GoogleFonts.inter(
                            color: AppColors.caramel,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Â· ${widget.sold}', 
                            style: GoogleFonts.inter(
                              color: AppColors.clay,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '\$${widget.price.toStringAsFixed(2)}', 
                style: GoogleFonts.inter(
                  color: AppColors.espresso,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 16),
              AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: _isActive ? AppColors.caramel : AppColors.clay.withOpacity(0.2),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(
                  Iconsax.add,
                  color: AppColors.espresso,
                  size: 20,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
class _PromotionMessage extends StatefulWidget {
  final  IconData icon;
  

  final String title;
  final String Subtitle;


  const _PromotionMessage({
    required this.icon,
  
    required this.title,
    required this.Subtitle,
  });

  @override
  State<_PromotionMessage> createState() => _PromotionMessageState();
}

class _PromotionMessageState extends State<_PromotionMessage> {
  bool _isActive = false;

  void _setActive(bool value) {
    if (_isActive != value) setState(() => _isActive = value);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _setActive(true),
      onExit: (_) => _setActive(false),
      child: GestureDetector(
        onTapDown: (_) => _setActive(true),
        onTapUp: (_) => _setActive(false),
        onTapCancel: () => _setActive(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: double.infinity,
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: AppColors.espresso,
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            border: Border.all(
              color: _isActive ? AppColors.caramel : AppColors.clay.withOpacity(0.2), 
              width: 1
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.espresso.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.caramel,
                ),
                alignment: Alignment.center,
                child: Icon(widget.icon, color: AppColors.espresso, size: 28)
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.title, 
                      style: GoogleFonts.inter(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.Subtitle, 
                      style: GoogleFonts.inter(
                        color: AppColors.caramel.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              
              
              const SizedBox(width: 16),
              Icon(
                  Iconsax.arrow_right_3,
                  color: AppColors.caramel,
                  size: 20,
                ),
            
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuData {
  final String badge;
  final String title;
  final String subtitle;
  final double price;
  final AssetImage image;
  final String category;

  _MenuData({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.image,
    required this.category,
  });
}

class _MenuCard extends StatefulWidget {
  final String badge;
  final String title;
  final String subtitle;
  final double price;
  final AssetImage image;
  final String heroTag;
  final VoidCallback onImageTap;
  final VoidCallback onTap;

  const _MenuCard({
    required this.badge,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.image,
    required this.heroTag,
    required this.onImageTap,
    required this.onTap,
  });

  @override
  State<_MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<_MenuCard> {
  bool _isActive = false;

  // static const double _cardScale = 1.04;

  void _setActive(bool value) {
    if (_isActive != value) setState(() => _isActive = value);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _setActive(true),
      onExit: (_) => _setActive(false),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => _setActive(true),
        onTapUp: (_) => _setActive(false),
        onTapCancel: () => _setActive(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.espresso,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: AppColors.white.withOpacity(_isActive ? 0.18 : 0.1),
                blurRadius: _isActive ? 16 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      // Image only â€” zooms on hover
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: GestureDetector(
                            behavior: HitTestBehavior.opaque,
                            onTap: widget.onImageTap,
                            onTapDown: (_) => _setActive(true),
                            onTapUp: (_) => _setActive(false),
                            onTapCancel: () => _setActive(false),
                            child: AnimatedScale(
                              scale: _isActive ? 1.06 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              curve: Curves.easeOut,
                              child: Hero(
                                tag: widget.heroTag,
                                child: Image(
                                  image: widget.image,
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      // Badge â€” stays fixed, does NOT zoom
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.espresso,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.badge,
                            style: GoogleFonts.inter(
                              color: AppColors.caramel,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              widget.title,
                              style: GoogleFonts.fraunces(
                                color: AppColors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '\$${widget.price.toStringAsFixed(2)}',
                            style: GoogleFonts.fraunces(
                              color: AppColors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.subtitle,
                        style: GoogleFonts.inter(
                          color: AppColors.caramel,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.star, color: AppColors.caramel, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '4.9',
                                style: GoogleFonts.inter(
                                  color: AppColors.caramel,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                '412 sold this week',
                                style: GoogleFonts.inter(
                                  color: AppColors.caramel,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: widget.onTap,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 180),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: _isActive
                                    ? AppColors.white
                                    : AppColors.caramel,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Icon(
                                Iconsax.add,
                                color: _isActive
                                    ? AppColors.espresso
                                    : AppColors.espresso,
                                size: 22,
                              ),
                            ),
                          ),
                        ],
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
class _PostData {
  final String badge;
  final String title;
  final String subtitle;
  final Color badgeColor;
  final Color badgeTextColor;
  final ImageProvider image;
  final String Datetime;
  final String body;

  _PostData({
    required this.badge,
    required this.title,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.subtitle,
    required this.image,
    required this.Datetime,
    required this.body,
  });
}

class _PostCard extends StatefulWidget {
  final String badge;
  final Color badgeColor;
  final Color badgeTextColor;
  final String title;
  final String subtitle;
  final ImageProvider image;
  final String Datetime;
  final String heroTag;
  final VoidCallback onTap;

  const _PostCard({
    required this.badge,
    required this.badgeColor,
    required this.badgeTextColor,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.Datetime,
    required this.heroTag,
    required this.onTap,
  });

  @override
  State<_PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<_PostCard> {
  bool _isActive = false;

  void _setActive(bool value) {
    if (_isActive != value) setState(() => _isActive = value);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _setActive(true),
      onExit: (_) => _setActive(false),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => _setActive(true),
        onTapUp: (_) => _setActive(false),
        onTapCancel: () => _setActive(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          clipBehavior: Clip.antiAlias,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: _isActive ? AppColors.caramel : AppColors.clay.withOpacity(0.15),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.espresso.withOpacity(_isActive ? 0.12 : 0.06),
                blurRadius: _isActive ? 16 : 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 160,
                  child: Stack(
                    children: [
                      // Image only â€” zooms on hover
                      Positioned.fill(
                        child: ClipRRect(
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(16),
                            topRight: Radius.circular(16),
                          ),
                          child: AnimatedScale(
                            scale: _isActive ? 1.06 : 1.0,
                            duration: const Duration(milliseconds: 200),
                            curve: Curves.easeOut,
                            child: Image(
                              image: widget.image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                            ),
                          ),
                        ),
                      ),
                      // Badge â€” stays fixed, does NOT zoom
                      Positioned(
                        top: 12,
                        left: 12,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: widget.badgeColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            widget.badge,
                            style: GoogleFonts.inter(
                              color: widget.badgeTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: GoogleFonts.fraunces(
                          color: AppColors.espresso,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        widget.subtitle,
                        style: GoogleFonts.inter(
                          color: AppColors.clay,
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Iconsax.clock, color: AppColors.clay, size: 14),
                          const SizedBox(width: 5),
                          Text(
                            widget.Datetime,
                            style: GoogleFonts.inter(
                              color: AppColors.clay,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
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

class _PostDetailSheet extends StatelessWidget {
  final String badge;
  final String title;
  final ImageProvider image;
  final String Datetime;
  final String body;

  const _PostDetailSheet({
    required this.badge,
    required this.title,
    required this.image,
    required this.Datetime,
    required this.body,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.88,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: AppColors.cream,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // drag handle
          Center(
            child: Container(
              width: 40, height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.clay.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          // header row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.fraunces(
                        color: AppColors.espresso,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      badge,
                      style: GoogleFonts.inter(
                        color: AppColors.caramel,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.sand,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close, color: AppColors.espresso, size: 20),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // image
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image(
              image: image,
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 12),
          // date
          Row(
            children: [
              const Icon(Iconsax.clock, color: AppColors.clay, size: 14),
              const SizedBox(width: 5),
              Text(
                Datetime,
                style: GoogleFonts.inter(
                  color: AppColors.clay,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // body text
          Expanded(
            child: SingleChildScrollView(
              child: Text(
                body,
                style: GoogleFonts.inter(
                  color: AppColors.espresso,
                  fontSize: 15,
                  height: 1.7,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          // done button
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: AppColors.espresso,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Center(
                child: Text(
                  'Done reading',
                  style: GoogleFonts.inter(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _StaggeredCard extends StatefulWidget {
  final int index;
  final Widget child;

  const _StaggeredCard({required this.index, required this.child});

  @override
  State<_StaggeredCard> createState() => _StaggeredCardState();
}

class _StaggeredCardState extends State<_StaggeredCard> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 40 * widget.index), () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSlide(
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeOut,
      offset: _visible ? Offset.zero : const Offset(0, 0.08),
      child: AnimatedOpacity(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeOut,
        opacity: _visible ? 1 : 0,
        child: widget.child,
      ),
    );
  }
}


class _PromotionCard extends StatefulWidget {
  final String promotionname;
  final String txtTag;
  final String title;
  final String subtitle;
  final String txtbtn;
  final AssetImage image;
  final VoidCallback? onTap;

  const _PromotionCard({
    required this.promotionname,
    required this.txtTag,
    required this.title,
    required this.subtitle,
    required this.txtbtn,
    required this.image,
    this.onTap,
  });

  @override
  State<_PromotionCard> createState() => _PromotionCardState();
}

class _PromotionCardState extends State<_PromotionCard> {
  bool _isActive = false;

  void _setActive(bool value) {
    if (_isActive != value) setState(() => _isActive = value);
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => _setActive(true),
      onExit: (_) => _setActive(false),
      child: GestureDetector(
        onTap: widget.onTap,
        onTapDown: (_) => _setActive(true),
        onTapUp: (_) => _setActive(false),
        onTapCancel: () => _setActive(false),
        child: AnimatedContainer(
          clipBehavior: Clip.antiAlias,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          height: 220,
          width: double.infinity,
          
         // margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color:
                    AppColors.espresso.withOpacity(_isActive ? 0.28 : 0.15),
                blurRadius: _isActive ? 22 : 14,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              AnimatedScale(
                scale: _isActive ? 1.04 : 1.0,
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                child: Image(
                  image: widget.image,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      AppColors.espresso.withOpacity(0.95),
                      AppColors.espresso.withOpacity(0.75),
                      Colors.transparent,
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.caramel,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Iconsax.tag,
                                  color: AppColors.espresso, size: 14),
                              const SizedBox(width: 4),
                              Text(
                                widget.promotionname,
                                style: GoogleFonts.inter(
                                  color: AppColors.espresso,
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: AppColors.caramel,
                                  width: 1,
                                ),
                              ),
                              child: Text(
                                widget.txtTag,
                                style: GoogleFonts.inter(
                                  color: AppColors.caramel,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      widget.title,
                      style: GoogleFonts.fraunces(
                        color: AppColors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.subtitle,
                      style: GoogleFonts.inter(
                        color: AppColors.caramel,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _DashedButton(
                      label: widget.txtbtn,
                      isActive: _isActive,
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

class _DashedButton extends StatelessWidget {
  final String label;
  final bool isActive;

  const _DashedButton({required this.label, required this.isActive});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      foregroundPainter: _DashedRRectPainter(
        color: AppColors.caramel.withOpacity(0.9),
        radius: 10,
        dashWidth: 3,
        dashGap: 3,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.espresso.withOpacity(0.88),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: GoogleFonts.inter(
                color: AppColors.white,
                fontSize: 13,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 8),
            AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              transform: Matrix4.translationValues(
                isActive ? 6 : 0,
                0,
                0,
              ),
              child: const Icon(
                Icons.arrow_forward,
                color: AppColors.white,
                size: 16,
              ),
            ),
          ],
        ),
      ),
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

class _PromotionData {
  final String promotionName;
  final String txtTag;
  final String title;
  final String subtitle;
  final String txtBtn;
  final AssetImage image;

  _PromotionData({
    required this.promotionName,
    required this.txtTag,
    required this.title,
    required this.subtitle,
    required this.txtBtn,
    required this.image,
  });
}

class _OptionData {
  final String name;
  final String description;
  final double price;

  const _OptionData(this.name, this.description, this.price);
}
class _MenuDetailSheet extends StatefulWidget {
  final _MenuData item;

  const _MenuDetailSheet({required this.item});

  @override
  State<_MenuDetailSheet> createState() => _MenuDetailSheetState();
}

class _MenuDetailSheetState extends State<_MenuDetailSheet> {
  static const List<_OptionData> _sizes = [
    _OptionData('Small', '8 oz', 0.0),
    _OptionData('Medium', '16 oz', 0.50),
    _OptionData('Large', '20 oz', 1.00),
  ];
  static const List<_OptionData> _sugarLevels = [
    _OptionData('0%', 'No Sugar', 0.0),
    _OptionData('25%', 'Less Sugar', 0.0),
    _OptionData('50%', 'Half Sugar', 0.0),
    _OptionData('100%', 'Normal Sugar', 0.0),
  ];
  static const List<_OptionData> _milks = [
    _OptionData('Whole Milk', 'Creamy and rich', 0.0),
    _OptionData('Almond Milk', 'Nutty and smooth', 0.50),
    _OptionData('Oat Milk', 'Mild and creamy', 0.75),
    _OptionData('Soy Milk', 'Rich and protein-packed', 0.50),
  ];
  static const List<_OptionData> _toppings = [
    _OptionData('Extra Shot', '+1 espresso shot', 0.50),
    _OptionData('Tapioca Pearls', 'Gummy and chewy', 0.75),
    _OptionData('Caramel Drizzle', 'Sweet and buttery', 0.75),
  ];

  int selectedSizeIndex = 0;
  int selectedSugarIndex = 3;
  int selectedMilkIndex = 0;
  final Set<int> selectedToppings = {};
  int quantity = 1;
  final _noteController = TextEditingController();

  double get _unitPrice {
    double total = widget.item.price;
    total += _sizes[selectedSizeIndex].price;
    total += _milks[selectedMilkIndex].price;
    for (final i in selectedToppings) {
      total += _toppings[i].price;
    }
    return total;
  }

  double get _totalPrice => _unitPrice * quantity;

  void _increaseQuantity() => setState(() => quantity++);

  void _decreaseQuantity() {
    if (quantity > 1) setState(() => quantity--);
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.sizeOf(context).height * 0.9,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.cream,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 20),
              decoration: BoxDecoration(
                color: AppColors.clay.withOpacity(0.2),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  widget.item.title,
                  style: GoogleFonts.fraunces(
                    color: AppColors.espresso,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.sand,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.close,
                      color: AppColors.espresso, size: 20),
                ),
              )
            ],
          ),
          SizedBox(height: 12),
          Text(
            widget.item.subtitle,
            style: GoogleFonts.inter(
              color: AppColors.clay,
              fontSize: 14,
              height: 1.4,
            ),
          ),
          SizedBox(height: 20),
          Container(
            width: double.infinity,
            height: 1,
            color: AppColors.clay.withOpacity(0.2),
          ),
          SizedBox(height: 12),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
                    height: 150,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      image: DecorationImage(
                        image: widget.item.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildSectionHeader('Size', required: true),
                  const SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_sizes.length, (index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              right: index == _sizes.length - 1 ? 0 : 12),
                          child: _buildOptionChip(
                            name: _sizes[index].name,
                            description: _sizes[index].description,
                            price: _sizes[index].price,
                            isSelected: selectedSizeIndex == index,
                            onTap: () =>
                                setState(() => selectedSizeIndex = index),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildSectionHeader('Sugar Level', required: true),
                  SizedBox(height: 12),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(_sugarLevels.length, (index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              right:
                                  index == _sugarLevels.length - 1 ? 0 : 12),
                          child: _buildOptionChip(
                            name: _sugarLevels[index].name,
                            description: _sugarLevels[index].description,
                            isSelected: selectedSugarIndex == index,
                            onTap: () =>
                                setState(() => selectedSugarIndex = index),
                          ),
                        );
                      }),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildSectionHeader('Milk', required: true),
                  SizedBox(height: 12),
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 2,
                    children: List.generate(_milks.length, (index) {
                      return _buildOptionChip(
                        name: _milks[index].name,
                        description: _milks[index].description,
                        price: _milks[index].price,
                        isSelected: selectedMilkIndex == index,
                        onTap: () => setState(() => selectedMilkIndex = index),
                      );
                    }),
                  ),
                  SizedBox(height: 16),
                  _buildSectionHeader('Toppings', required: false),
                  SizedBox(height: 12),
                  Column(
                    children: List.generate(_toppings.length, (index) {
                      return Padding(
                        padding: EdgeInsets.only(
                            bottom: index == _toppings.length - 1 ? 0 : 12),
                        child: _buildTopping(index),
                      );
                    }),
                  ),
                  SizedBox(height: 16),
                  _buildSectionHeader('Note for the barista', required: false),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.caramel.withOpacity(0.4),
                          width: 1),
                    ),
                    child: TextField(
                      controller: _noteController,
                      maxLines: 3,
                      style: GoogleFonts.inter(
                        color: AppColors.espresso,
                        fontSize: 16,
                      ),
                      decoration: InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        hintText: 'Add a note for the barista...',
                        hintStyle: GoogleFonts.inter(
                          color: AppColors.clay.withOpacity(0.6),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  _buildSectionHeader('Quantity', required: false),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      IconButton(
                        onPressed: _decreaseQuantity,
                        icon: const Icon(Icons.remove, size: 20),
                        color: AppColors.espresso,
                        style: IconButton.styleFrom(
                          fixedSize: const Size(44, 44),
                          backgroundColor: AppColors.white,
                          side: BorderSide(
                              color: AppColors.caramel.withOpacity(0.4)),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        quantity.toString(),
                        style: GoogleFonts.inter(
                          color: AppColors.espresso,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 12),
                      IconButton(
                        onPressed: _increaseQuantity,
                        icon: const Icon(Icons.add, size: 20),
                        color: AppColors.espresso,
                        style: IconButton.styleFrom(
                          fixedSize: const Size(44, 44),
                          backgroundColor: AppColors.white,
                          side: BorderSide(
                              color: AppColors.caramel.withOpacity(0.4)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          SizedBox(height: 20),
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.espresso,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Add to cart',
                      style: GoogleFonts.inter(
                        color: AppColors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      '\$${_totalPrice.toStringAsFixed(2)}',
                      style: GoogleFonts.inter(
                        color: AppColors.caramel,
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    )
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {required bool required}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title.toUpperCase(),
          style: GoogleFonts.inter(
            color: AppColors.clay.withOpacity(0.8),
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          required ? 'required' : 'Optional',
          style: GoogleFonts.inter(
            color: AppColors.caramel.withOpacity(0.8),
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildOptionChip({
    required String name,
    required String description,
    double? price,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.espresso : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.espresso
                : AppColors.caramel.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              name,
              style: GoogleFonts.inter(
                color: isSelected ? AppColors.white : AppColors.espresso,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 4),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                description.length>5 ? '${description.substring(0, 5)}...' : description,
                style: GoogleFonts.inter(
                  color: isSelected
                      ? AppColors.white.withOpacity(0.7)
                      : AppColors.espresso.withOpacity(0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              
                SizedBox(width: 4),
                Text(
                  '+\$${price?.toStringAsFixed(2) ?? '0.00'}',
                  style: GoogleFonts.inter(
                    color: isSelected
                        ? AppColors.white.withOpacity(0.7)
                        : AppColors.espresso.withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              
            ])
          ],
        ),
      ),
    );
  }

  Widget _buildTopping(int index) {
    final topping = _toppings[index];
    final isSelected = selectedToppings.contains(index);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            selectedToppings.remove(index);
          } else {
            selectedToppings.add(index);
          }
        });
      },
      child: Container(
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.espresso : AppColors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppColors.espresso
                : AppColors.caramel.withOpacity(0.4),
            width: 1,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    topping.name,
                    style: GoogleFonts.inter(
                      color: isSelected ? AppColors.white : AppColors.espresso,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    topping.description,
                    style: GoogleFonts.inter(
                      color: isSelected
                          ? AppColors.white.withOpacity(0.7)
                          : AppColors.clay.withOpacity(0.8),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              '+\$${topping.price.toStringAsFixed(2)}',
              style: GoogleFonts.inter(
                color: isSelected ? AppColors.white : AppColors.espresso,
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
