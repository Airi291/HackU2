import 'package:flutter/material.dart';
import 'today_review.dart';
import 'database_helper.dart';
import 'generateai.dart';

class TodayGoalPage extends StatefulWidget {
  @override
  _TodayGoalPageState createState() => _TodayGoalPageState();
}

class _TodayGoalPageState extends State<TodayGoalPage> {
  List<String> _goalTexts = ['ロード中']; // 目標のテキスト
  final db = AchDatabaseHelper.instance; // データベースヘルパー
  bool _isLoading = true; // ローディング中かどうか
  bool _isSelect = false;
  int _selectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _catchLatestDate();
    _generateGoals(); // 目標を生成
  }

  Future<void> _catchLatestDate() async {
    final _latestDateId = await db.getAchieveCount();
    if (_latestDateId == 0) {
      return;
    }
    final _dbMaps = await db.getAchieve();
    final _latestDate = _dbMaps[_latestDateId - 1]['date'];
    final _today = DateTime.now().toString().substring(0, 10);
    if (_latestDate != _today) {
      return;
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => TodayReview(
          selectedParts: [],
        ),
      ),
    );
  }

  Future<void> _generateGoals() async {
    try {
      final goals = await Generateai.instance.generateTodayGoals();
      setState(() {
        _goalTexts = goals;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _goalTexts = ['$e'];
        _isLoading = false;
      });
    }
  }

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
              if (_isLoading) // ローディング中の場合
                CircularProgressIndicator(), // ローディングアイコン
              if (!_isLoading)
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
              if (!_isLoading)
                // 中央の画像とその上のテキスト
                Expanded(
                  child: Center(
                      child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      mainAxisSpacing: 20,
                                      crossAxisSpacing: 20,
                                      childAspectRatio: 1),
                              itemCount: 4,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _isSelect = true;
                                      _selectedIndex = index;
                                    });
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      border:
                                          (_isSelect && _selectedIndex == index)
                                              ? Border.all(
                                                  color: Colors.black,
                                                  width: 3,
                                                )
                                              : null,
                                      image: DecorationImage(
                                        image: AssetImage('image/ema.png'),
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _goalTexts[index],
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ),
                                );
                              }))),
                ),

              if (!_isLoading && _isSelect)
                // 選択された目標が生成された理由
                Padding(
                    padding:
                        const EdgeInsets.only(bottom: 60, left: 20, right: 20),
                    child: Text(
                      _goalTexts[_selectedIndex + 4],
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                      ),
                    )),
              if (!_isLoading && _isSelect)
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
                            // 目標を保存
                            db.insertAchieve(_goalTexts[_selectedIndex],
                                DateTime.now().toString().substring(0, 10));
                            // TodayReviewPageに遷移
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TodayReview(
                                  selectedParts: [],
                                ), // 必須パラメータを渡す
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
