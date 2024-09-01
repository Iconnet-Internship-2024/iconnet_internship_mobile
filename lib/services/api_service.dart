import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<http.Response> getRequest(String url) async {
  final prefs = await SharedPreferences.getInstance();
  final cookie = prefs.getString('cookie');

  final response = await http.get(
    Uri.parse(url),
    headers: {
      'Cookie': cookie ?? '',
    },
  );

  // Menyimpan cookie dari response header, jika ada
  final setCookieHeader = response.headers['set-cookie'];
  if (setCookieHeader != null) {
    await prefs.setString('cookie', setCookieHeader);
  }

  return response;
}
