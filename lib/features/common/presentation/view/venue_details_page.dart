import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:venure/app/service_locator/service_locator.dart';
import 'package:venure/core/network/socket_service.dart';
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
      appBar: AppBar(
        title: const Text('Venue Details'),
        backgroundColor: Colors.black87,
      ),
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

                // When chat is loaded, navigate and provide ChatMessagesBloc for the chat
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
              return Center(child: Text(state.message));
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
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Text(
            venue.venueName,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
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
          if (venue.description != null && venue.description!.isNotEmpty) ...[
            const Text(
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
          if (venue.amenities.isNotEmpty) ...[
            const Text(
              'Amenities',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children:
                  venue.amenities
                      .map(
                        (a) => Container(
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
                        ),
                      )
                      .toList(),
            ),
            const SizedBox(height: 24),
          ],
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.people, color: Colors.blue[700]),
                  const SizedBox(width: 6),
                  Text(
                    'Capacity: ${venue.capacity}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                'Price/hr: Nrs.${venue.pricePerHour.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          Row(
            children: [
              ElevatedButton(
                onPressed: () {
                  // Booking flow here
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
              const SizedBox(width: 40),
              ElevatedButton(
                onPressed: () {
                  final ownerId = venue.ownerId;
                  final params = GetOrCreateChatParamsWithUser(
                    participantId: ownerId,
                    venueId: venue.id,
                    currentUserId: currentUserId,
                  );
                  // Send event to ChatListBloc (not ChatMessagesBloc)
                  context.read<ChatListBloc>().add(GetOrCreateChat(params));
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
