import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hacku2/main.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // アプリを構築してフレームをトリガーします。
    await tester.pumpWidget(MyApp());

    // カウンターが0で開始することを確認します。
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    // '+'アイコンをタップしてフレームをトリガーします。
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // カウンターが1にインクリメントされたことを確認します。
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
