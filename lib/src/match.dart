import 'package:fuzzywuzzy/fuzzywuzzy.dart' as fuzzy;
import 'index_dao.dart';

/// Fuzzy finder
class Matcher {
  const Matcher();

  static Future<List<String>> match(String prompt) async {
    final indexes = await IndexDao.query();
    List<String> results = [];

    for (final index in indexes) {
      final ratio =
          fuzzy.partialRatio(index.text.toString().toLowerCase(), prompt);

      if (ratio >= 50) {
        results.add(index.path);

        print(index.path);
        print(ratio);
      }
    }

    return results;
  }
}
