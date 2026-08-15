// // // // // // // final List<String> _categories = [
// // // // // // //     'All',
// // // // // // //     'Espresso',
// // // // // // //     'Iced Coffee',
// // // // // // //     'Tea & Matcha',
// // // // // // //     'Bakery',
// // // // // // //     'Frappe',
// // // // // // //   ];

// // // // // // //   // Menu data now carries a category so the grid can actually be filtered.
// // // // // // //   final List<_MenuData> _menuItems = [
// // // // // // //     _MenuData(
// // // // // // //       badge: 'Best Drink',
// // // // // // //       title: 'Signature Iced Latte',
// // // // // // //       subtitle: 'Double shot, oat-friendly, layered over ice',
// // // // // // //       price: 4.25,
// // // // // // //       image: const AssetImage('assets/images/coffeeImage.jpg'),
// // // // // // //       category: 'Iced Coffee',
// // // // // // //     ),
// // // // // // //     _MenuData(
// // // // // // //       badge: 'Best Seller',
// // // // // // //       title: 'Classic Espresso',
// // // // // // //       subtitle: 'Rich, bold shot pulled fresh',
// // // // // // //       price: 3.25,
// // // // // // //       image: const AssetImage('assets/images/coffeeImage.jpg'),
// // // // // // //       category: 'Espresso',
// // // // // // //     ),
// // // // // // //     _MenuData(
// // // // // // //       badge: 'New',
// // // // // // //       title: 'Matcha Latte',
// // // // // // //       subtitle: 'Ceremonial grade, silky steamed milk',
// // // // // // //       price: 4.75,
// // // // // // //       image: const AssetImage('assets/images/coffeeImage.jpg'),
// // // // // // //       category: 'Tea & Matcha',
// // // // // // //     ),
// // // // // // //     _MenuData(
// // // // // // //       badge: 'Popular',
// // // // // // //       title: 'Butter Croissant',
// // // // // // //       subtitle: 'Flaky, buttery, baked daily',
// // // // // // //       price: 3.50,
// // // // // // //       image: const AssetImage('assets/images/coffeeImage.jpg'),
// // // // // // //       category: 'Bakery',
// // // // // // //     ),
// // // // // // //     _MenuData(
// // // // // // //       badge: 'Chilled',
// // // // // // //       title: 'Caramel Frappe',
// // // // // // //       subtitle: 'Blended ice, caramel drizzle',
// // // // // // //       price: 4.95,
// // // // // // //       image: const AssetImage('assets/images/coffeeImage.jpg'),
// // // // // // //       category: 'Frappe',
// // // // // // //     ),
// // // // // // //     _MenuData(
// // // // // // //       badge: 'Best Drink',
// // // // // // //       title: 'Cappuccino',
// // // // // // //       subtitle: 'Silky microfoam, house espresso blend',
// // // // // // //       price: 4.25,
// // // // // // //       image: const AssetImage('assets/images/coffeeImage.jpg'),
// // // // // // //       category: 'Espresso',
// // // // // // //     ),
// // // // // // //   ];

// // // // // // //   List<_MenuData> get _filteredMenu {
// // // // // // //     if (selectedIndex == 0) return _menuItems;
// // // // // // //     final category = _categories[selectedIndex];
// // // // // // //     return _menuItems.where((m) => m.category == category).toList();
// // // // // // //   }


// // // // // //  AnimatedSwitcher(
// // // // // //                 duration: const Duration(milliseconds: 350),
// // // // // //                 switchInCurve: Curves.easeOut,
// // // // // //                 switchOutCurve: Curves.easeIn,
// // // // // //                 transitionBuilder: (child, animation) {
// // // // // //                   final slideIn = Tween<Offset>(
// // // // // //                     begin: const Offset(0, 0.06),
// // // // // //                     end: Offset.zero,
// // // // // //                   ).animate(animation);
// // // // // //                   return FadeTransition(
// // // // // //                     opacity: animation,
// // // // // //                     child: SlideTransition(position: slideIn, child: child),
// // // // // //                   );
// // // // // //                 },
// // // // // //                 child: GridView.builder(
               
// // // // // //                   key: ValueKey<int>(selectedIndex),
// // // // // //                   shrinkWrap: true,
// // // // // //                   physics: const NeverScrollableScrollPhysics(),
// // // // // //                   padding: const EdgeInsets.symmetric(horizontal: 20),
// // // // // //                   gridDelegate:
// // // // // //                       const SliverGridDelegateWithFixedCrossAxisCount(
// // // // // //                     crossAxisCount: 2,
// // // // // //                     mainAxisSpacing: 16,
// // // // // //                     crossAxisSpacing: 16,
// // // // // //                     childAspectRatio: 0.65,
// // // // // //                   ),
// // // // // //                   itemCount: _filteredMenu.length,
// // // // // //                   itemBuilder: (context, index) {
// // // // // //                     final item = _filteredMenu[index];
                
// // // // // //                     return _StaggeredCard(
// // // // // //                       index: index,
// // // // // //                       child: _MenuCard(
// // // // // //                         badge: item.badge,
// // // // // //                         title: item.title,
// // // // // //                         subtitle: item.subtitle,
// // // // // //                         price: item.price,
// // // // // //                         image: item.image,
// // // // // //                         heroTag: 'menu-image-${item.title}',
// // // // // //                         onImageTap: () => _openImagePreview(
// // // // // //                           context,
// // // // // //                           image: item.image,
// // // // // //                           heroTag: 'menu-image-${item.title}',
// // // // // //                           label: item.title,
// // // // // //                         ),
// // // // // //                         onTap: () {
// // // // // //                           showModalBottomSheet<void>(
// // // // // //                             context: context,
// // // // // //                             backgroundColor: Colors.transparent,
// // // // // //                             isScrollControlled: true,
// // // // // //                             builder: (sheetContext) =>
// // // // // //                                 _MenuDetailSheet(item: item),
// // // // // //                           );
// // // // // //                         },
// // // // // //                       ),
// // // // // //                     );
// // // // // //                   },
// // // // // //                 ),
// // // // // //               ),

// // // // // class _MenuData {
// // // // //   final String badge;
// // // // //   final String title;
// // // // //   final String subtitle;
// // // // //   final double price;
// // // // //   final AssetImage image;
// // // // //   final String category;

// // // // //   _MenuData({
// // // // //     required this.badge,
// // // // //     required this.title,
// // // // //     required this.subtitle,
// // // // //     required this.price,
// // // // //     required this.image,
// // // // //     required this.category,
// // // // //   });
// // // // // }

// // // // // class _MenuCard extends StatefulWidget {
// // // // //   final String badge;
// // // // //   final String title;
// // // // //   final String subtitle;
// // // // //   final double price;
// // // // //   final AssetImage image;
// // // // //   final String heroTag;
// // // // //   final VoidCallback onImageTap;
// // // // //   final VoidCallback onTap;

// // // // //   const _MenuCard({
// // // // //     required this.badge,
// // // // //     required this.title,
// // // // //     required this.subtitle,
// // // // //     required this.price,
// // // // //     required this.image,
// // // // //     required this.heroTag,
// // // // //     required this.onImageTap,
// // // // //     required this.onTap,
// // // // //   });

// // // // //   @override
// // // // //   State<_MenuCard> createState() => _MenuCardState();
// // // // // }

// // // // // class _MenuCardState extends State<_MenuCard> {
// // // // //   bool _isActive = false;

// // // // //   static const double _cardScale = 1.04;

// // // // //   void _setActive(bool value) {
// // // // //     if (_isActive != value) setState(() => _isActive = value);
// // // // //   }

// // // // //   @override
// // // // //   Widget build(BuildContext context) {
// // // // //     return MouseRegion(
// // // // //       cursor: SystemMouseCursors.click,
// // // // //       onEnter: (_) => _setActive(true),
// // // // //       onExit: (_) => _setActive(false),
// // // // //       child: GestureDetector(
// // // // //         onTap: widget.onTap,
// // // // //         onTapDown: (_) => _setActive(true),
// // // // //         onTapUp: (_) => _setActive(false),
// // // // //         onTapCancel: () => _setActive(false),
// // // // //         child: AnimatedScale(
     
// // // // //           scale: _isActive ? _cardScale : 1.0,
// // // // //           duration: const Duration(milliseconds: 180),
// // // // //           curve: Curves.easeOut,
// // // // //           child: AnimatedContainer(
// // // // //             duration: const Duration(milliseconds: 180),
// // // // //             clipBehavior: Clip.antiAlias,
// // // // //             decoration: BoxDecoration(
// // // // //               color: AppColors.white,
// // // // //               borderRadius: BorderRadius.circular(16),
// // // // //               border: Border.all(
// // // // //                   color: AppColors.caramel.withOpacity(0.2), width: 1),
// // // // //               boxShadow: [
// // // // //                 BoxShadow(
// // // // //                   color:
// // // // //                       AppColors.espresso.withOpacity(_isActive ? 0.18 : 0.1),
// // // // //                   blurRadius: _isActive ? 16 : 10,
// // // // //                   offset: const Offset(0, 4),
// // // // //                 ),
// // // // //               ],
// // // // //             ),
// // // // //             child: Column(
// // // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // // //               children: [
// // // // //                 Expanded(
// // // // //                   child: ClipRRect(
// // // // //                     borderRadius: const BorderRadius.only(
// // // // //                       topLeft: Radius.circular(16),
// // // // //                       topRight: Radius.circular(16),
// // // // //                     ),
// // // // //                     child: GestureDetector(
// // // // //                       behavior: HitTestBehavior.opaque,
// // // // //                       onTap: widget.onImageTap,
// // // // //                       child: AnimatedScale(
// // // // //                         scale: _isActive ? 1.06 : 1.0,
// // // // //                         duration: const Duration(milliseconds: 180),
// // // // //                         curve: Curves.easeOut,
// // // // //                         child: Hero(
// // // // //                           tag: widget.heroTag,
// // // // //                           child: Container(
// // // // //                             width: double.infinity,
// // // // //                             decoration: BoxDecoration(
// // // // //                               borderRadius: const BorderRadius.only(
// // // // //                                 topLeft: Radius.circular(16),
// // // // //                                 topRight: Radius.circular(16),
// // // // //                               ),
// // // // //                               image: DecorationImage(
// // // // //                                 image: widget.image,
// // // // //                                 fit: BoxFit.cover,
// // // // //                               ),
// // // // //                             ),
// // // // //                             child: Padding(
// // // // //                               padding: const EdgeInsets.all(12),
// // // // //                               child: Row(
// // // // //                                 crossAxisAlignment: CrossAxisAlignment.start,
// // // // //                                 mainAxisAlignment: MainAxisAlignment.start,
// // // // //                                 children: [
// // // // //                                   Container(
// // // // //                                     padding: const EdgeInsets.all(7),
// // // // //                                     decoration: BoxDecoration(
// // // // //                                       color: AppColors.espresso,
// // // // //                                       borderRadius: BorderRadius.circular(20),
// // // // //                                     ),
// // // // //                                     child: Text(
// // // // //                                       widget.badge,
// // // // //                                       style: GoogleFonts.inter(
// // // // //                                         color: AppColors.caramel
// // // // //                                             .withOpacity(0.8),
// // // // //                                         fontSize: 12,
// // // // //                                         fontWeight: FontWeight.w600,
// // // // //                                       ),
// // // // //                                     ),
// // // // //                                   ),
// // // // //                                 ],
// // // // //                               ),
// // // // //                             ),
// // // // //                           ),
// // // // //                         ),
// // // // //                       ),
// // // // //                     ),
// // // // //                   ),
// // // // //                 ),
// // // // //                 const SizedBox(height: 8),
// // // // //                 Padding(
// // // // //                   padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
// // // // //                   child: Column(
// // // // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // // // //                     children: [
// // // // //                       Text(
// // // // //                         widget.title,
// // // // //                         style: GoogleFonts.fraunces(
// // // // //                           color: AppColors.espresso,
// // // // //                           fontSize: 16,
// // // // //                           fontWeight: FontWeight.bold,
// // // // //                         ),
// // // // //                         maxLines: 1,
// // // // //                         overflow: TextOverflow.ellipsis,
// // // // //                       ),
// // // // //                       const SizedBox(height: 4),
// // // // //                       Text(
// // // // //                         widget.subtitle,
// // // // //                         style: GoogleFonts.inter(
// // // // //                           color: AppColors.clay.withOpacity(0.6),
// // // // //                           fontSize: 14,
// // // // //                           fontWeight: FontWeight.w500,
// // // // //                         ),
// // // // //                         maxLines: 1,
// // // // //                         overflow: TextOverflow.ellipsis,
// // // // //                       ),
// // // // //                       const SizedBox(height: 10),
// // // // //                       Row(
// // // // //                         crossAxisAlignment: CrossAxisAlignment.center,
// // // // //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // // //                         children: [
// // // // //                           Text(
// // // // //                             '\$${widget.price.toStringAsFixed(2)}',
// // // // //                             style: GoogleFonts.inter(
// // // // //                               color: AppColors.espresso,
// // // // //                               fontSize: 18,
// // // // //                               fontWeight: FontWeight.bold,
// // // // //                             ),
// // // // //                           ),
// // // // //                           GestureDetector(
// // // // //                             onTap: widget.onTap,
// // // // //                             child: AnimatedContainer(
// // // // //                               duration: const Duration(milliseconds: 180),
// // // // //                               padding: const EdgeInsets.all(10),
// // // // //                               decoration: BoxDecoration(
                         
// // // // //                                 color: _isActive
// // // // //                                     ? AppColors.espresso
// // // // //                                     : AppColors.caramel.withOpacity(0.8),
// // // // //                                 shape: BoxShape.circle,
// // // // //                               ),
// // // // //                               alignment: Alignment.center,
// // // // //                               child: Icon(
// // // // //                                 Iconsax.add,
// // // // //                                 color: _isActive
// // // // //                                     ? AppColors.caramel
// // // // //                                     : AppColors.espresso,
// // // // //                                 size: 20,
// // // // //                               ),
// // // // //                             ),
// // // // //                           )
// // // // //                         ],
// // // // //                       ),
// // // // //                     ],
// // // // //                   ),
// // // // //                 ),
// // // // //               ],
// // // // //             ),
// // // // //           ),
// // // // //         ),
// // // // //       ),
// // // // //     );
// // // // //   }
// // // // // }
// // // // class _MenuCard extends StatefulWidget {
// // // //   final String badge;
// // // //   final String title;
// // // //   final String subtitle;
// // // //   final double price;
// // // //   final AssetImage image;
// // // //   final String heroTag;
// // // //   final VoidCallback onImageTap;
// // // //   final VoidCallback onTap;

// // // //   const _MenuCard({
// // // //     required this.badge,
// // // //     required this.title,
// // // //     required this.subtitle,
// // // //     required this.price,
// // // //     required this.image,
// // // //     required this.heroTag,
// // // //     required this.onImageTap,
// // // //     required this.onTap,
// // // //   });

// // // //   @override
// // // //   State<_MenuCard> createState() => _MenuCardState();
// // // // }

// // // // class _MenuCardState extends State<_MenuCard> {
// // // //   bool _isActive = false;

// // // //   static const double _cardScale = 1.04;

// // // //   void _setActive(bool value) {
// // // //     if (_isActive != value) setState(() => _isActive = value);
// // // //   }

// // // //   @override
// // // //   Widget build(BuildContext context) {
// // // //     return MouseRegion(
// // // //       cursor: SystemMouseCursors.click,
// // // //       onEnter: (_) => _setActive(true),
// // // //       onExit: (_) => _setActive(false),
// // // //       child: GestureDetector(
// // // //         onTap: widget.onTap,
// // // //         onTapDown: (_) => _setActive(true),
// // // //         onTapUp: (_) => _setActive(false),
// // // //         onTapCancel: () => _setActive(false),
// // // //         child: AnimatedScale(
     
// // // //           scale: _isActive ? _cardScale : 1.0,
// // // //           duration: const Duration(milliseconds: 180),
// // // //           curve: Curves.easeOut,
// // // //           child: AnimatedContainer(
// // // //             duration: const Duration(milliseconds: 180),
// // // //             clipBehavior: Clip.antiAlias,
// // // //             decoration: BoxDecoration(
// // // //               color: AppColors.white,
// // // //               borderRadius: BorderRadius.circular(16),
// // // //               border: Border.all(
// // // //                   color: AppColors.caramel.withOpacity(0.2), width: 1),
// // // //               boxShadow: [
// // // //                 BoxShadow(
// // // //                   color:
// // // //                       AppColors.espresso.withOpacity(_isActive ? 0.18 : 0.1),
// // // //                   blurRadius: _isActive ? 16 : 10,
// // // //                   offset: const Offset(0, 4),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //             child: Column(
// // // //               crossAxisAlignment: CrossAxisAlignment.start,
// // // //               children: [
// // // //                 Expanded(
// // // //                   child: ClipRRect(
// // // //                     borderRadius: const BorderRadius.only(
// // // //                       topLeft: Radius.circular(16),
// // // //                       topRight: Radius.circular(16),
// // // //                     ),
// // // //                     child: GestureDetector(
// // // //                       behavior: HitTestBehavior.opaque,
// // // //                       onTap: widget.onImageTap,
// // // //                       child: AnimatedScale(
// // // //                         scale: _isActive ? 1.06 : 1.0,
// // // //                         duration: const Duration(milliseconds: 180),
// // // //                         curve: Curves.easeOut,
// // // //                         child: Hero(
// // // //                           tag: widget.heroTag,
// // // //                           child: Container(
// // // //                             width: double.infinity,
// // // //                             decoration: BoxDecoration(
// // // //                               borderRadius: const BorderRadius.only(
// // // //                                 topLeft: Radius.circular(16),
// // // //                                 topRight: Radius.circular(16),
// // // //                               ),
// // // //                               image: DecorationImage(
// // // //                                 image: widget.image,
// // // //                                 fit: BoxFit.cover,
// // // //                               ),
// // // //                             ),
// // // //                             child: Padding(
// // // //                               padding: const EdgeInsets.all(12),
// // // //                               child: Row(
// // // //                                 crossAxisAlignment: CrossAxisAlignment.start,
// // // //                                 mainAxisAlignment: MainAxisAlignment.start,
// // // //                                 children: [
// // // //                                   Container(
// // // //                                     padding: const EdgeInsets.all(7),
// // // //                                     decoration: BoxDecoration(
// // // //                                       color: AppColors.espresso,
// // // //                                       borderRadius: BorderRadius.circular(20),
// // // //                                     ),
// // // //                                     child: Text(
// // // //                                       widget.badge,
// // // //                                       style: GoogleFonts.inter(
// // // //                                         color: AppColors.caramel
// // // //                                             .withOpacity(0.8),
// // // //                                         fontSize: 12,
// // // //                                         fontWeight: FontWeight.w600,
// // // //                                       ),
// // // //                                     ),
// // // //                                   ),
// // // //                                 ],
// // // //                               ),
// // // //                             ),
// // // //                           ),
// // // //                         ),
// // // //                       ),
// // // //                     ),
// // // //                   ),
// // // //                 ),
// // // //                 const SizedBox(height: 8),
// // // //                 Padding(
// // // //                   padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
// // // //                   child: Column(
// // // //                     crossAxisAlignment: CrossAxisAlignment.start,
// // // //                     children: [
// // // //                       Text(
// // // //                         widget.title,
// // // //                         style: GoogleFonts.fraunces(
// // // //                           color: AppColors.espresso,
// // // //                           fontSize: 16,
// // // //                           fontWeight: FontWeight.bold,
// // // //                         ),
// // // //                         maxLines: 1,
// // // //                         overflow: TextOverflow.ellipsis,
// // // //                       ),
// // // //                       const SizedBox(height: 4),
// // // //                       Text(
// // // //                         widget.subtitle,
// // // //                         style: GoogleFonts.inter(
// // // //                           color: AppColors.clay.withOpacity(0.6),
// // // //                           fontSize: 14,
// // // //                           fontWeight: FontWeight.w500,
// // // //                         ),
// // // //                         maxLines: 1,
// // // //                         overflow: TextOverflow.ellipsis,
// // // //                       ),
// // // //                       const SizedBox(height: 10),
// // // //                       Row(
// // // //                         crossAxisAlignment: CrossAxisAlignment.center,
// // // //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // // //                         children: [
// // // //                           Text(
// // // //                             '\$${widget.price.toStringAsFixed(2)}',
// // // //                             style: GoogleFonts.inter(
// // // //                               color: AppColors.espresso,
// // // //                               fontSize: 18,
// // // //                               fontWeight: FontWeight.bold,
// // // //                             ),
// // // //                           ),
// // // //                           GestureDetector(
// // // //                             onTap: widget.onTap,
// // // //                             child: AnimatedContainer(
// // // //                               duration: const Duration(milliseconds: 180),
// // // //                               padding: const EdgeInsets.all(10),
// // // //                               decoration: BoxDecoration(
                         
// // // //                                 color: _isActive
// // // //                                     ? AppColors.espresso
// // // //                                     : AppColors.caramel.withOpacity(0.8),
// // // //                                 shape: BoxShape.circle,
// // // //                               ),
// // // //                               alignment: Alignment.center,
// // // //                               child: Icon(
// // // //                                 Iconsax.add,
// // // //                                 color: _isActive
// // // //                                     ? AppColors.caramel
// // // //                                     : AppColors.espresso,
// // // //                                 size: 20,
// // // //                               ),
// // // //                             ),
// // // //                           )
// // // //                         ],
// // // //                       ),
// // // //                     ],
// // // //                   ),
// // // //                 ),
// // // //               ],
// // // //             ),
// // // //           ),
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }
// // // // }
// // // //  void _openImagePreview(
// // // //     BuildContext context, {
// // // //     required AssetImage image,
// // // //     required String heroTag,
// // // //     required String label,
// // // //   }) {
// // // //     Navigator.of(context).push(
// // // //       PageRouteBuilder<void>(
// // // //         opaque: false,
// // // //         barrierColor: Colors.black,
// // // //         pageBuilder: (_, __, ___) => _ImagePreview(
// // // //           image: image,
// // // //           heroTag: heroTag,
// // // //           label: label,
// // // //         ),
// // // //       ),
// // // //     );
// // // //   }

// // // Widget _buildCategories(String categoriesName, int index) {
// // //     final bool isSelected = selectedIndex == index;
// // //     return GestureDetector(
// // //       onTap: () {
// // //         if (selectedIndex == index) return;
// // //         setState(() {
// // //           selectedIndex = index;
// // //         });
// // //       },
// // //       child: AnimatedScale(
// // //         duration: const Duration(milliseconds: 260),
// // //         curve: Curves.easeOutBack,
// // //         scale: isSelected ? 1.04 : 1,
// // //         child: AnimatedContainer(
// // //           duration: const Duration(milliseconds: 260),
// // //           curve: Curves.easeOutCubic,
// // //           padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9),
// // //           margin: const EdgeInsets.only(right: 10),
// // //           decoration: BoxDecoration(
// // //             color: isSelected ? AppColors.espresso : AppColors.white,
// // //             borderRadius: BorderRadius.circular(20),
// // //             border: Border.all(
// // //               color: isSelected
// // //                   ? AppColors.espresso
// // //                   : AppColors.caramel.withOpacity(0.4),
// // //               width: 1,
// // //             ),
// // //             boxShadow: isSelected
// // //                 ? [
// // //                     BoxShadow(
// // //                       color: AppColors.espresso.withOpacity(0.22),
// // //                       blurRadius: 12,
// // //                       offset: const Offset(0, 5),
// // //                     ),
// // //                   ]
// // //                 : const [],
// // //           ),
// // //           child: AnimatedDefaultTextStyle(
// // //             duration: const Duration(milliseconds: 220),
// // //             curve: Curves.easeOut,
// // //             style: GoogleFonts.inter(
// // //               color: isSelected ? AppColors.white : AppColors.espresso,
// // //               fontSize: 14,
// // //               fontWeight: FontWeight.w600,
// // //             ),
// // //             child: Text(categoriesName),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }

// //   SingleChildScrollView(
// //                 scrollDirection: Axis.horizontal,
// //                 padding: const EdgeInsets.symmetric(horizontal: 20),
// //                 child: Row(
// //                   children: [
// //                     _buildCategories('All', 0),
// //                     _buildCategories('Espresso', 1),
// //                     _buildCategories('Iced Coffee', 2),
// //                     _buildCategories('Tea & Matcha', 3),
// //                     _buildCategories('Bakery', 4),
// //                     _buildCategories('Frappe', 5),
// //                   ],
// //                 ),
// //               ),

// class _ImagePreview extends StatelessWidget {
//   final AssetImage image;
//   final String heroTag;
//   final String label;

//   const _ImagePreview({
//     required this.image,
//     required this.heroTag,
//     required this.label,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Material(
//       color: Colors.black.withOpacity(0.94),
//       child: SafeArea(
//         child: Stack(
//           children: [
//             Center(
//               child: Hero(
//                 tag: heroTag,
//                 child: InteractiveViewer(
//                   minScale: 1,
//                   maxScale: 4,
//                   child: Image(image: image, fit: BoxFit.contain),
//                 ),
//               ),
//             ),
//             Positioned(
//               top: 12,
//               left: 16,
//               right: 16,
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text(
//                     label,
//                     style: GoogleFonts.fraunces(
//                       color: AppColors.white,
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   IconButton(
//                     onPressed: () => Navigator.of(context).pop(),
//                     icon: const Icon(Icons.close, color: AppColors.white),
//                     style: IconButton.styleFrom(
//                       backgroundColor: Colors.white.withOpacity(0.16),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//             Positioned(
//               left: 0,
//               right: 0,
//               bottom: 24,
//               child: Text(
//                 'Pinch to zoom',
//                 textAlign: TextAlign.center,
//                 style: GoogleFonts.inter(
//                   color: AppColors.white.withOpacity(0.75),
//                   fontSize: 13,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }