# Mika Care - AI Coding Agent Instructions

## Project Overview
Mika Care is a Flutter mobile application for managing service operations including job cards, deliveries, aftersales, and spare parts. Built for Android and iOS with Firebase push notifications.

## Architecture Patterns

### Directory Structure
- `lib/screens/` - Feature-based screen organization (jobcards, deliveries, aftersales, requests)
- `lib/modals/` - Data models (not "models" - note the project uses "modals")
- `lib/services/` - API services with master configuration
- `lib/providers/` - State management using Provider pattern
- `lib/components/` - Reusable widgets and routing
- `lib/constants/` - App-wide constants (colors, styles)

### Data Flow Architecture
1. **API Communication**: All API calls inherit from `ApiMaster` class
   - Base URL: `mika-care.mikaappliances.com`
   - Namespace: `/mobile`
   - Example: [lib/services/api_services.dart](lib/services/api_services.dart)
   - Returns `Map<String, dynamic>` with standardized `status` and `message` keys

2. **State Management**: Provider pattern via `UserProvider`
   - Handles authentication state, user roles, and permissions
   - Access via `Provider.of<UserProvider>(context)`
   - Example: [lib/providers/user_provider.dart](lib/providers/user_provider.dart)

3. **Navigation**: Centralized routing in `RouteGenerator`
   - All routes defined in [lib/components/route_generator.dart](lib/components/route_generator.dart)
   - Pass arguments as `Map` or direct objects (see `/otp` and `/delivery_details` routes)

### Data Models Convention
- Located in `lib/modals/` (not "models")
- Each modal includes:
  - `fromJson` factory constructor
  - `toJson` method for serialization
  - Standalone parsing functions (e.g., `userFromJson`, `userToJson`)
- Example structure: [lib/modals/jobcard_diagnosed_faults_modal.dart](lib/modals/jobcard_diagnosed_faults_modal.dart)

### Firebase Integration
- Initialization in [lib/firebase_notification_modal.dart](lib/firebase_notification_modal.dart)
- Android uses explicit FirebaseOptions, iOS uses default initialization
- Background message handler required
- Token stored via `submitFPMToken` API call

## Key Conventions

### Role-Based Access Control
The app implements RBAC through `UserProvider`:
```dart
userProvider.hasPermission('permission_name')
userProvider.hasRoleName('role_name')
```

### Bottom Navigation
- Dynamic navigation items based on user permissions
- Defined in [lib/components/bottom_navigator.dart](lib/components/bottom_navigator.dart)
- Pass `currentIndex` to highlight active tab

### Reusable UI Components
- `DynamicMaster` class provides shared widgets:
  - `displayError()` - Error dialogs with Lottie animations
  - `displaySuccessModal()` - Success feedback
  - Located in [lib/components/dynamic_widgets.dart](lib/components/dynamic_widgets.dart)

### Color Scheme
Constants defined in [lib/constants/main_constants.dart](lib/constants/main_constants.dart):
- `kPrimaryColor` - Black (#000000)
- `kSecondaryColor` - Purple (#6F35A5)
- `kRedColor`, `kBlueColor` for status indicators

## Common Workflows

### Adding a New Screen
1. Create screen in appropriate `lib/screens/[feature]/` directory
2. Add route in `RouteGenerator.generateRoute()`
3. If requires auth, check `UserProvider.isLoggedIn()`
4. Add navigation item to `BottomNavigator` if main feature

### API Integration Pattern
```dart
ApiService().methodName(params).then((response) {
  if (response["status"] == "success") {
    // Handle success - data in response["data_obj"] or response["message"]
  } else {
    // Handle error - message in response["message"]
  }
});
```

### Creating Data Models
1. Place in `lib/modals/` directory
2. Include `fromJson` and `toJson` methods
3. Add top-level parsing functions for convenience
4. Handle nested objects with their own `fromJson`/`toJson`

## Build & Run

### Dependencies
- Flutter SDK: ^3.10.0
- Key packages: `provider`, `firebase_messaging`, `firebase_core`, `http`, `flutter_local_notifications`

### Commands
- `flutter pub get` - Install dependencies
- `flutter run` - Run in debug mode
- `flutter build apk` - Build Android APK
- `flutter build ios` - Build iOS (requires macOS)

### Asset Management
Assets configured in pubspec.yaml:
- Images: `assets/images/`
- Icons: `assets/icons/`
- Animations: `assets/animations/` (Lottie JSON files)

## Testing & Debugging
- Firebase messaging logs to console with `print()` statements
- Toast messages via `Fluttertoast.showToast()` for user feedback
- Error handling through `DynamicMaster.displayError()`

## Important Notes
- Always use `// ignore_for_file:` directives conservatively (already present in many files)
- The project uses "modals" not "models" - maintain this naming convention
- All API responses follow `{status, message, data_obj}` structure
- User authentication requires OTP verification after login
