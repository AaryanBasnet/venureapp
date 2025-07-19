import 'dart:convert';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:venure/app/constant/hive/hive_table_constant.dart';
import 'package:venure/features/auth/data/model/user_hive_model.dart';
import 'package:venure/features/booking/data/model/booking_hive_model.dart';
import 'package:venure/features/chat/data/model/chat_model.dart';
import 'package:venure/features/home/data/model/venue_model.dart';

class HiveService {
  // Singleton setup
  HiveService._privateConstructor();
  static final HiveService instance = HiveService._privateConstructor();

  late Box<UserHiveModel> _userBox;
  late Box<String> _favoritesBox;
  late Box<BookingHiveModel> _bookingBox;
  late Box<VenueModel> _venueBox;
  late Box<ChatModel> _chatBox;

  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path); // directory only, no filename

    // Register adapters once
    if (!Hive.isAdapterRegistered(UserHiveModelAdapter().typeId)) {
      Hive.registerAdapter(UserHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(BookingHiveModelAdapter().typeId)) {
      Hive.registerAdapter(BookingHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(VenueModelAdapter().typeId)) {
      Hive.registerAdapter(VenueModelAdapter());
    }

   if (!Hive.isAdapterRegistered(ChatModelAdapter().typeId)) {
  Hive.registerAdapter(ChatModelAdapter());
}
if (!Hive.isAdapterRegistered(ParticipantAdapter().typeId)) {
  Hive.registerAdapter(ParticipantAdapter());
}
    _chatBox = await Hive.openBox<ChatModel>(HiveTableConstant.chatBoxName);

    // Open all boxes once and cache references
    _userBox = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    _favoritesBox = await Hive.openBox<String>(HiveTableConstant.favoritesBox);
    _bookingBox = await Hive.openBox<BookingHiveModel>(
      HiveTableConstant.bookingsBox,
    );
    _venueBox = await Hive.openBox<VenueModel>(HiveTableConstant.venueBoxName);
  }

  // User Methods
  Future<void> registerUser(UserHiveModel user) async {
    await _userBox.put(user.userId, user);
  }

  Future<void> saveUserProfile(UserHiveModel user) async {
    await _userBox.put(user.userId, user);
  }

  UserHiveModel? getUserProfile(String userId) {
    return _userBox.get(userId);
  }

  UserHiveModel? loginUser(String email, String password) {
    try {
      return _userBox.values.firstWhere(
        (u) => u.email == email && u.password == password,
      );
    } catch (e) {
      return null; // or throw custom exception
    }
  }

  // Venue Methods
  Future<void> saveVenue(VenueModel venue) async {
    await _venueBox.put(venue.id, venue);
  }

  Future<void> updateVenue(VenueModel venue) async {
    await _venueBox.put(venue.id, venue);
  }

  Future<void> deleteVenue(String id) async {
    await _venueBox.delete(id);
  }

  VenueModel? getVenueById(String id) {
    return _venueBox.get(id);
  }

  List<VenueModel> getAllVenues() {
    return _venueBox.values.toList();
  }

  Future<void> clearAllVenues() async {
    await _venueBox.clear();
  }

  // Favorites Methods
  // Getting favorite venue ids
  List<String> getFavoriteVenueIds() {
    final jsonString = _favoritesBox.get('favoritesList', defaultValue: '[]');
    if (jsonString == null) return [];
    final List<dynamic> decoded = jsonDecode(jsonString);
    return decoded.cast<String>();
  }

  // Saving favorite venue ids
  Future<void> saveFavoriteVenueIds(List<String> ids) async {
    final jsonString = jsonEncode(ids);
    await _favoritesBox.put('favoritesList', jsonString);
  }

  // Toggling favorite

  Future<bool> toggleFavoriteVenue(String venueId) async {
    final current = getFavoriteVenueIds();

    if (current.contains(venueId)) {
      current.remove(venueId);
    } else {
      current.add(venueId);
    }

    await saveFavoriteVenueIds(current);
    return current.contains(venueId);
  }

  // Booking Methods
  Future<void> saveBooking(BookingHiveModel booking) async {
    await _bookingBox.put(booking.id, booking);
  }

  Future<void> deleteBooking(String id) async {
    await _bookingBox.delete(id);
  }

  BookingHiveModel? getBookingById(String id) {
    return _bookingBox.get(id);
  }

  List<BookingHiveModel> getAllBookings() {
    return _bookingBox.values.toList();
  }

  Future<void> clearAllBookings() async {
    await _bookingBox.clear();
  }


  // Chat Methods
Future<void> saveChat(ChatModel chat) async {
  await _chatBox.put(chat.id, chat);
}

Future<ChatModel?> getChatById(String id) async {
  return Future.value(_chatBox.get(id));
}


List<ChatModel> getAllChats() {
  return _chatBox.values.toList();
}

Future<void> clearAllChats() async {
  await _chatBox.clear();
}

Future<void> deleteChat(String id) async {
  await _chatBox.delete(id);
}

}
