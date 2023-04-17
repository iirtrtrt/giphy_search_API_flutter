import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:giphy_gif/gif/model/gif_model.dart';

class MockGifRepositoryProvider {
  final Dio _dio = Dio(
    BaseOptions(baseUrl: 'https://api.giphy.com/v1/gifs/'),
  );

  Future<List<GifModel>> gifSearch(String query, int offset) async {
    try {
      final response = await _dio.get(
        'search',
        queryParameters: {
          'api_key': '137qFZouSGMqNV23qb9LrFoY01RJyKO5',
          'q': query,
          'limit': 20,
          'offset': offset,
        },
      );
      final data = response.data['data'] as List<dynamic>;
      final gifs = data.map((json) => GifModel.fromJson(json)).toList();

      return gifs;
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

void main() {
  group('gif repository test', () {
    final MockGifRepositoryProvider mockGifRepositoryProvider =
        MockGifRepositoryProvider();

    test('gifSearch(query which must have gifs more than 20)', () async {
      final data = await mockGifRepositoryProvider.gifSearch('a', 0);

      expect(data, isA<List<GifModel>>());
      expect(data.length, 20);
    });
  });
}
