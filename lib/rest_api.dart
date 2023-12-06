import 'package:snow_depth_final_project/main.dart';

import 'snow_weather_api.dart';
import 'package:http/http.dart' as http;

Future<List<Item>> fetchTop20() async {
  final response = await http
      .get(Uri.parse('https://feeds.snocountry.net/getSnowReport.php?apiKey=SnoCountry.example&ions=rockies&action=top20'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    print('fetchTop20 - '+response.body);
    SnowWeather snowWeather = snowWeatherFromJson(response.body);
    return snowWeather.items;
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}