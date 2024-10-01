import 'package:dio/dio.dart';
import 'package:iconnet_internship_mobile/services/cookie_service.dart';

Dio createDio() {
  final dio = Dio(BaseOptions(
    // baseUrl: 'http://localhost:3000',
    baseUrl: 'http://10.0.2.2:3000',
    // baseUrl: 'http://172.20.10.5:3000',
    // baseUrl: 'http://192.168.1.12:3000',
  ));

  final cookieService = CookieService();

  dio.interceptors.add(InterceptorsWrapper(
    onRequest: (options, handler) {
      // Menyertakan cookie yang sudah disimpan dalam header
      cookieService.setCookies(options);
      return handler.next(options);
    },
    onResponse: (response, handler) {
      // Menyimpan cookies baru jika ada
      cookieService.addCookies(response);
      return handler.next(response);
    },
    onError: (DioError e, handler) {
      // Handle DioError here
      return handler.next(e);
    },
  ));

  return dio;
}
