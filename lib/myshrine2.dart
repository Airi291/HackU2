import 'package:flutter/material.dart';

class MyShrinePage2 extends StatelessWidget {
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
          // 上部バーとコンテンツ
          SafeArea(
            child: Column(
              children: [
                // 上部バー
                Container(
                  height: 80, // 上部バーの高さ
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
                      SizedBox(width: 48), // 戻るボタンのサイズ分スペース
                    ],
                  ),
                ),
                // コンテンツ
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // 左寄せ
                      children: [
                        Stack(
                          children: [
                            // sensu.png
                            Align(
                              alignment: Alignment.topLeft,
                              child: Image.asset(
                                'image/sensu.png',
                                width: screenSize.width * 0.3,
                                height: screenSize.width * 0.3,
                              ),
                            ),
                            Positioned(
                              top: screenSize.width * 0.08,
                              left: screenSize.width * 0.05,
                              child: Text(
                                'レベル１',
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.05,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white, // 白文字
                                ),
                              ),
                            ),
                            Positioned(
                              top: screenSize.width * 0.1,
                              left: screenSize.width * 0.35,
                              child: Text(
                                '達成日数：0日',
                                style: TextStyle(
                                  fontSize: screenSize.width * 0.07,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Center(
                          child: Image.asset(
                            'image/16.png',
                            width: screenSize.width * 0.7,
                            height: screenSize.width * 0.7,
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            'お守り',
                            style: TextStyle(
                              fontSize: screenSize.width * 0.07,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // テキストの色
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                                'image/omamori2.png',
                                width: screenSize.width * 0.3,
                                height: screenSize.width * 0.3,
                              ),
                            Image.asset(
                              'image/omamori2.png',
                              width: screenSize.width * 0.3,
                              height: screenSize.width * 0.3,
                            ),
                            Image.asset(
                              'image/omamori2.png',
                              width: screenSize.width * 0.3,
                              height: screenSize.width * 0.3,
                            ),
                          ],
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
