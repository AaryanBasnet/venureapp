import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:venure/core/utils/url_utils.dart';
import 'package:venure/features/home/domain/entity/venue_entity.dart';

class FavoriteVenueCard extends StatelessWidget {
  final Venue venue;
  final VoidCallback onFavoriteToggle;
  final VoidCallback? onTap;

  const FavoriteVenueCard({
    required this.venue,
    required this.onFavoriteToggle,
    this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Venue Image
              _buildVenueImage(),
              const SizedBox(width: 16),

              // Venue Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildVenueHeader(),
                    const SizedBox(height: 8),
                    _buildLocationAndCapacity(),
                    const SizedBox(height: 8),
                    _buildAmenities(),
                    const SizedBox(height: 12),
                    _buildPriceAndStatus(),
                  ],
                ),
              ),

              // Favorite Button
              _buildFavoriteButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVenueImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[300]!, Colors.grey[400]!],
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child:
            venue.venueImages.isNotEmpty
                ? Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: UrlUtils.buildFullUrl(
                        venue.venueImages.first.url,
                      ),
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder:
                          (context, url) => Container(
                            color: Colors.grey[300],
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                    ),
                    if (venue.venueImages.length > 1)
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 4,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.7),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            '+${venue.venueImages.length - 1}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                  ],
                )
                : _buildPlaceholderImage(),
      ),
    );
  }

  Widget _buildPlaceholderImage() {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Colors.grey[300]!, Colors.grey[400]!],
        ),
      ),
      child: const Icon(Icons.place, size: 32, color: Colors.white),
    );
  }

  Widget _buildVenueHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          venue.venueName,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.black87,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber[600], size: 14),
            const SizedBox(width: 2),
            Text(
              '4.8',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(width: 4),
            Text(
              '(125)',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationAndCapacity() {
    return Row(
      children: [
        Expanded(
          child: Row(
            children: [
              Icon(Icons.location_on, color: Colors.grey[500], size: 14),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  "${venue.location.city}, ${venue.location.state}",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w400,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Row(
          children: [
            Icon(Icons.people, color: Colors.grey[500], size: 14),
            const SizedBox(width: 2),
            Text(
              '${venue.capacity}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmenities() {
    final displayAmenities = venue.amenities.take(2).toList();
    final remainingCount = venue.amenities.length - 2;

    return Row(
      children: [
        ...displayAmenities.map(
          (amenity) => Container(
            margin: const EdgeInsets.only(right: 4),
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              amenity,
              style: TextStyle(
                fontSize: 10,
                color: Colors.green[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
        if (remainingCount > 0)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '+$remainingCount',
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPriceAndStatus() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Nrs.${venue.pricePerHour.toStringAsFixed(0)}/hr',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color:
                venue.status == 'available'
                    ? Colors.green.withOpacity(0.1)
                    : Colors.orange.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            venue.status.toUpperCase(),
            style: TextStyle(
              fontSize: 10,
              color:
                  venue.status == 'available'
                      ? Colors.green[700]
                      : Colors.orange[700],
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFavoriteButton() {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: GestureDetector(
        onTap: onFavoriteToggle,
        child: const Icon(Icons.favorite, color: Colors.red, size: 20),
      ),
    );
  }
}
