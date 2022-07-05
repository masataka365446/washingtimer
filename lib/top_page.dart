import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:intl/intl.dart';
import 'package:openweather_app/weather.dart';
import 'package:openweather_app/zip_code.dart';

class TopPage extends StatefulWidget {
  const TopPage({Key? key}) : super(key: key);

  @override
  State<TopPage> createState() => _TopPageState();
}

class _TopPageState extends State<TopPage> {
  String? address = '_';

  String? errorMessage;

  String? washMessage;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        //縦並び
        child: Column(
          children: [
            Container(
                width: 200,
                child: TextField(
                  onSubmitted: (value) async {
                    print(value);
                    Map<String, String>? response = {};
                    response = await Zipcode.searchAddressFormZipcode(value);
                    errorMessage = response!['message'];
                    if (response.containsKey('address')) {
                      address = response['address'];
                      dayWeather = await Weather.getCurrentWeather(value);
                      Map<String, List<Weather>>? weatherForecast =
                          await Weather.getForecast(
                              lon: dayWeather?.lon, lat: dayWeather?.lat);
                      hourlyWeather = weatherForecast!['hourly'];
                      dailyWeather = weatherForecast['daily'];
                      if (dayWeather!.description.contains('晴れ')) {
                        washMessage = '選択の時間です';
                      }
                    }
                    print(address);
                    setState(() {});
                  },
                  decoration: InputDecoration(hintText: '郵便番号を入力'),
                )),
            Text(errorMessage == null ? '' : errorMessage!),
            SizedBox(
              height: 50,
            ),
            Text(
              address!,
              style: TextStyle(fontSize: 25),
            ),
            Text(dayWeather == null ? '_' : dayWeather!.description),
            Text(
              dayWeather == null ? '_' : '${dayWeather!.temp}°',
              style: TextStyle(fontSize: 80),
            ),

            //横並び
            Row(
              //中央揃え
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(dayWeather == null
                      ? '最高:_'
                      : '最高:${dayWeather!.tempMax}°'),
                ),
                Text(
                    dayWeather == null ? '最低:_' : '最低:${dayWeather!.tempMin}°'),
              ],
            ),
            Text('${washMessage}'),
            SizedBox(
              height: 50,
            ),
            Divider(
              height: 0,
            ),
            SingleChildScrollView(
              //通常は上下スクロールだから左右スクロールにする
              scrollDirection: Axis.horizontal,
              child: hourlyWeather == null
                  ? Container()
                  : Row(
                      //hourlyWeatherに入っている配列の数、処理する
                      children: hourlyWeather!.map((weather) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 8.0),
                          child: Column(
                            children: [
                              Text('${DateFormat("H").format(weather.time)}時'),
                              Image.network(
                                  'http://openweathermap.org/img/wn/${weather.icon}.png'),
                              Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Text(
                                  '${weather.temp}°',
                                  style: TextStyle(fontSize: 18),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
            ),
            Divider(
              height: 0,
            ),
            dailyWeather == null
                ? Container()
                : Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Column(
                          children: dailyWeather!.map((weather) {
                            return Container(
                              height: 50,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                      width: 50,
                                      child: Text(
                                          '${weekDay[weather.time.weekday - 1]}曜日')),
                                  Row(
                                    children: [
                                      Image.network(
                                          'http://openweathermap.org/img/wn/${weather.icon}.png'),
                                      Container(
                                        width: 50,
                                        child: Text(
                                          '${weather.rainyPercent}%',
                                          style: TextStyle(
                                              color: Colors.lightBlue),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    width: 50,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${weather.tempMax}',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                        Text(
                                          '${weather.tempMin}',
                                          style: TextStyle(fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  )
          ],
        ),
      ),
    );
  }
}
