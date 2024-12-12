import 'package:flutter/material.dart';
import 'dart:math';

class OmamoriPage extends StatelessWidget {
  // ランダムなメッセージを表示するためのリスト
  final List<String> messages = [
    "おめでとう！\n新しいパーツをゲットしました！",
    "目標達成お疲れ様！\n神社のパーツが手に入りました！",
    "目標達成！\n新しいパーツで神社が進化します！",
  ];

  // ランダムにメッセージを選ぶ
  String getRandomMessage() {
    final random = Random();
    return messages[random.nextInt(messages.length)];
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('image/background.png'), // 背景画像
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('image/background.png'), // 背景画像
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // ランダムなメッセージを表示
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  getRandomMessage(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: screenSize.width * 0.05, // フォントサイズを画面サイズに応じて調整
                    fontWeight: FontWeight.bold,
                    color: Colors.black, // テキストカラー
                  ),
                ),
              ),
              SizedBox(height: 20), // メッセージと画像の間隔
              // サイズを大きく設定
              Image.asset(
                'image/honden.png',
                width: screenSize.width * 1.2, // サイズを大きく設定（画面の幅に応じて調整）
                height: screenSize.width * 1.2, // 高さも調整
              ),
            ],
          ),
        ),
      ),
    );
  }
}
