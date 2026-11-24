import 'package:equatable/equatable.dart';
import '../../../domain/entities/coin_entity.dart';

class CryptoState extends Equatable {
  final List<CoinEntity> coins;
  final List<CoinEntity> filteredCoins;
  final bool isLoading;
  final bool isRefreshing;
  final bool isOffline;
  final String? errorMessage;
  final String searchQuery;

  const CryptoState({
    this.coins = const [],
    this.filteredCoins = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.isOffline = false,
    this.errorMessage,
    this.searchQuery = '',
  });

  List<CoinEntity> get displayList =>
      searchQuery.trim().isEmpty ? coins : filteredCoins;

  CryptoState copyWith({
    List<CoinEntity>? coins,
    List<CoinEntity>? filteredCoins,
    bool? isLoading,
    bool? isRefreshing,
    bool? isOffline,
    String? errorMessage,
    String? searchQuery,
  }) {
    return CryptoState(
      coins: coins ?? this.coins,
      filteredCoins: filteredCoins ?? this.filteredCoins,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isOffline: isOffline ?? this.isOffline,
      errorMessage: errorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
        coins,
        filteredCoins,
        isLoading,
        isRefreshing,
        isOffline,
        errorMessage,
        searchQuery,
      ];
}
