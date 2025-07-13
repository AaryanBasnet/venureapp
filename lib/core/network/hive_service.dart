import 'dart:ffi';

import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:venure/app/constant/hive/hive_table_constant.dart';
import 'package:venure/features/auth/data/model/user_hive_model.dart';
import 'package:venure/features/home/data/model/venue_model.dart';

class HiveService {
  static const String venueBoxName = 'venuesBox';
  Future<void> init() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = '${directory.path}venure.db';

    Hive.init(path);

    Hive.registerAdapter(UserHiveModelAdapter());
  }

  //register user
  Future<void> registerUser(UserHiveModel user) async {
    var box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);

    var newUser = box.put(user.userId, user);

    return newUser;
  }

  //login user
  Future<UserHiveModel?> loginUser(String email, String password) async {
    var box = await Hive.openBox(HiveTableConstant.userBox);
    var user = box.values.firstWhere(
      (u) => u.email == email && u.password == password,
      orElse: () => throw Exception('Invalid credentials'),
    );
    box.close();
    return user;
  }

  Future<void> saveVenue(VenueModel venue) async {
    final box = await Hive.openBox<VenueModel>(venueBoxName);
    await box.put(venue.id, venue);
  }

  Future<void> updateVenue(VenueModel venue) async {
    final box = await Hive.openBox<VenueModel>(venueBoxName);
    await box.put(venue.id, venue);
  }

  Future<void> deleteVenue(String id) async {
    final box = await Hive.openBox<VenueModel>(venueBoxName);
    await box.delete(id);
  }

  Future<VenueModel> getVenueById(String id) async {
    final box = await Hive.openBox<VenueModel>(venueBoxName);
    final venue = box.get(id);
    if (venue == null) {
      throw Exception("Venue not found");
    }
    return venue;
  }

  Future<List<VenueModel>> getAllVenues() async {
    final box = await Hive.openBox<VenueModel>(venueBoxName);
    return box.values.toList();
  }

  Future<void> clearAllVenues() async {
    final box = await Hive.openBox<VenueModel>(venueBoxName);
    await box.clear();
  }

  //for favorites section
  Future<List<String>> getFavoriteVenueIds() async {
    var box = await Hive.openBox(HiveTableConstant.favoritesBox);
    return box.get('favoritesList', defaultValue: <String>[])!.cast<String>();
  }

  Future<void> saveFavoriteVenueIds(List<String> ids) async {
    var box = await Hive.openBox(HiveTableConstant.favoritesBox);
    await box.put('favoritesList', ids);
  }

  Future<bool> toggleFavoriteVenue(String venueId) async {
    final box = await Hive.openBox(HiveTableConstant.favoritesBox);
    final List<String> current =
        box.get('favoritesList', defaultValue: <String>[])!.cast<String>();

    if (current.contains(venueId)) {
      current.remove(venueId);
    } else {
      current.add(venueId);
    }

    await box.put('favoritesList', current);

    return current.contains(venueId);
  }
}
