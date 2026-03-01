# Restaurant App

A Flutter application that displays a list of restaurants, their details, and customer reviews using the Dicoding Restaurant API. The app implements proper state management with Provider and includes both light and dark themes.

## Features

### Mandatory Requirements
✅ **Restaurant Listing Page** - Displays all restaurants with name, image, city, and rating
✅ **Restaurant Detail Page** - Shows complete restaurant information including menus and reviews
✅ **Custom Themes** - Light and dark themes with custom fonts (Poppins) and custom colors
✅ **Loading Indicators** - CircularProgressIndicator for API calls
✅ **State Management** - Provider library with sealed classes for API result handling

### Optional Features  
✅ **Search Functionality** - Search restaurants by name or keyword
✅ **Reviews Management** - View and add new reviews to restaurants
✅ **Hero Animation** - Smooth image transitions between pages
✅ **Error Handling** - User-friendly error messages with retry functionality
✅ **Theme Toggle** - Easy switching between light and dark modes

## Project Structure

```
lib/
├── main.dart                 # App entry point
├── models/
│   └── restaurant.dart      # Data models for restaurants and reviews
├── services/
│   └── restaurant_service.dart   # API service for HTTP requests
├── providers/
│   ├── api_result.dart      # Sealed class for API responses
│   ├── restaurant_provider.dart  # Restaurant state management
│   └── theme_provider.dart   # Theme state management
├── screens/
│   ├── home_page.dart       # Restaurant listing page
│   ├── detail_page.dart     # Restaurant detail page
│   └── search_page.dart     # Restaurant search page
├── widgets/
│   ├── restaurant_card.dart # Restaurant item widget
│   └── menu_item_card.dart  # Menu item widget
└── theme/
    └── app_theme.dart       # Theme definitions
```

## Dependencies

- **provider**: ^6.0.0 - State management
- **http**: ^1.1.0 - HTTP client for API requests
- **google_fonts**: ^6.1.0 - Custom fonts (Poppins)

## API Endpoints

The app uses the [Dicoding Restaurant API](https://restaurant-api.dicoding.dev):

- `GET /list` - Get all restaurants
- `GET /detail/{id}` - Get restaurant details
- `GET /search?q={query}` - Search restaurants
- `POST /review` - Add a review

## Getting Started

### Prerequisites
- Flutter SDK >= 3.10.1
- Dart SDK >= 3.10.1

### Installation

1. Navigate to the project directory:
   ```bash
   cd restaurant_app
   ```
2. Get dependencies:
   ```bash
   flutter pub get
   ```
3. Run the app:
   ```bash
   flutter run
   ```

## How to Use

### Home Page
- View all available restaurants
- Tap on a restaurant card to see details
- Use the search icon to find specific restaurants
- Toggle between light/dark themes using the theme button

### Detail Page
- View complete restaurant information
- See food and drink menus
- Read existing customer reviews
- Add a new review by clicking the "Add" button

### Search Page
- Type to search restaurants by name or keyword
- Results update in real-time
- Tap on any search result to view details

## Code Quality

✅ Clean code with proper naming conventions
✅ No unused imports
✅ Proper error handling and user feedback
✅ Comments on complex logic only
✅ Follows Flutter best practices

## Theme Customization

The app includes two complete themes:
- **Light Theme**: Green primary color (#2E7D32) with white backgrounds
- **Dark Theme**: Light green accent (#81C784) with dark backgrounds

Both themes use the Poppins font family for a modern look.

## Error Handling

The app gracefully handles:
- Network errors with informative messages
- Missing images with placeholder icons
- Empty search results
- Failed API requests with retry options

## Submission Checklist

- [x] Restaurant listing page with API data
- [x] Restaurant detail page with full information
- [x] Custom light and dark themes
- [x] Custom font type (Poppins)
- [x] Loading indicators for API calls
- [x] Provider state management with sealed classes
- [x] Clean code practices
- [x] Error messages and handling
- [x] Hero animations
- [x] Search functionality
- [x] Review management
