import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'dart:io'; // Untuk HttpHeaders

class CookieService {
  final CookieJar cookieJar = CookieJar();

  void addCookies(Response response) {
    final cookiesHeader = response.headers[HttpHeaders.setCookieHeader];
    if (cookiesHeader != null) {
      final cookies = cookiesHeader as List<String>;
      for (var cookie in cookies) {
        final cookieObj = Cookie.fromSetCookieValue(cookie);
        cookieJar.saveFromResponse(response.requestOptions.uri, [cookieObj]);
      }
    }
  }

  void setCookies(RequestOptions options) {
    cookieJar.loadForRequest(options.uri).then((cookieList) {
      if (cookieList.isNotEmpty) {
        options.headers[HttpHeaders.cookieHeader] = cookieList.map((cookie) => cookie.toString()).join('; ');
      }
    });
  }

  void clearCookies(Uri uri) {
    cookieJar.delete(uri);
  }

  void clearAllCookies() {
    cookieJar.deleteAll();
  }
}
