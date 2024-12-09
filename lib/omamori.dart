import 'package:flutter/material.dart';

class OmamoriPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // 背景画像
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('image/background.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // 上部バー
                Container(
                  height: 80, // 少し高さを大きく
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('image/background.png'), // 背景画像
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          Icons.arrow_back, // 戻るアイコン
                          color: Colors.black, // アイコンの色
                        ),
                        onPressed: () {
                          Navigator.pop(context); // 前のページに戻る
                        },
                      ),
                      Expanded(
                        child: Center(
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              Text(
                                '達成日数1日目',
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 48), // 戻るボタンのサイズ分スペース
                    ],
                  ),
                ),
                // コンテンツ
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'スタートのお守り',
                          style: TextStyle(
                            fontSize: screenSize.width * 0.08,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20), // テキストと画像の間隔
                        Image.asset(
                          'image/omamori.png',
                          width: screenSize.width * 0.6, // 大きめに設定
                          height: screenSize.width * 0.6,
                        ),
                        SizedBox(height: 20), // 画像と日付の間隔
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          decoration: BoxDecoration(
                            color: Colors.red, // 背景赤
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '2024/12/14',
                            style: TextStyle(
                              fontSize: screenSize.width * 0.06,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        SizedBox(height: 20), // 日付と説明文の間隔
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            '新たな目標に向けての第一歩を\n'
                                '踏み出したあなたに贈られるお守りです。\n'
                                'このお守りがあれば、\n'
                                'どんな目標も踏み出す勇気を\n'
                                '与えてくれることでしょう。',
                            style: TextStyle(
                              fontSize: screenSize.width * 0.045,
                              height: 1.6, // 行間を広げる
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
