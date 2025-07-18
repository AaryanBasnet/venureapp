import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/app/service_locator/service_locator.dart';

import 'package:venure/features/chat/presentation/view/chat_screen_view.dart';
import 'package:venure/features/common/presentation/view_model/navigation_cubit.dart';
import 'package:venure/features/common/presentation/view/favorites_page.dart';
import 'package:venure/features/home/presentation/view/home_screen_wrapper.dart';
import 'package:venure/features/home/presentation/view_model/home_screen_event.dart';
import 'package:venure/features/home/presentation/view_model/home_view_model.dart';
import 'package:venure/features/profile/presentation/view/profile_screen.dart';
import 'package:venure/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:venure/features/profile/presentation/view_model/profile_event.dart';

class VenureMainScreen extends StatefulWidget {
  const VenureMainScreen({super.key});

  @override
  State<VenureMainScreen> createState() => _VenureMainScreenState();
}

class _VenureMainScreenState extends State<VenureMainScreen>
    with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _selectionController;
  late Animation<double> _selectionAnimation;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _selectionController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _selectionAnimation = CurvedAnimation(
      parent: _selectionController,
      curve: Curves.easeInOutQuart,
    );

    _screens = [
      const HomeScreenWrapper(),
      const Placeholder(), // Replace with ChatScreenView() when ready
      const FavoritesPage(),
      BlocProvider(
        create:
            (_) => ProfileViewModel(
              remoteDataSource: serviceLocator(),
              storageService: serviceLocator(),
            )..add(LoadUserProfile()),
        child: const ProfileScreen(),
      ),
    ];
  }

  @override
  void dispose() {
    _pageController.dispose();
    _selectionController.dispose();
    super.dispose();
  }

  void _onItemTapped(BuildContext context, int index, int currentIndex) {
    if (index != currentIndex) {
      context.read<NavigationCubit>().changeTab(index);
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
      );
      _selectionController.forward().then((_) {
        _selectionController.reverse();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => NavigationCubit()),
        BlocProvider(
          create: (_) => serviceLocator<HomeScreenBloc>()..add(LoadVenues()),
        ),
      ],
      child: BlocBuilder<NavigationCubit, int>(
        builder: (context, selectedIndex) {
          return Scaffold(
            body: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              onPageChanged: (index) {
                context.read<NavigationCubit>().changeTab(index);
              },
              children: _screens,
            ),
            bottomNavigationBar: _buildBottomNavigationBar(
              context,
              selectedIndex,
            ),
          );
        },
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, int selectedIndex) {
    final items = [
      _BottomNavItem(
        icon: Icons.home_outlined,
        activeIcon: Icons.home_rounded,
        label: 'Home',
      ),
      _BottomNavItem(
        icon: Icons.chat_bubble_outline_rounded,
        activeIcon: Icons.chat_bubble_rounded,
        label: 'Chat',
      ),
      _BottomNavItem(
        icon: Icons.favorite_outline_rounded,
        activeIcon: Icons.favorite_rounded,
        label: 'Favourites',
      ),
      _BottomNavItem(
        icon: Icons.person_outline_rounded,
        activeIcon: Icons.person_rounded,
        label: 'Profile',
      ),
    ];

    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: const Color(0xFFE5E5E7).withOpacity(0.6),
            width: 0.5,
          ),
        ),
      ),
      child: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 350),
            curve: Curves.easeInOutCubic,
            left:
                (MediaQuery.of(context).size.width / 4) * selectedIndex +
                (MediaQuery.of(context).size.width / 4 - 40) / 2,
            top: 12,
            child: Container(
              width: 40,
              height: 3,
              decoration: BoxDecoration(
                color: const Color(0xFF1C1C1E),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(items.length, (index) {
                  final isSelected = selectedIndex == index;
                  final item = items[index];
                  return _buildNavItem(context, index, item, isSelected);
                }),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context,
    int index,
    _BottomNavItem item,
    bool isSelected,
  ) {
    return GestureDetector(
      onTap:
          () => _onItemTapped(
            context,
            index,
            context.read<NavigationCubit>().state,
          ),
      child: Container(
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          color:
              isSelected
                  ? const Color(0xFF1C1C1E).withOpacity(0.06)
                  : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: AnimatedBuilder(
          animation: _selectionAnimation,
          builder: (context, child) {
            final scale =
                isSelected && _selectionAnimation.value > 0
                    ? 1.0 + (_selectionAnimation.value * 0.1)
                    : 1.0;

            return Transform.scale(
              scale: scale,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 200),
                    transitionBuilder: (child, animation) {
                      return ScaleTransition(scale: animation, child: child);
                    },
                    child: Icon(
                      isSelected ? item.activeIcon : item.icon,
                      key: ValueKey(isSelected),
                      size: 24,
                      color:
                          isSelected
                              ? const Color(0xFF1C1C1E)
                              : const Color(0xFF8E8E93),
                    ),
                  ),
                  const SizedBox(height: 4),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 200),
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color:
                          isSelected
                              ? const Color(0xFF1C1C1E)
                              : const Color(0xFF8E8E93),
                      letterSpacing: 0.2,
                    ),
                    child: Text(item.label),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _BottomNavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _BottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
 