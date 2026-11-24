import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static const String coinsBox = 'coins_box';
  static const String articlesBox = 'articles_box';
  static const String bookmarksBox = 'bookmarks_box';
  static const String interviewBox = 'interview_box';
  static const String themeBox = 'theme_box';

  static Future<void> init() async {
    await Hive.initFlutter();
    await Hive.openBox(coinsBox);
    await Hive.openBox(articlesBox);
    await Hive.openBox(bookmarksBox);
    await Hive.openBox(interviewBox);
    await Hive.openBox(themeBox);
  }
}
