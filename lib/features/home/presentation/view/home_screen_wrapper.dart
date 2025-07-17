import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:venure/features/home/presentation/view/home_screen_view.dart';
import 'package:venure/features/home/presentation/view_model/home_view_model.dart';

class HomeScreenWrapper extends StatelessWidget {
  const HomeScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomeScreenView(); 
  }
}
