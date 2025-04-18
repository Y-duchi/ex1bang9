import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:kakao_flutter_sdk/kakao_flutter_sdk.dart';
import 'firebase_options.dart';
import 'screens/login_screen.dart';


void main() {

  //kakao login
  // runApp() 호출 전 Flutter SDK 초기화
  KakaoSdk.init(
    nativeAppKey: 'a7fe87be3ea77008e4b3520c2d2df8bf',
    javaScriptAppKey: 'a738dd0a9f376761ca0685a148a27e21',
  );


  // firebase login
  runApp(const MyApp());

}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '방꾸석',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          elevation: 0.5,
        ),
        colorScheme: const ColorScheme.light(
          primary: Colors.brown,
          background: Colors.white,
        ),
        fontFamily: 'Pretendard',
      ),
      home: LoginScreen(),
    );
  }
}