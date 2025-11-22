import 'package:http/http.dart' as http;
import 'package:zion_final/models/songs_model.dart';
import 'base_urls.dart';

// getting all languages.....
class FetchingLanguagesServices {
  Future<LanguageList?> getLaguages() async {
    var client = http.Client();

    var url = Uri.parse(allLanguage);
    var response = await client.get(url);

    if (response.statusCode == 200) {
      var json = response.body;
      return languageListFromJson(json);
    }
    return null;
  }
}

// getting songs based on languagecode
