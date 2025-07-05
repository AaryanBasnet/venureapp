import 'package:flutter/material.dart';

@immutable
sealed class ProfileEvent {}

class LoadUserProfile extends ProfileEvent {}

class LogoutUser extends ProfileEvent {
  final BuildContext context;
  LogoutUser(this.context);
}
