import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:openweather_app/top_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //画面右上の文字を消す
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const TopPage(),
    );
  }
}

//todo　現在の天気情報を表示
//todo　1時間ごとの天気を表示
//todo　日毎の天気を表示
//todo　郵便番号検索のUIを表示

//todo　郵便番号から住所を取得
//todo　郵便番号検索APIをdartで実施
//todo　検索時に郵便番号から住所を取得・表示
//todo　検索欄への入力内容に間違いがある際にエラー表示
//todo　現在の天気情報を取得
//todo　現在の天気情報をdartで取得
//todo　取得した情報から現在の天気情報を表示
//todo　1時間ごとの天気情報を取得
//todo　取得した情報から現在の天気情報を表示
//todo　日毎の天気情報を取得
//todo　取得した情報から日毎の天気情報を表示


