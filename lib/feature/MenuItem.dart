import 'package:cafe_app/shared/color/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:flutter_animate/flutter_animate.dart';

class MenuItem extends StatefulWidget {
  const MenuItem({super.key});

  @override
  State<MenuItem> createState() => _MenuItemState();
}

class _CategoryData {
  final String title;
  final IconData icon;

  _CategoryData(this.title, this.icon);
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

class _OptionData {
  final String name;
  final String description;
  final double price;

  const _OptionData(this.name, this.description, this.price);
}

class _MenuItemState extends State<MenuItem> {
  int selectedCategoryIndex = 0;
  bool isFiltered = false;
  final ScrollController _scrollController = ScrollController();
  final List<GlobalKey> _sectionKeys = [];

  int cartItemCount = 0;
  double cartTotalPrice = 0.0;

  final List<_CategoryData> _categories = [
    _CategoryData('ALL', Iconsax.element_4),
    _CategoryData('BEST SELLERS', Iconsax.magic_star),
    _CategoryData('HOT COFFEE', Iconsax.cup),
    _CategoryData('ICED COFFEE', Icons.local_drink_outlined),
    _CategoryData('TEA & MATCHA', Icons.eco_outlined),
    _CategoryData('BAKERY', Iconsax.cake),
    _CategoryData('FRAPPE', Iconsax.milk),
  ];

  final List<_MenuData> _menuItems = [
    _MenuData(
      badge: 'Best Drink',
      title: 'Signature Iced Latte',
      subtitle: 'Double shot, oat-friendly, layered over ice',
      price: 4.25,
      image: const AssetImage('assets/images/coffeeImage.jpg'),
      category: 'Iced Coffee',
    ),
    _MenuData(
      badge: 'Best Seller',
      title: 'Coconut Cream Latte',
      subtitle: 'Rich coconut cream, bold shot pulled fresh',
      price: 2.43,
      image: const AssetImage('assets/images/coffeeImage.jpg'),
      category: 'Espresso',
    ),
    _MenuData(
      badge: 'Best Seller',
      title: 'Iced Thnol Coffee',
      subtitle: 'Refreshing iced thnol coffee',
      price: 2.43,
      image: const AssetImage('assets/images/coffeeImage.jpg'),
      category: 'Iced Coffee',
    ),
    _MenuData(
      badge: 'Best Seller',
      title: 'Fresh Passion Juice',
      subtitle: 'Fresh passion fruit juice',
      price: 2.43,
      image: const AssetImage('assets/images/coffeeImage.jpg'),
      category: 'Frappe',
    ),
    _MenuData(
      badge: 'New',
      title: 'Matcha Latte',
      subtitle: 'Ceremonial grade, silky steamed milk',
      price: 4.75,
      image: const AssetImage('assets/images/coffeeImage.jpg'),
      category: 'Tea & Matcha',
    ),
    _MenuData(
      badge: 'Popular',
      title: 'Butter Croissant',
      subtitle: 'Flaky, buttery, baked daily',
      price: 3.50,
      image: const AssetImage('assets/images/coffeeImage.jpg'),
      category: 'Bakery',
    ),
  ];

  Map<String, List<_MenuData>> get _groupedItems {
    Map<String, List<_MenuData>> map = {};
    for (var cat in _categories) {
      if (cat.title == 'ALL') continue;
      
      if (cat.title == 'BEST SELLERS') {
         map[cat.title] = _menuItems.where((m) => m.badge.toLowerCase().contains('best')).toList();
      } else {
         map[cat.title] = _menuItems.where((m) => m.category.toLowerCase() == cat.title.toLowerCase()).toList();
      }
    }
    return map;
  }

  @override
  void initState() {
    super.initState();
    for (int i = 1; i < _categories.length; i++) {
      _sectionKeys.add(GlobalKey());
    }
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (isFiltered) return; 
    if (!_scrollController.hasClients) return;
    
    int activeIndex = 1; 
    
    for (int i = 1; i < _categories.length; i++) {
      final key = _sectionKeys[i - 1];
      if (key.currentContext != null) {
        final RenderBox renderBox = key.currentContext!.findRenderObject() as RenderBox;
        final y = renderBox.localToGlobal(Offset.zero).dy;
        
        if (y < 320) {
          activeIndex = i;
        }
      }
    }
    
    if (_scrollController.offset <= 10) {
      activeIndex = 0; 
    } else {
      if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 50) {
         activeIndex = _categories.length - 1;
      }
    }

    if (selectedCategoryIndex != activeIndex) {
      setState(() {
        selectedCategoryIndex = activeIndex;
      });
    }
  }

  void _onCategoryTap(int index) {
    if (index == 0) {
      setState(() {
        selectedCategoryIndex = index;
        isFiltered = false;
      });
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeOutCubic,
      );
    } else {
      setState(() {
        selectedCategoryIndex = index;
        isFiltered = true;
      });
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
      );
    }
  }

  void _openSearchScreen() {
    Navigator.of(context).push(MaterialPageRoute(builder: (context) {
      return Scaffold(
        backgroundColor: AppColors.white,
        appBar: AppBar(
          backgroundColor: AppColors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.espresso),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: TextField(
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search drinks...',
              border: InputBorder.none,
              hintStyle: GoogleFonts.inter(color: AppColors.clay),
            ),
          ),
        ),
      );
    }));
  }

  void _showItemDetailSheet(_MenuData item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => _MenuDetailSheet(
        item: item,
        onAddToCart: (double totalPrice) {
          setState(() {
            cartItemCount++;
            cartTotalPrice += totalPrice;
          });
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _openSearchScreen,
                child: Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.caramel.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.espresso.withOpacity(0.04),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Icon(Iconsax.search_normal, color: AppColors.clay, size: 22),
                ),
              ),
              Container(
                width: 48,
                height: 48,
                decoration: const BoxDecoration(
                  color: AppColors.espresso,
                  shape: BoxShape.circle,
                ),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const Icon(Iconsax.bag_2, color: AppColors.white, size: 22),
                    if (cartItemCount > 0)
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: AppColors.caramel,
                            shape: BoxShape.circle,
                          ),
                          child: Text(
                            '$cartItemCount',
                            style: GoogleFonts.inter(
                              color: AppColors.espresso,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
          Text(
            'Menu',
            style: GoogleFonts.fraunces(
              color: AppColors.espresso,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(int index) {
    final cat = _categories[index];
    final bool isSelected = selectedCategoryIndex == index;

    return GestureDetector(
      onTap: () => _onCategoryTap(index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.espresso : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.caramel : AppColors.white,
                shape: BoxShape.circle,
                border: isSelected ? null : Border.all(color: AppColors.caramel.withOpacity(0.5)),
                boxShadow: isSelected
                    ? []
                    : [
                        BoxShadow(
                          color: AppColors.espresso.withOpacity(0.05),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
              ),
              child: Icon(
                cat.icon,
                color: AppColors.espresso,
                size: 24,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              cat.title,
              style: GoogleFonts.inter(
                color: isSelected ? AppColors.white : AppColors.espresso,
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
      ),
    ).animate().fade(duration: 400.ms, delay: (index * 50).ms).slideX(begin: 0.2, end: 0);
  }

  Widget _buildCategoriesBar() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(
          _categories.length,
          (index) => _buildCategoryItem(index),
        ),
      ),
    );
  }

  Widget _buildList(List<_MenuData> items) {
    if (items.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Text(
            'No items available.',
            style: GoogleFonts.inter(color: AppColors.clay, fontSize: 16),
          ),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return _MenuListItem(
          item: item,
          onTap: () => _showItemDetailSheet(item),
        ).animate().fade(duration: 400.ms, delay: (index * 50).ms).slideY(begin: 0.1, end: 0);
      },
    );
  }

  Widget _buildCartFooter() {
    if (cartItemCount == 0) return const SizedBox.shrink();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: const BoxDecoration(
        color: AppColors.white,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.espresso,
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: AppColors.espresso.withOpacity(0.2),
              blurRadius: 10,
              offset: const Offset(0, -2),
            )
          ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: AppColors.sand,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Iconsax.bag_2, color: AppColors.espresso, size: 20),
                ),
                const SizedBox(width: 12),
                Text(
                  '$cartItemCount item${cartItemCount > 1 ? 's' : ''} in cart',
                  style: GoogleFonts.inter(
                    color: AppColors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            Text(
              'View â€¢ \$${cartTotalPrice.toStringAsFixed(2)}',
              style: GoogleFonts.inter(
                color: AppColors.sand,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, List<_MenuData>> grouped = _groupedItems;

    return Scaffold(
      backgroundColor: AppColors.cream,
      bottomNavigationBar: _buildCartFooter(),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 8),
            _buildCategoriesBar(),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 40),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
                    transitionBuilder: (child, animation) => FadeTransition(
                      opacity: animation,
                      child: SlideTransition(
                        position: Tween<Offset>(begin: const Offset(0.0, 0.05), end: Offset.zero).animate(animation),
                        child: child,
                      ),
                    ),
                    child: KeyedSubtree(
                      key: ValueKey('$isFiltered-$selectedCategoryIndex'),
                      child: isFiltered
                          ? _buildList(grouped[_categories[selectedCategoryIndex].title] ?? [])
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                            for (int i = 1; i < _categories.length; i++) ...[
                              if ((grouped[_categories[i].title] ?? []).isNotEmpty) ...[
                                Padding(
                                  key: _sectionKeys[i - 1],
                                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 16),
                                  child: Row(
                                    children: [
                                      Icon(
                                        _categories[i].icon, 
                                        color: AppColors.espresso, 
                                        size: 20
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        _categories[i].title.toUpperCase(),
                                        style: GoogleFonts.inter(
                                          color: AppColors.espresso,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                _buildList(grouped[_categories[i].title]!),
                              ]
                            ]
                          ],
                        ),
                      ),
                    ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuListItem extends StatelessWidget {
  final _MenuData item;
  final VoidCallback onTap;

  const _MenuListItem({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: AppColors.clay.withOpacity(0.1)),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.inter(
                    color: AppColors.espresso,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${item.price.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    color: AppColors.espresso,
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: item.image,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuDetailSheet extends StatefulWidget {
  final _MenuData item;
  final Function(double) onAddToCart;

  const _MenuDetailSheet({required this.item, required this.onAddToCart});

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
                  child: const Icon(Icons.close, color: AppColors.espresso, size: 20),
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
                          padding: EdgeInsets.only(right: index == _sizes.length - 1 ? 0 : 12),
                          child: _buildOptionChip(
                            name: _sizes[index].name,
                            description: _sizes[index].description,
                            price: _sizes[index].price,
                            isSelected: selectedSizeIndex == index,
                            onTap: () => setState(() => selectedSizeIndex = index),
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
                          padding: EdgeInsets.only(right: index == _sugarLevels.length - 1 ? 0 : 12),
                          child: _buildOptionChip(
                            name: _sugarLevels[index].name,
                            description: _sugarLevels[index].description,
                            isSelected: selectedSugarIndex == index,
                            onTap: () => setState(() => selectedSugarIndex = index),
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
                        padding: EdgeInsets.only(bottom: index == _toppings.length - 1 ? 0 : 12),
                        child: _buildTopping(index),
                      );
                    }),
                  ),
                  SizedBox(height: 16),
                  _buildSectionHeader('Note for the barista', required: false),
                  SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.caramel.withOpacity(0.4), width: 1),
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
                          side: BorderSide(color: AppColors.caramel.withOpacity(0.4)),
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
                          side: BorderSide(color: AppColors.caramel.withOpacity(0.4)),
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
            onTap: () {
              widget.onAddToCart(_totalPrice);
              Navigator.of(context).pop();
            },
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
            color: isSelected ? AppColors.espresso : AppColors.caramel.withOpacity(0.4),
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
                description.length > 5 ? '${description.substring(0, 5)}...' : description,
                style: GoogleFonts.inter(
                  color: isSelected ? AppColors.white.withOpacity(0.7) : AppColors.espresso.withOpacity(0.6),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
              if (price != null) ...[
                SizedBox(width: 4),
                Text(
                  '+\$${price.toStringAsFixed(2)}',
                  style: GoogleFonts.inter(
                    color: isSelected ? AppColors.white.withOpacity(0.7) : AppColors.espresso.withOpacity(0.6),
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
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
            color: isSelected ? AppColors.espresso : AppColors.caramel.withOpacity(0.4),
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
                      color: isSelected ? AppColors.white.withOpacity(0.7) : AppColors.clay.withOpacity(0.8),
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
