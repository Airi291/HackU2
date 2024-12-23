import 'package:flutter/material.dart';
import 'dart:async'; // タイマーを使用するために必要
import 'houfu.dart';
import 'today_goal.dart';
import 'database_helper.dart';

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
  final aimDb = AimDatabaseHelper.instance;
  final achDb = AchDatabaseHelper.instance;
  int diff_of_year = 0;
  String aim = '';

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    await _culDiffYear(); // 年の差を計算
    if (diff_of_year != 0) {
      await aimDb.resetAim();
      await achDb.resetAchieve();
    }
    await _catchAim(); // 目標を取得

    // 3秒後にページ遷移
    Timer(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        aim == ''
            ? MaterialPageRoute(builder: (context) => HouhuPage())
            : MaterialPageRoute(builder: (context) => TodayGoalPage()),
      );
    });
  }

  // 今年の目標を設定してから何年経過したかを計算
  Future<void> _culDiffYear() async {
    final _achMaps = await achDb.getAchieve();
    if (_achMaps.isEmpty) {
      return;
    }
    final _setYear = _achMaps[0]['date'].toString().substring(0, 4);
    final _nowYear = DateTime.now().toString().substring(0, 4);
    setState(() {
      diff_of_year = int.parse(_nowYear) - int.parse(_setYear);
      print(diff_of_year);
    });
  }

  Future<void> _catchAim() async {
    final _aim = await aimDb.getAim();
    setState(() {
      aim = _aim;
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
