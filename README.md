# Cook That Thing 🍳

### Visit [This Link](https://drive.google.com/drive/folders/11sJTFwHTTki_BoMdnOgbCuqmDSnV7dv8?usp=sharing) to see how the app runs on a device

A modern Flutter recipe sharing and social cooking platform that connects food enthusiasts and chefs.

## Features

### For Users
- Browse and search recipes
- Follow favorite chefs
- Create and share your own recipes
- Save favorites for quick access
- Review and rate recipes 
- View detailed instructions and ingredients
- Browse recipes by categories
- Profile management with recipe gallery
- Social authentication (Google Sign-in)

### For Chefs
- Dedicated chef profiles
- Recipe management
- Follower tracking
- Recipe analytics

## Technical Architecture

The app follows Clean Architecture principles with three main layers:

### Domain Layer
- Core business logic and entities
- Use cases defining app behavior
- Repository interfaces

### Data Layer
- Repository implementations
- Remote database interactions (Firebase)
- Local data persistence

### Presentation Layer
- BLoC pattern for state management
- Responsive UI components
- Clean separation of widgets and pages

## Core Modules

- **Authentication**: User management and social auth
- **Recipes**: Creation, viewing, and management
- **Chef**: Profile and following system
- **Reviews**: Rating and feedback system
- **Categories**: Recipe organization
- **Profile**: User profiles and galleries

## Getting Started

### Prerequisites
- Flutter SDK
- Firebase account
- iOS/Android development setup

### Installation
1. Clone the repository
2. Run `flutter pub get`
3. Configure Firebase:
   - Add `google-services.json` for Android
   - Add `GoogleService-Info.plist` for iOS
4. Run `flutter run`

## Project Structure
```
lib/
├── core/          # Core features (recipes, chefs, reviews)
├── shared/        # Shared utilities and widgets
└── src/           # Feature modules
    ├── authentication/
    ├── category/
    ├── favorite/
    ├── home/
    ├── onboarding/
    └── profile/
```

## Dependencies
- Firebase (Authentication, Firestore)
- Flutter BLoC
- Freezed for code generation
- Network connectivity handling
- Image handling and caching

## Contributing
[Add contribution guidelines]

## License
[Add license information]