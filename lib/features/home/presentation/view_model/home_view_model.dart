import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewModel extends Cubit<int> {
  HomeViewModel() : super(0);

  void updateCarouselIndex(int index) {
    emit(index);
  }
}
