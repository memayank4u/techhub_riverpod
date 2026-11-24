import '../entities/coin_entity.dart';
import '../repositories/crypto_repository.dart';

class SearchCoinsUseCase {
  final CryptoRepository repository;
  SearchCoinsUseCase(this.repository);

  List<CoinEntity> call(String query) {
    return repository.searchCoins(query);
  }
}
