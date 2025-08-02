import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/app/constant/shared_pref/local_storage_service.dart';
import 'package:venure/app/service_locator/service_locator.dart';
import 'package:venure/features/booking/domain/use_case/cancel_booking_usecase.dart';
import 'package:venure/features/booking/domain/use_case/get_booking_usecase.dart';
import 'package:venure/features/chat/presentation/view/chat_list_view.dart';
import 'package:venure/features/chat/presentation/view_model/chat_list_bloc.dart';
import 'package:venure/features/chat/presentation/view_model/chat_list_event.dart';
import 'package:venure/features/common/presentation/view/favorites_page.dart';
import 'package:venure/features/common/presentation/view_model/navigation_cubit.dart';
import 'package:venure/features/home/presentation/view/home_screen_wrapper.dart';
import 'package:venure/features/home/presentation/view_model/home_screen_event.dart';
import 'package:venure/features/home/presentation/view_model/home_view_model.dart';
import 'package:venure/features/profile/presentation/view/profile_screen.dart';
import 'package:venure/features/profile/presentation/view_model/my_bookings_view_model/my_booking_view_model.dart';
import 'package:venure/features/profile/presentation/view_model/my_bookings_view_model/my_bookings_event.dart';
import 'package:venure/features/profile/presentation/view_model/profile_event.dart';
import 'package:venure/features/profile/presentation/view_model/profile_view_model.dart';

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
  late String currentUserId;

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

    currentUserId = serviceLocator<LocalStorageService>().userId ?? '';

    _screens = [
      const HomeScreenWrapper(),
      const ChatScreenView(),
      const FavoritesPage(),
      const ProfileScreen(),
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
        BlocProvider(
          create:
              (_) =>
                  serviceLocator<ChatListBloc>()
                    ..add(LoadUserChats(currentUserId: currentUserId)),
        ),
        BlocProvider(
          create:
              (_) => serviceLocator<ProfileViewModel>()..add(LoadUserProfile()),
        ),
        BlocProvider(
          create:
              (_) => BookingBloc(
                getBookingsUseCase: serviceLocator<GetMyBookingsUseCase>(),
                cancelBookingUseCase: serviceLocator<CancelBookingUseCase>(),
              )..add(FetchBookings()),
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
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.85),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border(
          top: BorderSide(color: Colors.grey.withOpacity(0.2), width: 0.5),
        ),
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: List.generate(items.length, (index) {
                  final isSelected = selectedIndex == index;
                  return Flexible(
                    // ✅ Prevents overflow
                    child: _buildNavItem(
                      context,
                      index,
                      items[index],
                      isSelected,
                    ),
                  );
                }),
              ),
            ),
          ),
        ),
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center, // ✅ Center everything
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(
              horizontal: 10,
              vertical: 4,
            ), // smaller
            decoration: BoxDecoration(
              color:
                  isSelected
                      ? const Color(0xFFEB5757).withOpacity(0.15)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: AnimatedScale(
              scale: isSelected ? 1.15 : 1.0,
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOutBack,
              child: Icon(
                isSelected ? item.activeIcon : item.icon,
                size: 24,
                color:
                    isSelected
                        ? const Color(0xFFEB5757)
                        : const Color(0xFF8E8E93),
              ),
            ),
          ),
          const SizedBox(height: 2),
          AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: isSelected ? 1.0 : 0.0,
            child: Text(
              item.label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 11,
                color: Color(0xFFEB5757),
              ),
            ),
          ),
          const SizedBox(height: 2),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            height: 3,
            width: isSelected ? 16 : 0,
            decoration: BoxDecoration(
              color: const Color(0xFFEB5757),
              borderRadius: BorderRadius.circular(2),
              boxShadow:
                  isSelected
                      ? [
                        BoxShadow(
                          color: const Color(0xFFEB5757).withOpacity(0.5),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ]
                      : [],
            ),
          ),
        ],
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
