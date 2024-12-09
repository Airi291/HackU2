import 'package:flutter/material.dart';
import 'today_review.dart';

class TodayGoalPage extends StatefulWidget {
  @override
  _TodayGoalPageState createState() => _TodayGoalPageState();
}

class _TodayGoalPageState extends State<TodayGoalPage> {
  String goalText = '30分運動する'; // 目標のテキスト

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('image/background.png'), // 背景画像
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // 上部テキスト
              Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Text(
                  '今日の目標はこちらです。\n目標達成を目指して頑張りましょう',
                  style: TextStyle(
                    fontSize: 20, // 大きなフォントサイズ
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // 中央の画像とその上のテキスト
              Expanded(
                child: Center(
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Image.asset(
                        'image/ema.png', // 中央の画像
                        width: 500, // 大きな画像サイズ
                        height: 500,
                      ),
                      Text(
                        goalText, // 可変の目標テキスト
                        style: TextStyle(
                          fontSize: 35, // 大きなフォントサイズ
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // 下部のボタン
              Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: Column(
                  children: [
                    // 「はじめる」ボタン
                    SizedBox(
                      width: 200, // ボタンの幅を広げる
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEB5649), // ボタンの背景色
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero, // 四角形のボタン
                          ),
                        ),
                        onPressed: () {
                          // TodayReviewPageに遷移
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TodayReview(goalText: goalText), // 必須パラメータを渡す
                            ),
                          );
                        },
                        child: Text(
                          'はじめる',
                          style: TextStyle(
                            fontSize: 20, // ボタンテキストのフォントサイズ
                            color: Colors.white, // ボタンの文字色
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 20), // ボタン間のスペース
                    // 「目標を変更する」ボタン
                    SizedBox(
                      width: 200, // ボタンの幅を広げる
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.grey, // ボタンの背景色
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero, // 四角形のボタン
                          ),
                        ),
                        onPressed: () {
                          // テキストを「目標を変更します」に変更
                          setState(() {
                            goalText = '目標を変更します';
                          });
                        },
                        child: Text(
                          '目標を変更する',
                          style: TextStyle(
                            fontSize: 20, // ボタンテキストのフォントサイズ
                            color: Colors.white, // ボタンの文字色
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
