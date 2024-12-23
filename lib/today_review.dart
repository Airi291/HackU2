import 'package:flutter/material.dart';
import 'dart:math';
import 'fukidashi.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;
import 'myshrine.dart';
import 'omamori.dart';
import 'database_helper.dart';

class TodayReview extends StatefulWidget {
  final List<String> selectedParts;

  TodayReview({required this.selectedParts});
  @override
  _TodayReviewState createState() => _TodayReviewState();
}

class _TodayReviewState extends State<TodayReview> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  late AchDatabaseHelper db;
  late List<String> _selectedParts;
  bool _isAchieved = false; // 今日の目標が達成されたか
  bool _isNotificationOn = true; // 通知がONかどうか
  TimeOfDay _notificationTime = TimeOfDay(hour: 20, minute: 0); // 通知時刻
  String goalText = ''; // 目標のテキスト
  int _databaseId = 0;

  @override
  void initState() {
    super.initState();
    _selectedParts = List.from(widget.selectedParts);
    _initializeNotifications();
    tz_data.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation('Asia/Tokyo'));
    _openDatabase();
    _getGoalText();
  }

  // 通知の初期化
  void _initializeNotifications() {
    const DarwinInitializationSettings macOSInitializationSettings =
        DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initializationSettings =
        InitializationSettings(macOS: macOSInitializationSettings);

    flutterLocalNotificationsPlugin.initialize(initializationSettings);

    print("通知が初期化されました");
  }

  // データベースを開く
  Future<void> _openDatabase() async {
    db = AchDatabaseHelper.instance;
  }

  // 目標のテキストを取得
  Future<void> _getGoalText() async {
    try {
      final date = DateTime.now().toString().substring(0, 10);
      final goal = await db.getTodayAchievement(date);
      final id = await db.getAchieveCount();
      setState(() {
        goalText = goal.split(':')[0];
        if (goal.split(':')[1] == '1') {
          _isAchieved = true;
        }
        _databaseId = id;
      });
    } catch (e) {
      goalText = 'エラー: $e';
    }
  }

  // 通知をスケジュール
  Future<void> _scheduleNotification() async {
    if (!_isNotificationOn || _isAchieved) {
      print(
          "通知はスケジュールされません (_isNotificationOn: $_isNotificationOn, _isAchieved: $_isAchieved)");
      return;
    }

    final now = DateTime.now();
    final selectedDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _notificationTime.hour,
      _notificationTime.minute,
    );

    // 現在時刻より前の場合、翌日にスケジュール
    final notificationTime = selectedDateTime.isBefore(now)
        ? selectedDateTime.add(Duration(days: 1))
        : selectedDateTime;

    final tzTime = tz.TZDateTime.from(notificationTime, tz.local);

    const DarwinNotificationDetails macOSNotificationDetails =
        DarwinNotificationDetails(
      subtitle: '目標確認の通知',
      presentAlert: true,
      presentSound: true,
    );

    const NotificationDetails notificationDetails =
        NotificationDetails(macOS: macOSNotificationDetails);

    await flutterLocalNotificationsPlugin.zonedSchedule(
      0, // 通知ID
      goalText, // タイトルに目標を表示
      _getRandomComment(_isAchieved), // 通知内容
      tzTime, // 通知時刻
      notificationDetails,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle, // 必須パラメータ
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );

    print("通知がスケジュールされました: $tzTime");
  }

  // コメントリスト
  List<String> _commentsWhenNotAchieved = [
    "目標達成に向けて、あと少し！\nあきらめずにがんばろう！",
    "今日はどうだった？\n諦めないで！",
    "あなたならきっとできる！\n一歩一歩前進しよう！",
    "どんな小さな進歩も\n大きな成果に繋がりますよ！",
    "ひとつずつ進んでいきましょう\n小さな積み重ねが大きな力になりますよ！",
  ];

  List<String> _commentsWhenAchieved = [
    "目標達成おめでとうございます！\nこれからも一歩一歩前進していきましょう！",
    "よくやりましたね！達成できたあなたは本当に素晴らしい。次も頑張りましょう！",
    "お見事です！\n次も一緒に頑張りましょう！",
    "お疲れさまでした！\nこれからもどんどん成長していく姿を楽しみにしています！",
    "素晴らしい！努力が実を結びましたね。\n次もこの調子で進んでいきましょう！",
  ];

  // ランダムコメント生成
  String _getRandomComment(bool isAchieved) {
    final random = Random();
    return (isAchieved ? _commentsWhenAchieved : _commentsWhenNotAchieved)[
        random.nextInt(isAchieved
            ? _commentsWhenAchieved.length
            : _commentsWhenNotAchieved.length)];
  }

  // ランダム画像を選択
  String _getRandomImage() {
    final random = Random();
    List<String> images = [
      'image/jinja_miko.png', // 舞妓さん
      'image/jinja_kannushi.png', // 神主さん
    ];
    return images[random.nextInt(images.length)];
  }

  // 通知時刻設定ダイアログを表示
  Future<void> _selectNotificationTime() async {
    final TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _notificationTime,
    );

    if (pickedTime != null) {
      setState(() {
        _notificationTime = pickedTime;
        print('通知時刻が設定されました: ${_notificationTime.format(context)}');
        _scheduleNotification(); // 通知を再スケジュール
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('image/background.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: screenSize.height * 0.01),

            // 今日の目標
            Stack(
              children: [
                Center(
                  child: SizedBox(
                    width: screenSize.width,
                    height: screenSize.width * 0.4,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Image.asset(
                          'image/icon_makimono.png',
                          width: screenSize.width,
                          fit: BoxFit.cover,
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.center,
                            child: Text(
                              goalText, // 受け取った目標を表示
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: screenSize.width * 0.08,
                                height: 1.5,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            Spacer(),

            // 達成ボタン
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_isAchieved)
                  Padding(
                    padding: EdgeInsets.only(bottom: 10),
                    child: TextButton(
                      onPressed: () {
                        setState(() {
                          _isAchieved = false;
                          db.chengeAchieve(_databaseId);
                          _selectedParts.remove('image/honden.png');
                        });
                      },
                      style: TextButton.styleFrom(
                        foregroundColor: Color(0xFF79747E),
                        textStyle: TextStyle(
                          fontSize: screenSize.width * 0.05,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      child: Text('取り消し'),
                    ),
                  ),

                // 「達成した？」 ボタンの表示
                if (!_isAchieved)
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        _isAchieved = true;
                        db.chengeAchieve(_databaseId);
                        _selectedParts.add('image/honden.png');
                      });

                      // 「達成した!」 に変わった時にお守りページに遷移
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OmamoriPage(),
                        ),
                      );
                    },
                    child: Container(
                      width: screenSize.width * 0.6,
                      height: screenSize.width * 0.6,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.red,
                          width: 4,
                        ),
                      ),
                      child: Center(
                        child: Text(
                          '達成した？',
                          style: TextStyle(
                            fontSize: screenSize.width * 0.07,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ),
                    ),
                  ),

                // 「達成した!」 ボタンの表示
                if (_isAchieved)
                  Padding(
                      padding: EdgeInsets.only(top: 10),
                      child: GestureDetector(
                        child: Container(
                          width: screenSize.width * 0.6,
                          height: screenSize.width * 0.6,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.green,
                              width: 4,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '達成した!',
                              style: TextStyle(
                                fontSize: screenSize.width * 0.07,
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      )),

                SizedBox(height: 20),
                TextButton(
                  onPressed: _selectNotificationTime,
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black,
                  ),
                  child: Text('通知時刻を設定: ${_notificationTime.format(context)}'),
                ),
                SizedBox(height: 10),
                SwitchListTile(
                  dense: true,
                  title: Row(
                    children: [
                      Icon(
                        Icons.notifications,
                        color: Colors.black,
                      ),
                      SizedBox(width: 8),
                      Text(
                        '通知をオンにする',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                  value: _isNotificationOn,
                  onChanged: (value) {
                    setState(() {
                      _isNotificationOn = value;
                      if (_isNotificationOn) {
                        _scheduleNotification(); // 通知を再スケジュール
                      }
                    });
                  },
                  activeColor: Colors.green,
                ),
                // My神社ボタン
                SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEB5649),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenSize.width * 0.2,
                      vertical: 15,
                    ),
                  ),
                  onPressed: () {
                    // 選択された部品にhonden.pngが含まれている場合、神社ページに遷移
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MyShrinePage(
                          selectedParts: _selectedParts,
                          isAchieved: _isAchieved,
                        ),
                      ),
                    );
                  },
                  child: Text(
                    'My神社',
                    style: TextStyle(
                      fontSize: 20,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Fukidashi(
                    text: _getRandomComment(_isAchieved),
                    maxWidth: screenSize.width * 0.65,
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    borderRadius: 12,
                    arrowSize: 12,
                  ),
                  SizedBox(width: 10),
                  ClipRRect(
                    child: Image.asset(
                      _getRandomImage(),
                      width: screenSize.width * 0.2,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
