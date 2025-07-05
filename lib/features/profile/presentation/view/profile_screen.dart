import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:venure/app/constant/shared_pref/local_storage_service.dart';
import 'package:venure/app/service_locator/service_locator.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  final localstorage = serviceLocator<LocalStorageService>();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.2, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: CustomScrollView(
                slivers: [
                  _buildSliverAppBar(),
                  SliverPadding(
                    padding: const EdgeInsets.all(24),
                    sliver: SliverList(
                      delegate: SliverChildListDelegate([
                        _buildProfileHeader(),
                        const SizedBox(height: 32),
                        _buildStatsSection(),
                        const SizedBox(height: 32),
                        _buildMenuSection(),
                        const SizedBox(height: 24),
                        _buildPreferencesSection(),
                        const SizedBox(height: 24),
                        _buildSupportSection(),
                        const SizedBox(height: 100),
                      ]),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar() {
    return SliverAppBar(
      backgroundColor: const Color(0xFFFAFAFA),
      elevation: 0,
      pinned: true,
      expandedHeight: 120,
      title: const Text(
        'Profile',
        style: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w700,
          color: Color(0xFF1C1C1E),
          letterSpacing: -0.5,
        ),
      ),
      actions: [
        IconButton(
          onPressed: () {
            HapticFeedback.lightImpact();
            // Handle settings
          },
          icon: const Icon(
            Icons.settings_outlined,
            color: Color(0xFF1C1C1E),
            size: 24,
          ),
        ),
      ],
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Stack(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFF1C1C1E), Color(0xFF48484A)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colors.white, width: 4),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.person_rounded,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    HapticFeedback.lightImpact();
                    // Handle profile picture change
                  },
                  child: Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1C1C1E),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: const Icon(
                      Icons.camera_alt_outlined,
                      size: 16,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (localstorage.isLoggedIn)
            Text(
              localstorage.name.toString(),
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1C1C1E),
                letterSpacing: -0.3,
              ),
            ),

          const SizedBox(height: 4),
          const Text(
            'alexandra.smith@venure.com',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Color(0xFF8E8E93),
              letterSpacing: 0.1,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF1C1C1E).withOpacity(0.06),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'Premium Member',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1C1C1E),
                letterSpacing: 0.2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsSection() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildStatItem('Bookings', '24', Icons.event_note_outlined),
          _buildStatDivider(),
          _buildStatItem('Favorites', '12', Icons.favorite_outline_rounded),
          _buildStatDivider(),
          _buildStatItem('Reviews', '18', Icons.star_outline_rounded),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String value, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 24, color: const Color(0xFF1C1C1E)),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C1C1E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF8E8E93),
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatDivider() {
    return Container(
      width: 1,
      height: 40,
      color: const Color(0xFFE5E5E7).withOpacity(0.6),
    );
  }

  Widget _buildMenuSection() {
    return _buildSection('Account', [
      _ProfileMenuItem(
        icon: Icons.person_outline_rounded,
        title: 'Personal Information',
        onTap: () {},
      ),
      _ProfileMenuItem(
        icon: Icons.security_outlined,
        title: 'Security & Privacy',
        onTap: () {},
      ),
      _ProfileMenuItem(
        icon: Icons.payment_outlined,
        title: 'Payment Methods',
        onTap: () {},
      ),
      _ProfileMenuItem(
        icon: Icons.history_outlined,
        title: 'Booking History',
        onTap: () {},
      ),
    ]);
  }

  Widget _buildPreferencesSection() {
    return _buildSection('Preferences', [
      _ProfileMenuItem(
        icon: Icons.notifications_outlined,
        title: 'Notifications',
        onTap: () {},
        hasTrailing: true,
      ),
      _ProfileMenuItem(
        icon: Icons.language_outlined,
        title: 'Language',
        subtitle: 'English',
        onTap: () {},
      ),
      _ProfileMenuItem(
        icon: Icons.dark_mode_outlined,
        title: 'Dark Mode',
        onTap: () {},
        hasTrailing: true,
      ),
    ]);
  }

  Widget _buildSupportSection() {
    return _buildSection('Support', [
      _ProfileMenuItem(
        icon: Icons.help_outline_rounded,
        title: 'Help Center',
        onTap: () {},
      ),
      _ProfileMenuItem(
        icon: Icons.feedback_outlined,
        title: 'Send Feedback',
        onTap: () {},
      ),
      _ProfileMenuItem(
        icon: Icons.info_outline_rounded,
        title: 'About Venure',
        onTap: () {},
      ),
      _ProfileMenuItem(
        icon: Icons.logout_outlined,
        title: 'Sign Out',
        onTap: () {},
        isDestructive: true,
      ),
    ]);
  }

  Widget _buildSection(String title, List<_ProfileMenuItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1C1C1E),
              letterSpacing: -0.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children:
                items.map((item) {
                  final isLast = items.indexOf(item) == items.length - 1;
                  return _buildMenuItem(item, isLast);
                }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(_ProfileMenuItem item, bool isLast) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        item.onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border:
              isLast
                  ? null
                  : const Border(
                    bottom: BorderSide(color: Color(0xFFE5E5E7), width: 0.5),
                  ),
        ),
        child: Row(
          children: [
            Icon(
              item.icon,
              size: 24,
              color:
                  item.isDestructive
                      ? const Color(0xFFFF3B30)
                      : const Color(0xFF1C1C1E),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color:
                          item.isDestructive
                              ? const Color(0xFFFF3B30)
                              : const Color(0xFF1C1C1E),
                      letterSpacing: 0.1,
                    ),
                  ),
                  if (item.subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      item.subtitle!,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF8E8E93),
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (item.hasTrailing)
              Switch(
                value: true,
                onChanged: (value) {
                  HapticFeedback.lightImpact();
                },
                activeColor: const Color(0xFF1C1C1E),
              )
            else
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: Color(0xFF8E8E93),
              ),
          ],
        ),
      ),
    );
  }
}

class _ProfileMenuItem {
  final IconData icon;
  final String title;
  final String? subtitle;
  final VoidCallback onTap;
  final bool hasTrailing;
  final bool isDestructive;

  const _ProfileMenuItem({
    required this.icon,
    required this.title,
    this.subtitle,
    required this.onTap,
    this.hasTrailing = false,
    this.isDestructive = false,
  });
}
