import 'package:flutter/foundation.dart';
import '../models/restaurant.dart';
import '../db/database_helper.dart';

class FavoriteProvider extends ChangeNotifier {
  final DatabaseHelper _db = DatabaseHelper.instance;

  List<Restaurant> _favorites = [];

  List<Restaurant> get favorites => _favorites;

  Future<void> loadFavorites() async {
    _favorites = await _db.getFavorites();
    notifyListeners();
  }

  Future<void> addFavorite(Restaurant r) async {
    await _db.insertFavorite(r);
    await loadFavorites();
  }

  Future<void> removeFavorite(String id) async {
    await _db.removeFavorite(id);
    await loadFavorites();
  }

  Future<bool> isFavorite(String id) async {
    return _db.isFavorite(id);
  }
}
