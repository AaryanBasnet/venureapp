import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:venure/app/service_locator/service_locator.dart';
import 'package:venure/core/network/socket_service.dart';
import 'package:venure/features/booking/presentation/view/main_booking_page.dart';
import 'package:venure/features/chat/domain/repository/i_chat_repository.dart';
import 'package:venure/features/chat/domain/use_case/get_or_create_chat_usecase.dart';
import 'package:venure/features/chat/presentation/view/chat_screen.dart';
import 'package:venure/features/chat/presentation/view_model/chat_list_bloc.dart';
import 'package:venure/features/chat/presentation/view_model/chat_list_event.dart';
import 'package:venure/features/chat/presentation/view_model/chat_list_state.dart';
import 'package:venure/features/chat/presentation/view_model/chat_message_bloc.dart';
import 'package:venure/features/chat/presentation/view_model/chat_message_event.dart';
import 'package:venure/features/common/presentation/view_model/venue_details_bloc.dart';
import 'package:venure/features/common/presentation/view_model/venue_details_state.dart';
import 'package:venure/features/home/domain/entity/venue_entity.dart';
import 'package:venure/core/utils/url_utils.dart';
import 'package:venure/app/constant/shared_pref/local_storage_service.dart';
import 'package:get_it/get_it.dart';

class VenueDetailsPage extends StatelessWidget {
  final String venueId;

  const VenueDetailsPage({required this.venueId, super.key});

  @override
  Widget build(BuildContext context) {
    final localStorage = GetIt.I<LocalStorageService>();
    final currentUserId = localStorage.userId ?? '';

    return Scaffold(
      body: MultiBlocListener(
        listeners: [
          BlocListener<ChatListBloc, ChatListState>(
            listener: (context, state) {
              if (state is ChatListLoadedChat) {
                final userId = GetIt.I<LocalStorageService>().userId ?? '';
                final otherUserId = state.chat.participants.firstWhere(
                  (p) => p != userId,
                  orElse: () => '',
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (_) => BlocProvider(
                          create:
                              (_) => ChatMessagesBloc(
                                chatRepository:
                                    serviceLocator<IChatRepository>(),
                                socketService: serviceLocator<SocketService>(),
                                currentUserId: userId,
                              )..add(LoadChatMessages(state.chat.id)),
                          child: ChatScreen(
                            chatId: state.chat.id,
                            currentUserId: userId,
                            otherUserId: otherUserId,
                            venueId: state.chat.venueId,
                          ),
                        ),
                  ),
                );
              } else if (state is ChatListError) {
                ScaffoldMessenger.of(
                  context,
                ).showSnackBar(SnackBar(content: Text(state.message)));
              }
            },
          ),
        ],
        child: BlocBuilder<VenueDetailsBloc, VenueDetailsState>(
          builder: (context, state) {
            if (state is VenueDetailsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is VenueDetailsError) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ),
                body: Center(child: Text(state.message)),
              );
            } else if (state is VenueDetailsLoaded) {
              return _buildVenueDetailsUI(state.venue, context, currentUserId);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildVenueDetailsUI(
    Venue venue,
    BuildContext context,
    String currentUserId,
  ) {
    final theme = Theme.of(context);

    return CustomScrollView(
      slivers: [
        // App Bar with Image Gallery
        SliverAppBar(
          expandedHeight: 300,
          pinned: true,
          backgroundColor: theme.scaffoldBackgroundColor,
          leading: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
          actions: [
            Container(
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ],
          flexibleSpace: FlexibleSpaceBar(
            background: _buildImageGallery(venue),
          ),
        ),

        // Content
        SliverToBoxAdapter(
          child: Container(
            decoration: BoxDecoration(
              color: theme.scaffoldBackgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header
                  _buildHeader(venue, theme),
                  const SizedBox(height: 24),

                  // Quick Info Cards
                  _buildQuickInfoCards(venue, theme),
                  const SizedBox(height: 24),

                  // Description
                  if (venue.description != null &&
                      venue.description!.isNotEmpty)
                    _buildDescriptionSection(venue, theme),

                  // Amenities
                  if (venue.amenities.isNotEmpty)
                    _buildAmenitiesSection(venue, theme),

                  const SizedBox(height: 32),

                  // Action Buttons
                  _buildActionButtons(venue, context, currentUserId, theme),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildImageGallery(Venue venue) {
    if (venue.venueImages.isEmpty) {
      return Container(
        color: Colors.grey[300],
        child: const Center(
          child: Icon(Icons.place, size: 80, color: Colors.white),
        ),
      );
    }

    return PageView.builder(
      itemCount: venue.venueImages.length,
      itemBuilder: (context, index) {
        return Stack(
          fit: StackFit.expand,
          children: [
            CachedNetworkImage(
              imageUrl: UrlUtils.buildFullUrl(venue.venueImages[index].url),
              fit: BoxFit.cover,
              placeholder:
                  (context, url) => Container(
                    color: Colors.grey[300],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              errorWidget:
                  (context, url, error) => Container(
                    color: Colors.grey[300],
                    child: const Icon(
                      Icons.broken_image,
                      size: 60,
                      color: Colors.white,
                    ),
                  ),
            ),
            // Image indicator
            if (venue.venueImages.length > 1)
              Positioned(
                bottom: 16,
                right: 16,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.6),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    '${index + 1}/${venue.venueImages.length}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }

  Widget _buildHeader(Venue venue, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          venue.venueName,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.location_on, color: theme.colorScheme.primary, size: 20),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                "${venue.location.city}, ${venue.location.state}",
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber[600], size: 20),
            const SizedBox(width: 4),
            Text(
              "4.5",
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            // Text(
            //   "(124 reviews)",
            //   style: theme.textTheme.bodyMedium?.copyWith(
            //     color: theme.colorScheme.onSurface.withOpacity(0.6),
            //   ),
            // ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickInfoCards(Venue venue, ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: _buildInfoCard(
            icon: Icons.people_outline,
            title: 'Capacity',
            value: '${venue.capacity}',
            theme: theme,
            color: Colors.blue,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildInfoCard(
            icon: Icons.attach_money,
            title: 'Price/Hour',
            value: 'Rs.${venue.pricePerHour.toStringAsFixed(0)}',
            theme: theme,
            color: Colors.green,
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String value,
    required ThemeData theme,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(Venue venue, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'About this venue',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          venue.description!,
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.6,
            color: theme.colorScheme.onSurface.withOpacity(0.8),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildAmenitiesSection(Venue venue, ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Amenities',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children:
              venue.amenities.map((amenity) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        _getAmenityIcon(amenity),
                        size: 16,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        amenity,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onPrimaryContainer,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildActionButtons(
    Venue venue,
    BuildContext context,
    String currentUserId,
    ThemeData theme,
  ) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder:
                      (_) => MainBookingPage(
                        venueName: venue.venueName,
                        venueId: venue.id,
                        pricePerHour: venue.pricePerHour.toInt(),
                        onSubmit: (bookingData) {},
                      ),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: theme.colorScheme.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 2,
            ),
            child: Text(
              'Book Now',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimary,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () {
              final ownerId = venue.ownerId;
              final params = GetOrCreateChatParamsWithUser(
                participantId: ownerId,
                venueId: venue.id,
                currentUserId: currentUserId,
              );
              context.read<ChatListBloc>().add(GetOrCreateChat(params));
            },
            style: OutlinedButton.styleFrom(
              foregroundColor: theme.colorScheme.primary,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              side: BorderSide(color: theme.colorScheme.primary),
            ),
            icon: Icon(Icons.chat_bubble_outline, size: 20),
            label: Text(
              'Chat with Owner',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }

  IconData _getAmenityIcon(String amenity) {
    final amenityLower = amenity.toLowerCase();
    if (amenityLower.contains('wifi') || amenityLower.contains('internet')) {
      return Icons.wifi;
    } else if (amenityLower.contains('parking')) {
      return Icons.local_parking;
    } else if (amenityLower.contains('ac') || amenityLower.contains('air')) {
      return Icons.ac_unit;
    } else if (amenityLower.contains('food') ||
        amenityLower.contains('catering')) {
      return Icons.restaurant;
    } else if (amenityLower.contains('sound') ||
        amenityLower.contains('audio')) {
      return Icons.volume_up;
    } else if (amenityLower.contains('projector') ||
        amenityLower.contains('screen')) {
      return Icons.videocam;
    } else if (amenityLower.contains('security')) {
      return Icons.security;
    } else {
      return Icons.check_circle_outline;
    }
  }
}
