import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:techhub_riverpod/core/common/resource.dart';
import 'package:techhub_riverpod/domain/entities/coin_entity.dart';
import 'package:techhub_riverpod/domain/usecases/get_coins_usecase.dart';
import 'package:techhub_riverpod/domain/usecases/search_coins_usecase.dart';
import 'package:techhub_riverpod/presentation/notifiers/crypto_notifier.dart';

class MockGetCoinsUseCase extends Mock implements GetCoinsUseCase {}
class MockSearchCoinsUseCase extends Mock implements SearchCoinsUseCase {}

void main() {
  late MockGetCoinsUseCase mockGetCoinsUseCase;
  late MockSearchCoinsUseCase mockSearchCoinsUseCase;

  const sampleCoin = CoinEntity(
    id: 'bitcoin',
    symbol: 'BTC',
    name: 'Bitcoin',
    imageUrl: 'https://example.com/btc.png',
    currentPrice: 90000.0,
    marketCap: 1800000000000,
    rank: 1,
    totalVolume: 40000000000.0,
    high24h: 91000.0,
    low24h: 89000.0,
    priceChangePercentage24h: 2.5,
    sparklinePoints: [89000.0, 90000.0],
  );

  setUp(() {
    mockGetCoinsUseCase = MockGetCoinsUseCase();
    mockSearchCoinsUseCase = MockSearchCoinsUseCase();
    when(() => mockGetCoinsUseCase(forceRefresh: any(named: 'forceRefresh'))).thenAnswer(
      (_) => const Stream.empty(),
    );
  });

  test('CryptoNotifier initial state has empty coins and isLoading false', () {
    final notifier = CryptoNotifier(
      getCoinsUseCase: mockGetCoinsUseCase,
      searchCoinsUseCase: mockSearchCoinsUseCase,
    );
    expect(notifier.state.coins, isEmpty);
    expect(notifier.state.isLoading, isFalse);
  });

  test('CryptoNotifier loads coins successfully', () async {
    when(() => mockGetCoinsUseCase(forceRefresh: false)).thenAnswer(
      (_) => Stream.fromIterable([
        const ResourceLoading<List<CoinEntity>>(),
        const ResourceSuccess<List<CoinEntity>>([sampleCoin]),
      ]),
    );

    final notifier = CryptoNotifier(
      getCoinsUseCase: mockGetCoinsUseCase,
      searchCoinsUseCase: mockSearchCoinsUseCase,
    );

    notifier.loadCoins(forceRefresh: false);
    await pumpEventQueue();

    expect(notifier.state.coins, equals([sampleCoin]));
    expect(notifier.state.isLoading, isFalse);
    expect(notifier.state.isOffline, isFalse);
  });
}
