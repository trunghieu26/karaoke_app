import 'package:http/http.dart' as http;

class LyricsRemoteDataSource {
  Future<String> fetchXml() async {
    final res = await http.get(Uri.parse(
      "https://storage.googleapis.com/ikara-storage/ikara/lyrics.xml",
    ));

    return res.body;
  }
}