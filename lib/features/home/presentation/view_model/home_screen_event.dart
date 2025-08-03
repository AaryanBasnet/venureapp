// features/home/presentation/view_model/home_screen_event.dart

import 'package:flutter/material.dart';
import 'package:equatable/equatable.dart'; // Make sure Equatable is imported

@immutable
class HomeScreenEvent extends Equatable {
  // Extend Equatable here too
  const HomeScreenEvent();

  @override
  List<Object> get props => [];
}

class LoadVenues
    extends HomeScreenEvent {} // This will serve as LoadInitialVenues

class LoadMoreVenues extends HomeScreenEvent {}

class LoadFavorites
    extends
        HomeScreenEvent {} // Still useful if favorites can be refreshed independently

class ToggleFavoriteVenue extends HomeScreenEvent {
  final String venueId;

  const ToggleFavoriteVenue(this.venueId); // Add const constructor

  @override
  List<Object> get props => [venueId]; // Add venueId to props
}
