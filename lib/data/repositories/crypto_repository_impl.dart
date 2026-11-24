import '../../core/common/resource.dart';
import '../../domain/entities/coin_entity.dart';
import '../../domain/repositories/crypto_repository.dart';
import '../datasources/crypto_local_datasource.dart';
import '../datasources/crypto_remote_datasource.dart';

class CryptoRepositoryImpl implements CryptoRepository {
  final CryptoRemoteDataSource remoteDataSource;
  final CryptoLocalDataSource localDataSource;

  CryptoRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Stream<Resource<List<CoinEntity>>> getCoins({bool forceRefresh = false}) async* {
    // 1. Emit cached coins from Hive immediately
    final cached = localDataSource.getCachedCoins();
    yield ResourceLoading(data: cached);

    final shouldFetch = cached.isEmpty || forceRefresh;

    if (shouldFetch) {
      try {
        // 2. Fetch from network
        final remoteModels = await remoteDataSource.fetchCoins();

        // 3. Update Hive local storage (SSOT)
        await localDataSource.cacheCoins(remoteModels);

        // 4. Emit updated list
        yield ResourceSuccess(remoteModels);
      } catch (e) {
        // 5. Offline fallback preserving cached data
        yield ResourceError(
          'Unable to reach market server. Showing cached data.',
          data: cached,
        );
      }
    } else {
      yield ResourceSuccess(cached);
    }
  }

  @override
  List<CoinEntity> searchCoins(String query) {
    final cached = localDataSource.getCachedCoins();
    if (query.trim().isEmpty) return cached;
    final lower = query.trim().toLowerCase();
    return cached
        .where((c) =>
            c.name.toLowerCase().contains(lower) ||
            c.symbol.toLowerCase().contains(lower))
        .toList();
  }
}
