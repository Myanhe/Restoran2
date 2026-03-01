import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/restaurant_provider.dart';
import '../providers/api_result.dart';
import '../widgets/restaurant_card.dart';
import '../utils/error_formatter.dart';
import 'detail_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search Restaurants')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name or city...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onChanged: (value) {
                context.read<RestaurantProvider>().searchRestaurants(value);
              },
            ),
          ),
          Expanded(
            child: Consumer<RestaurantProvider>(
              builder: (context, provider, child) {
                return provider.searchResult.maybeWhen(
                  loading: () {
                    if (_searchController.text.isEmpty) {
                      return Center(
                        child: Text(
                          'Start typing to search',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      );
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                  success: (response) {
                    if (response.restaurants.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.search_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No restaurants found',
                              style: Theme.of(context).textTheme.bodyLarge,
                            ),
                          ],
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: response.restaurants.length,
                      itemBuilder: (context, index) {
                        final restaurant = response.restaurants[index];
                        return RestaurantCard(
                          restaurant: restaurant,
                          provider: provider,
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailPage(restaurantId: restaurant.id),
                              ),
                            );
                          },
                        );
                      },
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
                          'Gagal Mencari Restoran',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        const SizedBox(height: 8),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 32),
                          child: Text(
                            getUserFriendlyErrorMessage(message),
                            style: Theme.of(context).textTheme.bodyMedium,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                  orElse: () => const SizedBox.shrink(),
                );
              },
            ),
          ),
        ],
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
