import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String? name;
  final String? email;
  final bool isLoggedIn;
  final bool isLoading;

  const ProfileState({
    required this.name,
    required this.email,
    required this.isLoggedIn,
    required this.isLoading,
  });

  factory ProfileState.initial() => const ProfileState(
    name: null,
    email: null,
    isLoggedIn: false,
    isLoading: true,
  );

  ProfileState copyWith({
    String? name,
    String? email,
    String? role,
    bool? isLoggedIn,
    bool? isLoading,
  }) {
    return ProfileState(
      name: name ?? this.name,
      email: email ?? this.email,
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [name, email, isLoggedIn, isLoading];
}
