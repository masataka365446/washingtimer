import 'dart:convert';

import 'package:http/http.dart';

class Weather {
  int temp; //気温
  int tempMax; //最高気温
  int tempMin; //最低気温
  String description; //天気状態
  double lon; //経度
  double lat; //緯度
  String icon; //天気情報のアイコン
  DateTime time; //日時
  int rainyPercent; //降水確率

  Weather({
    required this.temp,
    required this.tempMax,
    required this.tempMin,
    required this.description,
    required this.icon,
    required this.lat,
    required this.lon,
    required this.time,
    required this.rainyPercent,
  });

  static String publicParametaer =
      '&appid=8c8f1daf08571c8efd9be1569d652c33&lang=ja&units=metric';

//今日の天気
  static Future<Weather?> getCurrentWeather(String zipCode) async {
    String _zipCode;

    //zipCodeに - が入っていなかったら - を追加してあげる処理
    if (zipCode.contains('-')) {
      _zipCode = zipCode;
    } else {
      _zipCode = zipCode.substring(0, 3) + '-' + zipCode.substring(3);
    }
    String url =
        'https://api.openweathermap.org/data/2.5/weather?zip=$_zipCode,JP$publicParametaer';
    try {
      var result = await get(Uri.parse(url));
      Map<String, dynamic> data = jsonDecode(result.body);
      Weather currentWeather = Weather(
        // data['weather'][0]['description']
        description: '晴れ',
        temp: data['main']['temp'].toInt(),
        tempMax: data['main']['temp_max'].toInt(),
        tempMin: data['main']['temp_min'].toInt(),
        lon: data['coord']['lon'],
        lat: data['coord']['lat'],
        icon: '4',
        rainyPercent: 12,
        time: DateTime(2022, 5, 11, 10),
      );
      return currentWeather;
    } catch (e) {
      print(e);
      return null;
    }
  }

//一時間ごとの天気
//日毎の天気
  static Future<Map<String, List<Weather>>?> getForecast(
      {double? lon, double? lat}) async {
    String url =
        'https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&exclude=minutely$publicParametaer';
    try {
      var result = await get(Uri.parse(url));
      Map<String, dynamic> data = jsonDecode(result.body);
      List<dynamic> hourlyWeatherData = data['hourly'];
      List<dynamic> dailyWeatherData = data['daily'];
      Map<String, List<Weather>>? response = {};
      print(hourlyWeatherData);
      List<Weather> hourlyWeather = hourlyWeatherData.map((weather) {
        return Weather(
          temp: weather['temp'].toInt(),
          tempMax: 21,
          tempMin: 12,
          description: '晴れ',
          lat: 12,
          lon: 12,
          time: DateTime.fromMillisecondsSinceEpoch(weather['dt'] * 1000),
          icon: weather['weather'][0]['icon'],
          rainyPercent: 1,
        );
      }).toList();
      List<Weather> dailyWeather = dailyWeatherData.map((weather) {
        return Weather(
          temp: 23,
          tempMax: weather['temp']['max'].toInt(),
          tempMin: weather['temp']['min'].toInt(),
          description: '曇り',
          icon: weather['weather'][0]['icon'],
          lat: 2,
          lon: 3,
          time: DateTime.fromMillisecondsSinceEpoch(weather['dt'] * 1000),
          rainyPercent:
              weather.containsKey('rain') ? weather['rain'].toInt() : 0,
        );
      }).toList();
      response['hourly'] = hourlyWeather;
      response['daily'] = dailyWeather;
      return response;
    } catch (e) {
      print(e);
      return null;
    }
  }
}

Weather? dayWeather;

//複数の天気を持つ
List<Weather>? hourlyWeather;

List<Weather>? dailyWeather;

List<String> weekDay = [
  '月',
  '火',
  '水',
  '木',
  '金',
  '土',
  '日',
];
