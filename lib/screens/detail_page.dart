import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';
import '../providers/favorite_provider.dart';
import '../providers/api_result.dart';
import '../models/restaurant.dart';
import '../widgets/menu_item_card.dart';

class DetailPage extends StatefulWidget {
  final String restaurantId;

  const DetailPage({
    super.key,
    required this.restaurantId,
  });

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  late TextEditingController _nameController;
  late TextEditingController _reviewController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _reviewController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<RestaurantProvider>().getRestaurantDetail(widget.restaurantId);
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _reviewController.dispose();
    super.dispose();
  }

  void _showAddReviewDialog() {
    _nameController.clear();
    _reviewController.clear();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Review'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  hintText: 'Your name',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _reviewController,
                decoration: const InputDecoration(
                  hintText: 'Your review',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final name = _nameController.text.trim();
              final review = _reviewController.text.trim();
              if (name.isNotEmpty && review.isNotEmpty) {
                context.read<RestaurantProvider>().addReview(
                  restaurantId: widget.restaurantId,
                  name: name,
                  review: review,
                );
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Review added successfully')),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please fill all fields')),
                );
              }
            },
            child: const Text('Submit'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Restaurant Detail'),
        actions: [
          Consumer<FavoriteProvider>(
            builder: (context, fav, _) {
              return FutureBuilder<bool>(
                future: fav.isFavorite(widget.restaurantId),
                builder: (context, snapshot) {
                  final isFav = snapshot.data ?? false;
                  return IconButton(
                    icon: Icon(isFav ? Icons.favorite : Icons.favorite_border),
                    color: isFav ? Colors.red : null,
                    onPressed: () {
                      if (isFav) {
                        fav.removeFavorite(widget.restaurantId);
                      } else {
                        context.read<RestaurantProvider>().restaurantDetailResult.maybeWhen(
                          success: (detail) {
                            final rest = detail.restaurant;
                            final restaurant = Restaurant(
                              id: rest.id,
                              name: rest.name,
                              description: rest.description,
                              pictureId: rest.pictureId,
                              city: rest.city,
                              rating: rest.rating,
                            );
                            fav.addFavorite(restaurant);
                          },
                          loading: () {},
                          error: (_) {},
                          orElse: () {},
                        );
                      }
                    },
                  );
                },
              );
            },
          ),
        ],
      ),
      body: Consumer<RestaurantProvider>(
        builder: (context, provider, child) {
          return provider.restaurantDetailResult.maybeWhen(
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            success: (response) {
              final restaurant = response.restaurant;
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: 'restaurant-${restaurant.id}',
                      child: Image.network(
                        provider.getRestaurantImageUrl(
                          restaurant.pictureId,
                          size: 'large',
                        ),
                        height: 250,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 250,
                            color: Colors.grey[300],
                            child: const Icon(Icons.image_not_supported),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  restaurant.name,
                                  style: Theme.of(context).textTheme.headlineLarge,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              Column(
                                children: [
                                  const Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                    size: 20,
                                  ),
                                  Text(
                                    restaurant.rating.toStringAsFixed(1),
                                    style: Theme.of(context).textTheme.bodyMedium,
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                restaurant.city,
                                style: Theme.of(context).textTheme.bodyMedium,
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Address',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            restaurant.address,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Description',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            restaurant.description,
                            style: Theme.of(context).textTheme.bodyMedium,
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'Foods',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: restaurant.menus.foods.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: 150,
                                  child: MenuItemCard(
                                    menuItem: restaurant.menus.foods[index],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Drinks',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 120,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: restaurant.menus.drinks.length,
                              itemBuilder: (context, index) {
                                return SizedBox(
                                  width: 150,
                                  child: MenuItemCard(
                                    menuItem: restaurant.menus.drinks[index],
                                  ),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Reviews',
                                style: Theme.of(context).textTheme.headlineSmall,
                              ),
                              ElevatedButton.icon(
                                onPressed: _showAddReviewDialog,
                                icon: const Icon(Icons.add),
                                label: const Text('Add'),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          if (restaurant.customerReviews.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              child: Center(
                                child: Text(
                                  'No reviews yet',
                                  style: Theme.of(context).textTheme.bodyMedium,
                                ),
                              ),
                            )
                          else
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: restaurant.customerReviews.length,
                              itemBuilder: (context, index) {
                                final review = restaurant.customerReviews[index];
                                return Card(
                                  margin: const EdgeInsets.only(bottom: 8),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              review.name,
                                              style: Theme.of(context)
                                                .textTheme
                                                .bodyLarge
                                                ?.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                            ),
                                            Text(
                                              review.date,
                                              style: Theme.of(context)
                                                .textTheme
                                                .labelSmall,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          review.review,
                                          style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
            error: (message) => Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Colors.red[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Error loading restaurant',
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    message,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () =>
                      context.read<RestaurantProvider>().getRestaurantDetail(
                        widget.restaurantId,
                      ),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
            orElse: () => const SizedBox.shrink(),
          );
        },
      ),
    );
  }
}

extension<T> on ApiResult<T> {
  R maybeWhen<R>({
    required R Function() loading,
    required R Function(T) success,
    required R Function(String) error,
    required R Function() orElse,
  }) {
    if (this is ApiLoading<T>) {
      return loading();
    } else if (this is ApiSuccess<T>) {
      return success((this as ApiSuccess<T>).data);
    } else if (this is ApiError<T>) {
      return error((this as ApiError<T>).message);
    }
    return orElse();
  }
}
