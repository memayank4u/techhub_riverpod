import '../entities/coin_entity.dart';
import '../repositories/crypto_repository.dart';
import '../../core/common/resource.dart';

class GetCoinsUseCase {
  final CryptoRepository repository;
  GetCoinsUseCase(this.repository);

  Stream<Resource<List<CoinEntity>>> call({bool forceRefresh = false}) {
    return repository.getCoins(forceRefresh: forceRefresh);
  }
}
