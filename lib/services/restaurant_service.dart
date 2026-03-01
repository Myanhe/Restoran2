import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/restaurant.dart';

class RestaurantService {
  static const String baseUrl = 'https://restaurant-api.dicoding.dev';
  static const String smallImageUrl = '$baseUrl/images/small';
  static const String mediumImageUrl = '$baseUrl/images/medium';
  static const String largeImageUrl = '$baseUrl/images/large';

  Future<RestaurantListResponse> getAllRestaurants() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/list'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return RestaurantListResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      } else {
        throw Exception('Failed to load restaurants');
      }
    } catch (e) {
      throw Exception('Failed to load restaurants: $e');
    }
  }

  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/detail/$id'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return RestaurantDetailResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      } else {
        throw Exception('Failed to load restaurant detail');
      }
    } catch (e) {
      throw Exception('Failed to load restaurant detail: $e');
    }
  }

  Future<RestaurantListResponse> searchRestaurants(String query) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/search?q=$query'),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return RestaurantListResponse.fromJson(
          jsonDecode(response.body) as Map<String, dynamic>,
        );
      } else {
        throw Exception('Failed to search restaurants');
      }
    } catch (e) {
      throw Exception('Failed to search restaurants: $e');
    }
  }

  Future<void> addReview({
    required String restaurantId,
    required String name,
    required String review,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/review'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'id': restaurantId,
          'name': name,
          'review': review,
        }),
      ).timeout(const Duration(seconds: 10));

      if (response.statusCode != 201) {
        throw Exception('Failed to add review');
      }
    } catch (e) {
      throw Exception('Failed to add review: $e');
    }
  }

  String getRestaurantImageUrl(String pictureId, {String size = 'medium'}) {
    switch (size) {
      case 'small':
        return '$smallImageUrl/$pictureId';
      case 'large':
        return '$largeImageUrl/$pictureId';
      case 'medium':
      default:
        return '$mediumImageUrl/$pictureId';
    }
  }
}
