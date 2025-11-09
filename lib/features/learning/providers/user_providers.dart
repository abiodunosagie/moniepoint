// ============================================================================
// USER PROVIDERS - Riverpod Providers for User Feature
// ============================================================================
//
// PURPOSE: This file defines all providers for the user feature
//
// WHAT ARE PROVIDERS?
// Providers are like smart boxes that:
// 1. Hold values (state)
// 2. Know how to create those values
// 3. Notify widgets when values change
// 4. Provide dependency injection
//
// THINK OF IT LIKE THIS:
// - Provider = A vending machine
// - You put money in (call ref.watch)
// - You get what you need (data, services)
// - Everyone uses the same vending machine (shared instance)
//
// WHY USE PROVIDERS?
// 1. **Centralized State**: One place for all state management
// 2. **Dependency Injection**: Easy to inject dependencies
// 3. **Automatic Rebuilds**: Widgets update when state changes
// 4. **Easy Testing**: Mock providers easily
// 5. **Type Safe**: Compile-time errors, not runtime errors
//
// ============================================================================

// Import Riverpod package
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Import HTTP package for making requests
import 'package:http/http.dart' as http;

// Import our repository and models
import '../repositories/user_repository.dart';
import '../models/user_model.dart';

// ============================================================================
// LAYER 1: BASE DEPENDENCIES (No dependencies)
// ============================================================================

/// Provides an HTTP Client instance
///
/// WHY?
/// - We need an HTTP client to make API requests
/// - Instead of creating http.Client() everywhere, we create it once here
/// - All repositories can share this same client
///
/// DEPENDENCY INJECTION IN ACTION:
/// This provider creates the http.Client that gets injected into repositories
///
/// Example usage in another provider:
/// ```dart
/// final myProvider = Provider((ref) {
///   final client = ref.watch(httpClientProvider); // Get the HTTP client
///   return MyRepository(httpClient: client);      // Inject it
/// });
/// ```
///
/// TYPE: Provider (because httpClient never changes)
///
/// RETURNS: http.Client instance
final httpClientProvider = Provider<http.Client>((ref) {
  // Create and return a new HTTP client
  // This will be created ONCE and reused throughout the app
  return http.Client();

  // NOTE: In a real app, you might want to add:
  // - Timeout configuration
  // - Custom headers
  // - Logging interceptor
  // - Retry logic
  // But for learning, simple is better!
});

// ============================================================================
// LAYER 2: REPOSITORIES (Depend on Layer 1)
// ============================================================================

/// Provides a UserRepository instance
///
/// WHY?
/// - Repository handles all user-related API calls
/// - We inject httpClient into it (dependency injection!)
/// - All user-related providers can use this repository
///
/// DEPENDENCY CHAIN:
/// userRepositoryProvider → httpClientProvider
///
/// HOW IT WORKS:
/// 1. When someone calls ref.watch(userRepositoryProvider)
/// 2. This provider runs
/// 3. It calls ref.watch(httpClientProvider) to get the HTTP client
/// 4. It creates a UserRepository with that client
/// 5. It returns the repository
///
/// Example usage:
/// ```dart
/// class MyWidget extends ConsumerWidget {
///   Widget build(BuildContext context, WidgetRef ref) {
///     final repo = ref.watch(userRepositoryProvider);
///     // Now you can use repo.getUsers(), repo.getUser(id), etc.
///   }
/// }
/// ```
///
/// TYPE: Provider (because repository instance doesn't change)
///
/// RETURNS: UserRepository instance
final userRepositoryProvider = Provider<UserRepository>((ref) {
  // STEP 1: Get the HTTP client from another provider
  // This is DEPENDENCY INJECTION!
  // We don't create http.Client() here, we get it from httpClientProvider
  final httpClient = ref.watch(httpClientProvider);

  // STEP 2: Create UserRepository and inject the HTTP client
  // The repository will use this client for all API calls
  return UserRepository(httpClient: httpClient);

  // BEAUTIFUL DEPENDENCY INJECTION:
  // - UserRepository doesn't create its own httpClient
  // - We inject it from outside (from another provider)
  // - Easy to test: just inject a fake httpClient!
  // - Easy to configure: change httpClientProvider, everything updates!
});

// ============================================================================
// LAYER 3: DATA PROVIDERS (Depend on Layer 2)
// ============================================================================

/// Provides a list of all users from the API
///
/// WHY FutureProvider?
/// - Fetching users is ASYNC (takes time, requires await)
/// - FutureProvider is perfect for async operations
/// - It handles loading, error, and data states automatically!
///
/// DEPENDENCY CHAIN:
/// usersProvider → userRepositoryProvider → httpClientProvider
///
/// HOW IT WORKS:
/// 1. When a widget calls ref.watch(usersProvider)
/// 2. This provider runs
/// 3. It gets the repository from userRepositoryProvider
/// 4. It calls repository.getUsers() and waits (await)
/// 5. API responds with data
/// 6. Provider returns the list of users
/// 7. Widget rebuilds with the data!
///
/// THREE STATES:
/// - **Loading**: While waiting for API response
/// - **Error**: If API call fails
/// - **Data**: When we have the users
///
/// Example usage in UI:
/// ```dart
/// class UsersScreen extends ConsumerWidget {
///   Widget build(BuildContext context, WidgetRef ref) {
///     final usersAsync = ref.watch(usersProvider);
///
///     return usersAsync.when(
///       loading: () => CircularProgressIndicator(),
///       error: (error, stack) => Text('Error: $error'),
///       data: (users) => ListView.builder(
///         itemCount: users.length,
///         itemBuilder: (context, index) => Text(users[index].name),
///       ),
///     );
///   }
/// }
/// ```
///
/// TYPE: FutureProvider (because it's async and loads once)
///
/// RETURNS: AsyncValue<List<User>>
/// - AsyncValue has three states: loading, error, data
/// - Use .when() to handle all three states elegantly
final usersProvider = FutureProvider<List<User>>((ref) async {
  // STEP 1: Get the repository (dependency injection!)
  final repository = ref.watch(userRepositoryProvider);

  // STEP 2: Call the repository method to fetch users
  // This is async, so we await it
  // This might take 1-3 seconds (network request!)
  //
  // WHAT HAPPENS:
  // 1. HTTP GET request to https://jsonplaceholder.typicode.com/users
  // 2. Wait for response
  // 3. Parse JSON to List<User>
  // 4. Return the list
  final users = await repository.getUsers();

  // STEP 3: Return the users
  // FutureProvider will wrap this in AsyncValue<List<User>>
  return users;

  // ERROR HANDLING:
  // If repository.getUsers() throws an error:
  // 1. FutureProvider catches it automatically
  // 2. It sets the state to AsyncValue.error(error, stackTrace)
  // 3. UI can handle it with .when(error: ...)
  //
  // You don't need try-catch here! FutureProvider handles it!
});

// ============================================================================
// FAMILY PROVIDER - For Fetching Single User by ID
// ============================================================================

/// Provides a single user by ID
///
/// WHAT IS .family?
/// - Allows you to pass parameters to a provider
/// - Creates a separate provider instance for each parameter value
/// - Perfect for fetching individual items by ID
///
/// HOW IT WORKS:
/// ```dart
/// // This creates a provider for user ID 1
/// ref.watch(userProvider(1))
///
/// // This creates a DIFFERENT provider for user ID 2
/// ref.watch(userProvider(2))
///
/// // Both are cached separately!
/// ```
///
/// DEPENDENCY CHAIN:
/// userProvider(id) → userRepositoryProvider → httpClientProvider
///
/// Example usage:
/// ```dart
/// class UserDetailScreen extends ConsumerWidget {
///   final int userId;
///
///   UserDetailScreen({required this.userId});
///
///   Widget build(BuildContext context, WidgetRef ref) {
///     final userAsync = ref.watch(userProvider(userId));
///
///     return userAsync.when(
///       loading: () => CircularProgressIndicator(),
///       error: (e, s) => Text('Error: $e'),
///       data: (user) => Text('Name: ${user.name}'),
///     );
///   }
/// }
/// ```
///
/// TYPE: FutureProvider.family (async + parameterized)
///
/// PARAMETERS:
/// - ref: ProviderRef (reference to other providers)
/// - id: int (the user ID to fetch)
///
/// RETURNS: AsyncValue<User>
final userProvider = FutureProvider.family<User, int>((ref, id) async {
  // STEP 1: Get the repository
  final repository = ref.watch(userRepositoryProvider);

  // STEP 2: Fetch the user with the given ID
  // Example: if id is 5, this calls GET /users/5
  final user = await repository.getUser(id);

  // STEP 3: Return the user
  return user;
});

// ============================================================================
// PRACTICE PROVIDERS (For you to create!)
// ============================================================================

// TODO: Create a StateProvider for search query
// This should hold a String that users can type to search
//
// final searchQueryProvider = StateProvider<String>((ref) => '');

// TODO: Create a Provider that filters users by search query
// This should watch both usersProvider and searchQueryProvider
// And return only users whose name contains the search query
//
// final filteredUsersProvider = Provider<AsyncValue<List<User>>>((ref) {
//   final usersAsync = ref.watch(usersProvider);
//   final searchQuery = ref.watch(searchQueryProvider);
//
//   return usersAsync.whenData((users) {
//     if (searchQuery.isEmpty) return users;
//     return users.where((user) =>
//       user.name.toLowerCase().contains(searchQuery.toLowerCase())
//     ).toList();
//   });
// });

// ============================================================================
// SUMMARY - Key Takeaways
// ============================================================================
//
// PROVIDER TYPES USED:
// 1. **Provider**: For values that never change (httpClient, repository)
// 2. **FutureProvider**: For async data that loads once (users list)
// 3. **FutureProvider.family**: For async data with parameters (single user)
//
// DEPENDENCY INJECTION CHAIN:
// usersProvider
//     ↓ (depends on)
// userRepositoryProvider
//     ↓ (depends on)
// httpClientProvider
//
// WHEN WIDGETS REBUILD:
// - usersProvider: Never (unless you call ref.refresh)
// - userProvider(id): Never for same ID (cached)
//
// HOW TO USE IN WIDGETS:
// 1. Change StatelessWidget to ConsumerWidget
// 2. Add WidgetRef ref to build method
// 3. Call ref.watch(providerName)
// 4. Use .when() for FutureProvider to handle loading/error/data
//
// NEXT STEPS:
// - Look at the UI files to see how to use these providers
// - Try creating your own providers for posts
// - Complete the practice tasks in PROGRESSIVE_LEARNING_TASKS.md
//
// ============================================================================
