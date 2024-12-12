import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'database_helper.dart';

class Generateai {
  Future<GenerativeModel> _model() async {
    await dotenv.load(fileName: ".env");
    final apiKey = dotenv.env['API_KEY'];
    if (apiKey == null) {
      throw Exception('API_KEY is not defined in .env file');
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
      Content.text(
          '$aimに向けて今日できることを4つ出力してください。これまでの実績は$achivementです。出力はカンマ区切りにしてください。')
    ];
    final model = await _model();
    final response = await model.generateContent(content);
    if (response.text == null) {
      return generateTodayGoals();
    }
    List<String> goals = response.text!.split(',');
    if (goals.length != 4) {
      return generateTodayGoals();
    }
    return goals;
  }
}