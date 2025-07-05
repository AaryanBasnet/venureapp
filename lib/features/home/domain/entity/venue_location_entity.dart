import 'package:equatable/equatable.dart';

class VenueLocation extends Equatable {
  final String address;
  final String city;
  final String state;
  final String country;

  const VenueLocation({
    required this.address,
    required this.city,
    required this.state,
    required this.country,
  });

  @override
  List<Object?> get props => [address, city, state, country];
}
