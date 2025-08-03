import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:venure/features/auth/presentation/view/login_wrapper.dart';
import 'package:venure/features/profile/presentation/view_model/profile_event.dart';
import 'package:venure/features/profile/presentation/view_model/profile_state.dart';
import 'package:venure/features/profile/presentation/view_model/profile_view_model.dart';
import 'package:venure/features/profile/presentation/widget/header.dart';
import 'package:venure/features/profile/presentation/widget/quick_actions.dart';

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
      context.read<ProfileViewModel>().add(LogoutUser());
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
                  Header(state: state),
                  const SizedBox(height: 32),
                  _buildContactSection(state),
                  const SizedBox(height: 24),
                  const QuickActions(),
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
