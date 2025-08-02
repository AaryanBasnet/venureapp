class UrlUtils {
  // static const String baseUrl = 'http://192.168.1.70:5050';
  static const String baseUrl  = "http://10.0.2.2:5050";

  static String buildFullUrl(String relativePath) {
    if (relativePath.startsWith('http')) {
      return relativePath;
    }
    return baseUrl +
        (relativePath.startsWith('/') ? relativePath : '/$relativePath');
  }
}
