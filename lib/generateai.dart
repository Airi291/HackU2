import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'database_helper.dart';

class Generateai {
  static final Generateai instance = Generateai._privateConstructor();

  Generateai._privateConstructor();

  Future<GenerativeModel> _model() async {
    await dotenv.load(fileName: ".env");
    final apiKey = dotenv.env['GEMINI_API_KEY'];
    if (apiKey == null) {
      throw Exception('GEMINI_API_KEY is not defined in .env file');
    }
    return GenerativeModel(
      model: 'gemini-1.5-flash-latest',
      apiKey: apiKey,
    );
  }

  Future<List<String>> generateTodayGoals() async {
    final AimdbHelper = AimDatabaseHelper.instance;
    final aim = await AimdbHelper.getAim();
    final dbHelper = AchDatabaseHelper.instance;
    final achivement = await dbHelper.getAchievement();
    final content = [
      Content.text('''今年の抱負: $aim
          これまでの目標[日付1:目標1:達成したか1,...,日付n:目標n:達成したかn]: $achivement
          生成する内容: 抱負に向けて今日達成できる4つの目標とその理由
          出力形式: カンマ区切りで4つの目標とその理由
          出力例: 目標1,目標2,目標3,目標4,理由1,理由2,理由3,理由4''')
    ];
    final model = await _model();
    final response = await model.generateContent(content);
    if (response.text == null) {
      throw Exception('Failed to generate goals');
    }
    List<String> goals = response.text!.split(',');
    if (goals.length > 8) {
      throw Exception('Too many goals generated');
    }
    if (goals.length < 8) {
      throw Exception('Too few goals generated');
    }
    return goals;
  }
}
