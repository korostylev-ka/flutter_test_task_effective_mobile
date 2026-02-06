import 'package:http/http.dart' as http;

class Api {
  Future<http.Response> getCharacters(String url) async {
    final charactersResponse = await http.get(Uri.parse(url));
    return charactersResponse;
  }
}
