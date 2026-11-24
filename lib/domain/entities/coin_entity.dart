import 'package:equatable/equatable.dart';

class CoinEntity extends Equatable {
  final String id;
  final String symbol;
  final String name;
  final String imageUrl;
  final double currentPrice;
  final int marketCap;
  final int rank;
  final double totalVolume;
  final double high24h;
  final double low24h;
  final double priceChangePercentage24h;
  final List<double> sparklinePoints;

  const CoinEntity({
    required this.id,
    required this.symbol,
    required this.name,
    required this.imageUrl,
    required this.currentPrice,
    required this.marketCap,
    required this.rank,
    required this.totalVolume,
    required this.high24h,
    required this.low24h,
    required this.priceChangePercentage24h,
    required this.sparklinePoints,
  });

  bool get isPositiveChange => priceChangePercentage24h >= 0;

  @override
  List<Object?> get props => [
        id,
        symbol,
        name,
        imageUrl,
        currentPrice,
        marketCap,
        rank,
        totalVolume,
        high24h,
        low24h,
        priceChangePercentage24h,
        sparklinePoints,
      ];
}
