// lib/features/profile/presentation/view/profile_screen_wrapper.dart

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/features/profile/presentation/view/profile_screen.dart';
import 'package:venure/features/profile/presentation/view_model/profile_event.dart';
import 'package:venure/features/profile/presentation/view_model/profile_view_model.dart';

class ProfileScreenWrapper extends StatelessWidget {
  const ProfileScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ProfileViewModel()..add(LoadUserProfile()),
      child: const ProfileScreen(),
    );
  }
}
