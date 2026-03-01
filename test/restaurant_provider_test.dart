import 'package:flutter_test/flutter_test.dart';
import 'package:restaurant_app/providers/restaurant_provider.dart';
import 'package:restaurant_app/services/restaurant_service.dart';
import 'package:restaurant_app/models/restaurant.dart';
import 'package:restaurant_app/providers/api_result.dart';

// Simple mock implementation for testing
class MockRestaurantService implements RestaurantService {
  List<Restaurant>? _mockRestaurants;
  Exception? _exception;
  bool _shouldThrow = false;

  void setMockRestaurants(List<Restaurant> restaurants) {
    _mockRestaurants = restaurants;
    _shouldThrow = false;
  }

  void setException(Exception exception) {
    _exception = exception;
    _shouldThrow = true;
  }

  @override
  Future<RestaurantListResponse> getAllRestaurants() async {
    if (_shouldThrow) {
      throw _exception ?? Exception('Unexpected error');
    }
    
    return RestaurantListResponse(
      error: false,
      message: 'Success',
      count: _mockRestaurants?.length ?? 0,
      restaurants: _mockRestaurants ?? [],
    );
  }

  @override
  Future<RestaurantDetailResponse> getRestaurantDetail(String id) async {
    throw UnimplementedError();
  }

  @override
  Future<RestaurantListResponse> searchRestaurants(String query) async {
    throw UnimplementedError();
  }

  @override
  Future<void> addReview({
    required String restaurantId,
    required String name,
    required String review,
  }) async {
    // Mock implementation - do nothing
  }

  @override
  String getRestaurantImageUrl(String pictureId, {String size = 'medium'}) {
    return 'https://restaurant-api.dicoding.dev/images/$size/$pictureId';
  }
}

void main() {
  group('RestaurantProvider Tests', () {
    late RestaurantProvider provider;
    late MockRestaurantService mockRestaurantService;

    setUp(() {
      mockRestaurantService = MockRestaurantService();
      provider = RestaurantProvider(service: mockRestaurantService);
    });

    group('getAllRestaurants', () {
      test('Initial state should be ApiLoading', () {
        // Assert
        expect(provider.restaurantListResult, isA<ApiLoading>());
      });

      test('Should return ApiSuccess when getAllRestaurants succeeds', () async {
        // Arrange
        final mockRestaurants = [
          Restaurant(
            id: '1',
            name: 'Mie Ayam Pak Kumis',
            description: 'Mie ayam terbaik di kota',
            pictureId: 'pic1',
            city: 'Solo',
            rating: 4.5,
          ),
          Restaurant(
            id: '2',
            name: 'Soto Ayam Mak Ning',
            description: 'Soto ayam gurih dan nikmat',
            pictureId: 'pic2',
            city: 'Jakarta',
            rating: 4.0,
          ),
        ];
        mockRestaurantService.setMockRestaurants(mockRestaurants);

        // Act
        await provider.getAllRestaurants();

        // Assert
        expect(provider.restaurantListResult, isA<ApiSuccess>());
        final result = provider.restaurantListResult as ApiSuccess;
        expect(result.data.restaurants.length, equals(2));
        expect(result.data.restaurants[0].name, equals('Mie Ayam Pak Kumis'));
        expect(result.data.restaurants[1].city, equals('Jakarta'));
      });

      test('Should return ApiError when getAllRestaurants fails', () async {
        // Arrange
        const errorMessage = 'Connection timeout';
        mockRestaurantService.setException(Exception(errorMessage));

        // Act
        await provider.getAllRestaurants();

        // Assert
        expect(provider.restaurantListResult, isA<ApiError>());
        final result = provider.restaurantListResult as ApiError;
        expect(result.message, contains(errorMessage));
      });
    });
  });
}
