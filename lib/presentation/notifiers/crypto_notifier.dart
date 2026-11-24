import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/common/resource.dart';
import '../../domain/usecases/get_coins_usecase.dart';
import '../../domain/usecases/search_coins_usecase.dart';
import '../../core/di/providers.dart';
import 'crypto_state.dart';

class CryptoNotifier extends StateNotifier<CryptoState> {
  final GetCoinsUseCase _getCoinsUseCase;
  final SearchCoinsUseCase _searchCoinsUseCase;
  StreamSubscription? _subscription;

  CryptoNotifier({
    required GetCoinsUseCase getCoinsUseCase,
    required SearchCoinsUseCase searchCoinsUseCase,
  })  : _getCoinsUseCase = getCoinsUseCase,
        _searchCoinsUseCase = searchCoinsUseCase,
        super(const CryptoState()) {
    loadCoins();
  }

  void loadCoins({bool forceRefresh = false}) {
    _subscription?.cancel();
    _subscription = _getCoinsUseCase(forceRefresh: forceRefresh).listen(
      (resource) {
        if (resource is ResourceLoading) {
          state = state.copyWith(
            isLoading: state.coins.isEmpty,
            isRefreshing: forceRefresh,
            coins: resource.data ?? state.coins,
            errorMessage: null,
          );
        } else if (resource is ResourceSuccess) {
          state = state.copyWith(
            isLoading: false,
            isRefreshing: false,
            isOffline: false,
            coins: resource.data ?? [],
            errorMessage: null,
          );
        } else if (resource is ResourceError) {
          state = state.copyWith(
            isLoading: false,
            isRefreshing: false,
            isOffline: true,
            coins: resource.data ?? state.coins,
            errorMessage: resource.message,
          );
        }
      },
    );
  }

  void searchCoins(String query) {
    if (query.trim().isEmpty) {
      state = state.copyWith(searchQuery: '', filteredCoins: []);
    } else {
      final results = _searchCoinsUseCase(query);
      state = state.copyWith(searchQuery: query, filteredCoins: results);
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final cryptoNotifierProvider =
    StateNotifierProvider<CryptoNotifier, CryptoState>((ref) {
  return CryptoNotifier(
    getCoinsUseCase: ref.watch(getCoinsUseCaseProvider),
    searchCoinsUseCase: ref.watch(searchCoinsUseCaseProvider),
  );
});
