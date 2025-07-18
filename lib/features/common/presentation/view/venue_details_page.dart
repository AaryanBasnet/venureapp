import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:venure/features/common/presentation/view_model/venue_details_bloc.dart';
import 'package:venure/features/common/presentation/view_model/venue_details_state.dart';
import 'package:venure/features/home/domain/entity/venue_entity.dart';
import 'package:venure/core/utils/url_utils.dart';

class VenueDetailsPage extends StatelessWidget {
  final String venueId;

  const VenueDetailsPage({required this.venueId, super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Venue Details'),
        backgroundColor: Colors.black87,
      ),
      body: BlocBuilder<VenueDetailsBloc, VenueDetailsState>(
        builder: (context, state) {
          if (state is VenueDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is VenueDetailsError) {
            return Center(child: Text(state.message));
          } else if (state is VenueDetailsLoaded) {
            return _buildVenueDetailsUI(state.venue);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildVenueDetailsUI(Venue venue) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Venue Image
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child:
                venue.venueImages.isNotEmpty
                    ? CachedNetworkImage(
                      imageUrl: UrlUtils.buildFullUrl(
                        venue.venueImages.first.url,
                      ),
                      height: 240,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Container(
                            height: 240,
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                      errorWidget:
                          (context, url, error) => Container(
                            height: 240,
                            color: Colors.grey[300],
                            child: const Icon(
                              Icons.broken_image,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                    )
                    : Container(
                      height: 240,
                      width: double.infinity,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.place,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
          ),

          const SizedBox(height: 20),

          // Venue Name
          Text(
            venue.venueName,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),

          const SizedBox(height: 8),

          // Location
          Row(
            children: [
              Icon(Icons.location_on, color: Colors.grey[700]),
              const SizedBox(width: 4),
              Text(
                "${venue.location.city}, ${venue.location.state}",
                style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Rating stub (replace if you have data)
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber[600], size: 20),
              const SizedBox(width: 4),
              Text(
                "average rating",
                style: TextStyle(fontSize: 16, color: Colors.grey[600]),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Description
          if (venue.description != null && venue.description!.isNotEmpty) ...[
            Text(
              'Description',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              venue.description!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[800],
                height: 1.4,
              ),
            ),
            const SizedBox(height: 24),
          ],

          // Amenities
          if (venue.amenities.isNotEmpty) ...[
            Text(
              'Amenities',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  venue.amenities.map((a) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        a,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.green[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    );
                  }).toList(),
            ),
            const SizedBox(height: 24),
          ],

          // Capacity and Price
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.people, color: Colors.blue[700]),
                  const SizedBox(width: 6),
                  Text(
                    'Capacity: ${venue.capacity}',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              Text(
                'Price/hr: Nrs.${venue.pricePerHour.toStringAsFixed(0)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  // Navigate to booking page or trigger booking flow
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Book Now',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
              SizedBox(width: 40),

              ElevatedButton(
                onPressed: () {
                 //navigate to chat 
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black87,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 40,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Chat with us',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
