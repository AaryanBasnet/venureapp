class UrlUtils {
  // Base URL of your backend API (adjust for dev/prod)
  static const String baseUrl = 'http://10.0.2.2:5050/';

  /// Returns a full absolute URL from a relative asset path.
  /// If [relativePath] is already a full URL (starts with http), it returns it as is.
  static String buildFullUrl(String relativePath) {
    if (relativePath.startsWith('http')) {
      return relativePath;
    }
    return baseUrl + relativePath;
  }
}
