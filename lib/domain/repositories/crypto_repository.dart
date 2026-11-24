import '../entities/coin_entity.dart';
import '../../core/common/resource.dart';

abstract class CryptoRepository {
  Stream<Resource<List<CoinEntity>>> getCoins({bool forceRefresh = false});
  List<CoinEntity> searchCoins(String query);
}
