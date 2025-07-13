
import 'package:flutter/material.dart';

@immutable
sealed class HomeScreenEvent {}

class LoadVenues extends HomeScreenEvent {}

class LoadFavorites extends HomeScreenEvent {}


class ToggleFavoriteVenue extends HomeScreenEvent {
  final String venueId;

  ToggleFavoriteVenue(this.venueId);
}


