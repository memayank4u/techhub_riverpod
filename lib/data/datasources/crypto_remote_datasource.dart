import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../models/coin_model.dart';

abstract class CryptoRemoteDataSource {
  Future<List<CoinModel>> fetchCoins();
}

class CryptoRemoteDataSourceImpl implements CryptoRemoteDataSource {
  final DioClient dioClient;

  CryptoRemoteDataSourceImpl(this.dioClient);

  static const String endpoint =
      'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&order=market_cap_desc&per_page=50&page=1&sparkline=true';

  @override
  Future<List<CoinModel>> fetchCoins() async {
    try {
      final response = await dioClient.get(endpoint);

      if (response.statusCode == 200) {
        final dynamic rawData = response.data;
        final List<dynamic> list = rawData is List ? rawData : [];
        return list.map((item) => CoinModel.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Server error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network error connecting to CoinGecko');
    }
  }
}
