import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String? name;
  final String? email;
  final String? phone;
  final String? address;
  final String? avatar; // URL string
  final bool isLoggedIn;
  final bool isLoading;
  final bool isLoggedOut; // NEW
  final String? error;

  const ProfileState({
    this.name,
    this.email,
    this.phone,
    this.address,
    this.avatar,
    required this.isLoggedIn,
    required this.isLoading,
    this.isLoggedOut = false, // NEW default
    this.error,
  });

  factory ProfileState.initial() => const ProfileState(
        name: null,
        email: null,
        phone: null,
        address: null,
        avatar: null,
        isLoggedIn: false,
        isLoading: false,
        isLoggedOut: false,
        error: null,
      );

  ProfileState copyWith({
    String? name,
    String? email,
    String? phone,
    String? address,
    String? avatar,
    bool? isLoggedIn,
    bool? isLoading,
    bool? isLoggedOut, // NEW
    String? error,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      address: address ?? this.address,
      avatar: avatar ?? this.avatar,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      isLoggedOut: isLoggedOut ?? this.isLoggedOut, // NEW
      error: error,
    );
  }

  @override
  List<Object?> get props =>
      [name, email, phone, address, avatar, isLoggedIn, isLoading, isLoggedOut, error];
}
