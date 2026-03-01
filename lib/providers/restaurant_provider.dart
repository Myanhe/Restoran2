import 'package:flutter/foundation.dart';
import '../models/restaurant.dart';
import '../services/restaurant_service.dart';
import 'api_result.dart';

class RestaurantProvider extends ChangeNotifier {
  final RestaurantService _service;

  RestaurantProvider({RestaurantService? service})
    : _service = service ?? RestaurantService();

  ApiResult<RestaurantListResponse> _restaurantListResult = const ApiLoading();
  ApiResult<RestaurantDetailResponse> _restaurantDetailResult =
      const ApiLoading();
  ApiResult<RestaurantListResponse> _searchResult = const ApiLoading();
  ApiResult<void> _addReviewResult = const ApiLoading();

  ApiResult<RestaurantListResponse> get restaurantListResult =>
      _restaurantListResult;
  ApiResult<RestaurantDetailResponse> get restaurantDetailResult =>
      _restaurantDetailResult;
  ApiResult<RestaurantListResponse> get searchResult => _searchResult;
  ApiResult<void> get addReviewResult => _addReviewResult;

  Future<void> getAllRestaurants() async {
    _restaurantListResult = const ApiLoading();
    notifyListeners();

    try {
      final response = await _service.getAllRestaurants();
      _restaurantListResult = ApiSuccess(response);
    } catch (e) {
      _restaurantListResult = ApiError(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
    notifyListeners();
  }

  Future<void> getRestaurantDetail(String id) async {
    _restaurantDetailResult = const ApiLoading();
    notifyListeners();

    try {
      final response = await _service.getRestaurantDetail(id);
      _restaurantDetailResult = ApiSuccess(response);
    } catch (e) {
      _restaurantDetailResult = ApiError(
        e.toString().replaceFirst('Exception: ', ''),
      );
    }
    notifyListeners();
  }

  Future<void> searchRestaurants(String query) async {
    if (query.isEmpty) {
      _searchResult = const ApiLoading();
      notifyListeners();
      return;
    }

    _searchResult = const ApiLoading();
    notifyListeners();

    try {
      final response = await _service.searchRestaurants(query);
      _searchResult = ApiSuccess(response);
    } catch (e) {
      _searchResult = ApiError(e.toString().replaceFirst('Exception: ', ''));
    }
    notifyListeners();
  }

  Future<void> addReview({
    required String restaurantId,
    required String name,
    required String review,
  }) async {
    _addReviewResult = const ApiLoading();
    notifyListeners();

    try {
      await _service.addReview(
        restaurantId: restaurantId,
        name: name,
        review: review,
      );
      _addReviewResult = const ApiSuccess(null);
    } catch (e) {
      _addReviewResult = ApiError(e.toString().replaceFirst('Exception: ', ''));
    }
    notifyListeners();
  }

  String getRestaurantImageUrl(String pictureId, {String size = 'medium'}) {
    return _service.getRestaurantImageUrl(pictureId, size: size);
  }

  void resetAddReviewResult() {
    _addReviewResult = const ApiLoading();
    notifyListeners();
  }
}
