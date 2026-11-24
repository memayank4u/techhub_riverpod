import 'package:hive/hive.dart';
import '../../core/database/hive_service.dart';
import '../models/coin_model.dart';

abstract class CryptoLocalDataSource {
  List<CoinModel> getCachedCoins();
  Future<void> cacheCoins(List<CoinModel> coins);
}

class CryptoLocalDataSourceImpl implements CryptoLocalDataSource {
  static const String keyCoins = 'cached_coins_list';

  @override
  List<CoinModel> getCachedCoins() {
    try {
      final box = Hive.box(HiveService.coinsBox);
      final rawList = box.get(keyCoins);
      if (rawList is List) {
        return rawList
            .map((item) => CoinModel.fromJson(Map<String, dynamic>.from(item)))
            .toList();
      }
    } catch (_) {}
    return [];
  }

  @override
  Future<void> cacheCoins(List<CoinModel> coins) async {
    final box = Hive.box(HiveService.coinsBox);
    final mapList = coins.map((c) => c.toMap()).toList();
    await box.put(keyCoins, mapList);
  }
}
