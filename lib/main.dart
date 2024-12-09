import 'package:flutter/material.dart';
import 'dart:async'; // タイマーを使用するために必要
import 'houfu.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hacku App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // 3秒後に houhu.dart へ遷移
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HouhuPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('image/background.png'), // 背景画像を設定
            fit: BoxFit.cover, // 背景画像を全体に拡大または縮小
          ),
        ),
        child: Center(
          child: Image.asset(
            'image/logo.png', // ロゴ画像
            width: 300, // ロゴの幅
            height: 300, // ロゴの高さ
          ),
        ),
      ),
    );
  }
}
