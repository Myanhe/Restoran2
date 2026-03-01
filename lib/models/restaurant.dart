class RestaurantListResponse {
  final bool error;
  final String message;
  final int count;
  final List<Restaurant> restaurants;

  RestaurantListResponse({
    required this.error,
    required this.message,
    required this.count,
    required this.restaurants,
  });

  factory RestaurantListResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantListResponse(
      error: json['error'] ?? false,
      message: json['message'] ?? '',
      count: json['count'] ?? 0,
      restaurants: List<Restaurant>.from(
        (json['restaurants'] as List?)?.map(
          (x) => Restaurant.fromJson(x as Map<String, dynamic>),
        ) ??
            [],
      ),
    );
  }
}

class RestaurantDetailResponse {
  final bool error;
  final String message;
  final RestaurantDetail restaurant;

  RestaurantDetailResponse({
    required this.error,
    required this.message,
    required this.restaurant,
  });

  factory RestaurantDetailResponse.fromJson(Map<String, dynamic> json) {
    return RestaurantDetailResponse(
      error: json['error'] ?? false,
      message: json['message'] ?? '',
      restaurant: RestaurantDetail.fromJson(
        json['restaurant'] as Map<String, dynamic>,
      ),
    );
  }
}

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      pictureId: json['pictureId'] ?? '',
      city: json['city'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

class RestaurantDetail {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final String address;
  final double rating;
  final Menus menus;
  final List<Review> customerReviews;

  RestaurantDetail({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.address,
    required this.rating,
    required this.menus,
    required this.customerReviews,
  });

  factory RestaurantDetail.fromJson(Map<String, dynamic> json) {
    return RestaurantDetail(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      pictureId: json['pictureId'] ?? '',
      city: json['city'] ?? '',
      address: json['address'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      menus: Menus.fromJson(json['menus'] as Map<String, dynamic>? ?? {}),
      customerReviews: List<Review>.from(
        (json['customerReviews'] as List?)?.map(
          (x) => Review.fromJson(x as Map<String, dynamic>),
        ) ??
            [],
      ),
    );
  }
}

class Menus {
  final List<MenuItem> foods;
  final List<MenuItem> drinks;

  Menus({
    required this.foods,
    required this.drinks,
  });

  factory Menus.fromJson(Map<String, dynamic> json) {
    return Menus(
      foods: List<MenuItem>.from(
        (json['foods'] as List?)?.map(
          (x) => MenuItem.fromJson(x as Map<String, dynamic>),
        ) ??
            [],
      ),
      drinks: List<MenuItem>.from(
        (json['drinks'] as List?)?.map(
          (x) => MenuItem.fromJson(x as Map<String, dynamic>),
        ) ??
            [],
      ),
    );
  }

  List<MenuItem> toList() {
    return [...foods, ...drinks];
  }
}

class MenuItem {
  final String name;

  MenuItem({required this.name});

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      name: json['name'] ?? '',
    );
  }
}

class Review {
  final String name;
  final String review;
  final String date;

  Review({
    required this.name,
    required this.review,
    required this.date,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      name: json['name'] ?? '',
      review: json['review'] ?? '',
      date: json['date'] ?? '',
    );
  }
}
