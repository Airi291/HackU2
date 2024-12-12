import 'package:flutter/material.dart';
import 'today_goal.dart';

class HouhuPage extends StatefulWidget {
  @override
  _HouhuPageState createState() => _HouhuPageState();
}

class _HouhuPageState extends State<HouhuPage> {
  String _goalText = ''; // 入力された目標を格納

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SingleChildScrollView( // スクロール可能にする
        child: Container(
          width: screenSize.width, // 横幅を画面幅に合わせる
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('image/background.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center, // 子要素を中央揃え
            children: [
              SizedBox(height: screenSize.height * 0.05), // 上部余白を調整
              // 上部のテキスト
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  '今年1年の抱負を入力してください',
                  style: TextStyle(
                    fontSize: 22, // フォントサイズを大きく
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: screenSize.height * 0.03), // テキストと画像の間隔調整
              // image/myshrine.png
              Image.asset(
                'image/myshrine.png',
                width: screenSize.width * 0.8, // サイズを画面幅に応じて調整
                height: screenSize.width * 0.8,
              ),
              SizedBox(height: screenSize.height * 0.05), // 画像と次の要素の間隔調整
              // image/ema.pngとテキスト入力バー
              Stack(
                alignment: Alignment.topCenter,
                children: [
                  Image.asset(
                    'image/ema.png',
                    width: screenSize.width * 0.8, // ema.png を大きく
                    height: screenSize.width * 0.6,
                  ),
                  Positioned(
                    top: screenSize.width * 0.3, // ema.png の少し下に配置
                    child: Container(
                      width: screenSize.width * 0.7,
                      child: TextField(
                        onChanged: (value) {
                          setState(() {
                            _goalText = value; // 入力された値を更新
                          });
                        },
                        decoration: InputDecoration(
                          hintText: 'ここにご記入ください。',
                          hintStyle: TextStyle(color: Colors.grey),
                          filled: true,
                          fillColor: Colors.transparent, // 背景を透明に
                          border: InputBorder.none, // 枠を非表示
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 18, // 入力文字のフォントサイズを大きく
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenSize.height * 0.05), // テキストバーとボタンの間隔
              // 決定ボタン
              if (_goalText.isNotEmpty) // 入力が空でない場合に表示
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEB5649),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.2, // ボタン幅を調整
                      vertical: 15,
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TodayGoalPage(),
                      ),
                    );
                  },
                  child: Text(
                    '決定',
                    style: TextStyle(fontSize: 20, color: Colors.white),
                  ),
                ),
              SizedBox(height: screenSize.height * 0.05), // 下部余白を調整
            ],
          ),
        ),
      ),
    );
  }
}
