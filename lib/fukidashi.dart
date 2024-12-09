import 'package:flutter/material.dart';

class Fukidashi extends StatelessWidget {
  final String text; // 吹き出し内に表示するテキスト
  final double maxWidth; // 吹き出しの最大幅を指定
  final Color backgroundColor; // 吹き出しの背景色
  final Color textColor; // テキストの色
  final double borderRadius; // 吹き出しの角の丸み
  final double arrowSize; // 吹き出しの矢印サイズ

  const Fukidashi({
    Key? key,
    required this.text, // テキストは必須
    this.maxWidth = 200, // 最大幅のデフォルト値は200
    this.backgroundColor = Colors.white, // 背景色のデフォルト値は白
    this.textColor = Colors.black, // テキスト色のデフォルト値は黒
    this.borderRadius = 12, // 角の丸みのデフォルト値は12
    this.arrowSize = 12, // 矢印のサイズのデフォルト値は12
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // 吹き出しの矢印部分を見切れさせない
      children: [
        // 吹き出し本体部分
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8), // 内側の余白
          decoration: BoxDecoration(
            color: backgroundColor, // 背景色を設定
            borderRadius: BorderRadius.circular(borderRadius), // 角を丸める
            boxShadow: [
              BoxShadow(
                color: Colors.black26, // 影の色
                blurRadius: 4, // 影のぼかし量
                offset: Offset(0, 4), // 影の位置 (右0, 下4)
              ),
            ],
          ),
          constraints: BoxConstraints(maxWidth: maxWidth), // 最大幅を制限
          child: Text(
            text, // 吹き出し内に表示するテキスト
            style: TextStyle(
              fontSize: 16, // フォントサイズ
              color: textColor, // テキストの色
            ),
            softWrap: true, // テキストの折り返しを許可
          ),
        ),
        // 吹き出しの矢印部分
        Positioned(
          top: 20, // 矢印の垂直位置
          right: -arrowSize, // 矢印を右側に配置
          child: CustomPaint(
            size: Size(arrowSize, arrowSize), // 矢印のサイズ
            painter: _FukidashiArrowPainter(backgroundColor), // 矢印の描画を行うペインター
          ),
        ),
      ],
    );
  }
}

// 矢印部分を描画するためのカスタムペインター
class _FukidashiArrowPainter extends CustomPainter {
  final Color color; // 矢印の背景色

  _FukidashiArrowPainter(this.color); // コンストラクタで色を初期化

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color; // 描画に使用するペイントオブジェクト
    final path = Path()
      ..moveTo(0, 0) // 矢印の左上
      ..lineTo(size.width, size.height / 2) // 矢印の右中央
      ..lineTo(0, size.height) // 矢印の左下
      ..close(); // パスを閉じて三角形を完成させる

    canvas.drawPath(path, paint); // パスを描画
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false; // 再描画の必要がないためfalseを返す
}
