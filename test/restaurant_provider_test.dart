import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/providers/restaurant_provider.dart';
import 'package:restaurant_app/services/restaurant_service.dart';
import 'package:restaurant_app/models/restaurant.dart';
import 'package:restaurant_app/providers/api_result.dart';

class MockRestaurantService extends Mock implements RestaurantService {}

void main() {
  group('RestaurantProvider', () {
    late RestaurantProvider provider;
    late MockRestaurantService mockService;

    setUp(() {
      mockService = MockRestaurantService();
      provider = RestaurantProvider(service: mockService);
    });

    test('Initial state should be ApiLoading', () {
      expect(provider.restaurantListResult, isA<ApiLoading>());
    });

    test('Should return restaurant list when API call succeeds', () async {
      final mockResponse = RestaurantListResponse(
        error: false,
        message: 'Success',
        count: 2,
        restaurants: [
          Restaurant(
            id: '1',
            name: 'Restaurant 1',
            description: 'Desc 1',
            pictureId: 'pic1',
            city: 'City 1',
            rating: 4.5,
          ),
          Restaurant(
            id: '2',
            name: 'Restaurant 2',
            description: 'Desc 2',
            pictureId: 'pic2',
            city: 'City 2',
            rating: 4.0,
          ),
        ],
      );

      when(mockService.getAllRestaurants()).thenAnswer((_) async => mockResponse);

      await provider.getAllRestaurants();

      expect(provider.restaurantListResult, isA<ApiSuccess>());
      final result = provider.restaurantListResult as ApiSuccess;
      expect(result.data.restaurants.length, 2);
      expect(result.data.restaurants[0].name, 'Restaurant 1');
    });

    test('Should return error when API call fails', () async {
      when(mockService.getAllRestaurants()).thenThrow(Exception('Network error'));

      await provider.getAllRestaurants();

      expect(provider.restaurantListResult, isA<ApiError>());
      final result = provider.restaurantListResult as ApiError;
      expect(result.message, contains('Network error'));
    });
  });
}
