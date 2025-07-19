import 'dart:async';
import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:venure/app/service_locator/service_locator.dart';
import 'package:venure/core/utils/url_utils.dart';
import 'package:venure/features/auth/presentation/view/login_wrapper.dart';
import 'package:venure/features/booking/domain/use_case/get_booking_usecase.dart';
import 'package:venure/features/profile/presentation/view/edit_profile_screen.dart';
import 'package:venure/features/profile/presentation/view/my_bookings_view/my_bookings_screen.dart';
import 'package:venure/features/profile/presentation/view_model/profile_event.dart';
import 'package:venure/features/profile/presentation/view_model/profile_state.dart';
import 'package:venure/features/profile/presentation/view_model/profile_view_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const double shakeThreshold = 15.0;
  static const int shakeDebounceMs = 500;

  late final StreamSubscription _accelerometerSub;
  int _lastShakeTimestamp = 0;

  Future<void> _confirmAndLogout() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text('Logout'),
            content: const Text('Are you sure you want to logout?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.of(ctx).pop(true),
                child: const Text('Logout'),
              ),
            ],
          ),
    );

    if (confirmed == true) {
      context.read<ProfileViewModel>().add(LogoutUser(context));
    }
  }

  @override
  void initState() {
    super.initState();

    _accelerometerSub = accelerometerEvents.listen((event) {
      final now = DateTime.now().millisecondsSinceEpoch;
      final acceleration = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );

      if (acceleration > shakeThreshold &&
          now - _lastShakeTimestamp > shakeDebounceMs) {
        _lastShakeTimestamp = now;
        // Dispatch logout event with context from bloc
        _confirmAndLogout();
      }
    });
  }

  @override
  void dispose() {
    _accelerometerSub.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFAFAFA),
      body: BlocListener<ProfileViewModel, ProfileState>(
        listenWhen:
            (previous, current) => previous.isLoggedIn != current.isLoggedIn,
        listener: (context, state) {
          if (!state.isLoggedIn) {
            Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (_) => const LoginWrapper()),
              (route) => false,
            );
          }
        },
        child: BlocBuilder<ProfileViewModel, ProfileState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
              child: Column(
                children: [
                  _buildHeader(state),
                  const SizedBox(height: 32),
                  _buildContactSection(state),
                  const SizedBox(height: 24),
                  _buildQuickActions(context),
                  const SizedBox(height: 24),
                  _buildPlatformFeatures(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(ProfileState state) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.bottomRight,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [Color(0xFFF43F5E), Color(0xFFE11D48)],
                ),
                border: Border.all(color: Colors.white, width: 4),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                  ),
                ],
              ),
              child:
                  state.avatar != null
                      ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: UrlUtils.buildFullUrl(state.avatar!),
                          placeholder:
                              (context, url) =>
                                  const CircularProgressIndicator(),
                          errorWidget:
                              (context, url, error) => const Icon(Icons.person),
                          fit: BoxFit.cover,
                          width: 120,
                          height: 120,
                        ),
                      )
                      : const Icon(Icons.person, color: Colors.white, size: 50),
            ),
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFF43F5E), Color(0xFFE11D48)],
                ),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(Icons.star, color: Colors.white, size: 18),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          state.name ?? "",
          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 4),
        Text(
          state.email ?? "",
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.pink.shade50,
            borderRadius: BorderRadius.circular(20),
          ),
          child: const Text(
            "VERIFIED MEMBER",
            style: TextStyle(
              color: Colors.pink,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactSection(ProfileState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Contact Details",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        _contactItem(Icons.phone, "Phone", state.phone ?? "N/A"),
        const SizedBox(height: 8),
        _contactItem(
          Icons.location_on_outlined,
          "Address",
          state.address ?? "N/A",
        ),
      ],
    );
  }

  Widget _contactItem(IconData icon, String label, String value) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey.shade700),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final profileViewModel = context.read<ProfileViewModel>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Quick Actions",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            const SizedBox(width: 12),
            Expanded(
              child: OutlinedButton.icon(
                onPressed:
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (_) => MyBookingsScreen(
                              getBookingsUseCase:
                                  serviceLocator<GetMyBookingsUseCase>(),
                            ),
                      ),
                    ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Colors.grey),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.history),
                label: const Text("Bookings"),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (_) => BlocProvider.value(
                      value: profileViewModel,
                      child: const EditProfileScreen(),
                    ),
              ),
            );
          },
          icon: const Icon(Icons.edit),
          label: const Text("Edit Profile"),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => Navigator.pushNamed(context, "/settings"),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Colors.grey),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          icon: const Icon(Icons.settings),
          label: const Text("Account Settings"),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => profileViewModel.add(LogoutUser(context)),
          icon: const Icon(Icons.logout, color: Colors.red),
          label: const Text("Logout", style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  Widget _buildPlatformFeatures() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Platform Features",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _featureItem(Icons.event, "Easy Booking"),
            _featureItem(Icons.star_border, "Quality Venues"),
            _featureItem(Icons.favorite_outline, "Save Favorites"),
          ],
        ),
      ],
    );
  }

  Widget _featureItem(IconData icon, String label) {
    return Expanded(
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.pink.shade50,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: Colors.pink, size: 28),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14),
          ),
        ],
      ),
    );
  }
}
