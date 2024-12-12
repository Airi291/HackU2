import 'package:flutter/material.dart';

class MyShrinePage extends StatefulWidget {
  final List<String> selectedParts; // 選択された部品の状態を引き継ぐ
  final bool isAchieved; // 目標達成状態

  MyShrinePage({Key? key, required this.selectedParts, required this.isAchieved}) : super(key: key);

  @override
  _MyShrinePageState createState() => _MyShrinePageState();
}

class _MyShrinePageState extends State<MyShrinePage> {
  late List<String> _selectedParts; // 選択された部品を保持
  late bool _isAchieved; // 達成状態を保持
  List<bool> _isSelected = [false, false, false, false, false]; // 各パーツの選択状態

  @override
  void initState() {
    super.initState();
    _selectedParts = List.from(widget.selectedParts); // 選択された部品を受け取る
    _isAchieved = widget.isAchieved; // 達成状態を受け取る
    _updateSelectedState(); // 選択状態を更新
  }

  // 選択された部品の状態を基に、_isSelectedの状態を更新
  void _updateSelectedState() {
    _isSelected[0] = _selectedParts.contains('image/torii.png');
    _isSelected[1] = _selectedParts.contains('image/hayashi.png');
    _isSelected[2] = _selectedParts.contains('image/ishidatami.png');
    _isSelected[3] = _selectedParts.contains('image/komainu.png');
    _isSelected[4] = _selectedParts.contains('image/honden.png');
  }

  String _getPartImage(int index) {
    switch (index) {
      case 0:
        return 'image/torii.png';
      case 1:
        return 'image/hayashi.png';
      case 2:
        return 'image/ishidatami.png';
      case 3:
        return 'image/komainu.png';
      case 4:
        return 'image/honden.png'; // honden.png を追加
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    double hayashiSize = screenSize.width * 0.7; // hayashi.pngの幅を画面幅の70%に設定

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
                          Navigator.pop(context, {
                            'selectedParts': _selectedParts,
                            'isAchieved': _isAchieved,
                          });
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
                      crossAxisAlignment: CrossAxisAlignment.center, // 中央寄せ
                      children: [
                        // 「達成日数：1日」テキストを中央に配置
                        Text(
                          '達成日数：${_isAchieved ? 51 : 50}日', // _isAchievedがtrueの場合は51日、falseの場合は50日
                          style: TextStyle(
                            fontSize: screenSize.width * 0.07, // フォントサイズを画面サイズに応じて調整
                            fontWeight: FontWeight.bold,
                            color: Colors.black, // テキストの色
                          ),
                          textAlign: TextAlign.center, // 中央揃え
                        ),
                        SizedBox(height: 20), // スペース調整
                        // スタックでhayashi.pngと選択された部品を重ねる
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'image/tamazyari.png', // 背景に使用する画像
                              width: hayashiSize,
                              height: hayashiSize,
                              fit: BoxFit.cover,
                            ),
                            // クリックされた部品を順番に背景として重ねる
                            ..._buildPositionedParts(),
                          ],
                        ),
                        SizedBox(height: 20),
                        // 「お守り」テキスト
                        Center(
                          child: Text(
                            '神社パーツ',
                            style: TextStyle(
                              fontSize: screenSize.width * 0.07,
                              fontWeight: FontWeight.bold,
                              color: Colors.black, // テキストの色
                            ),
                          ),
                        ),
                        // パーツのリスト
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildPartIcon(0, 'image/torii.png', screenSize),
                            _buildPartIcon(1, 'image/hayashi.png', screenSize),
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildPartIcon(2, 'image/ishidatami.png', screenSize),
                            _buildPartIcon(3, 'image/komainu.png', screenSize),
                            // 追加されたパーツの表示
                            if (_isAchieved) // 達成した場合にhonden.pngを表示
                              _buildPartIcon(4, 'image/honden.png', screenSize),
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

  // 部品の位置に合わせて重ねる
  List<Widget> _buildPositionedParts() {
    List<Widget> positionedParts = [];
    // クリックされた部品を順番に背景として重ねる
    // 必ず指定した順番で部品を重ねる
    List<String> fixedOrder = [
      'image/hayashi.png',
      'image/honden.png',
      'image/torii.png',
      'image/ishidatami.png',
      'image/komainu.png',
    ];

    for (String part in fixedOrder) {
      if (_selectedParts.contains(part)) {
        positionedParts.add(Positioned(
          top: 0, // 各部品を中央に配置
          child: Image.asset(
            part,
            width: 250, // hayashi.pngと同じ横幅
            height: 250, // hayashi.pngと同じ高さ
            fit: BoxFit.cover,
          ),
        ));
      }
    }
    return positionedParts;
  }

  // パーツアイコンを表示するウィジェット
  Widget _buildPartIcon(int index, String imagePath, Size screenSize) {
    return GestureDetector(
      onTap: () {
        setState(() {
          // クリックされた部品を追加または削除
          if (!_selectedParts.contains(imagePath)) {
            _selectedParts.add(imagePath);
          } else {
            _selectedParts.remove(imagePath);
          }
          // 部品の選択状態を更新
          _updateSelectedState();
        });
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10), // アイコン間の余白
        decoration: BoxDecoration(
          border: Border.all(
            color: _isSelected[index] ? Colors.green : Colors.grey, // 選択されていれば緑色、されていなければ灰色
            width: 2, // 枠線の太さ
          ),
          borderRadius: BorderRadius.circular(8), // 枠を丸める
        ),
        child: Image.asset(
          imagePath,
          width: screenSize.width * 0.23,
          height: screenSize.width * 0.23,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
