import 'package:equatable/equatable.dart';

class VenueImage extends Equatable {
  final String filename;
  final String url;

  const VenueImage({
    required this.filename,
    required this.url,
  });

  @override
  List<Object?> get props => [filename, url];
}
