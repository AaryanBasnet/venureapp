class ApiEndpoints {
  ApiEndpoints._();

  static const connectionTimeout = Duration(seconds: 1000);

  static const receiveTimeout = Duration(seconds: 1000);

  static const String serverAddress = "http://10.0.2.2:5050";

  static const String baseUrl = "$serverAddress/api";

  static const String imageUrl = "$serverAddress/uploads";

  //Auth

  static const String register = "/auth/register";

  static const String login = "/auth/login";

  //user

  static const String getApprovedVenues = "/user/venues/getApprovedVenues";

  static const String toggleFavorite = '/user/favorites'; // POST /:venueId
  static const String getFavoriteVenues = '/user/favorites'; // GET /
static const String getFavoriteVenuesList = "/user/favorites";

}
