// ============================================================================
// USERS LIST SCREEN - Display List of Users from API
// ============================================================================
//
// PURPOSE: This screen demonstrates how to:
// 1. Use Riverpod providers in UI
// 2. Handle loading, error, and data states
// 3. Display API data in a list
// 4. Implement pull-to-refresh
// 5. Navigate to detail screen
//
// THIS IS THE COMPLETE PATTERN YOU'LL USE EVERYWHERE!
// Study this file carefully - it shows the correct way to build screens
// that fetch and display API data.
//
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; // Import Riverpod
import '../providers/user_providers.dart'; // Import our providers
import 'user_detail_screen.dart'; // Import detail screen

// ============================================================================
// MAIN WIDGET
// ============================================================================

/// Screen that displays a list of users from the API
///
/// IMPORTANT: We extend ConsumerWidget, NOT StatelessWidget!
///
/// WHY ConsumerWidget?
/// - ConsumerWidget gives us access to WidgetRef (ref parameter)
/// - ref lets us read providers
/// - Without ConsumerWidget, we can't use Riverpod!
///
/// BEFORE (StatelessWidget):
/// ```dart
/// class MyScreen extends StatelessWidget {
///   Widget build(BuildContext context) {
///     // Can't access providers here!
///   }
/// }
/// ```
///
/// AFTER (ConsumerWidget):
/// ```dart
/// class MyScreen extends ConsumerWidget {
///   Widget build(BuildContext context, WidgetRef ref) {
///     final data = ref.watch(myProvider); // Can access providers!
///   }
/// }
/// ```
class UsersListScreen extends ConsumerWidget {
  const UsersListScreen({Key? key}) : super(key: key);

  // ============================================================================
  // BUILD METHOD - Creates the UI
  // ============================================================================

  /// Builds the widget tree for this screen
  ///
  /// Parameters:
  /// - [context]: BuildContext (same as always)
  /// - [ref]: WidgetRef (NEW! This lets us access providers)
  ///
  /// NOTICE: We have TWO parameters now, not just context!
  /// This is the main difference from StatelessWidget.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ========================================================================
    // STEP 1: WATCH THE PROVIDER
    // ========================================================================

    /// Watch the usersProvider to get user data
    ///
    /// WHAT DOES ref.watch() DO?
    /// 1. Gets the current value from the provider
    /// 2. Subscribes to changes (rebuilds when data changes)
    /// 3. Returns AsyncValue<List<User>>
    ///
    /// WHAT IS AsyncValue?
    /// AsyncValue is a wrapper that can be in 3 states:
    /// - AsyncValue.loading() - Data is loading
    /// - AsyncValue.error(error, stackTrace) - An error occurred
    /// - AsyncValue.data(value) - We have the data!
    ///
    /// WHY AsyncValue?
    /// Instead of manually tracking loading/error/data states,
    /// Riverpod does it for us automatically!
    final usersAsync = ref.watch(usersProvider);

    // ========================================================================
    // STEP 2: BUILD THE SCAFFOLD
    // ========================================================================

    return Scaffold(
      // ------------------------------------------------------------------------
      // APP BAR
      // ------------------------------------------------------------------------
      appBar: AppBar(
        title: const Text('Users (Learning Example)'),
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // REFRESH THE DATA
              // ref.refresh() invalidates the provider, making it reload
              ref.refresh(usersProvider);
            },
            tooltip: 'Refresh users',
          ),
        ],
      ),

      // ------------------------------------------------------------------------
      // BODY - Main content
      // ------------------------------------------------------------------------

      /// STEP 3: HANDLE ALL THREE STATES WITH .when()
      ///
      /// .when() is MAGIC! It handles loading, error, and data states automatically.
      ///
      /// HOW IT WORKS:
      /// - If usersAsync is loading → calls loading callback
      /// - If usersAsync has error → calls error callback
      /// - If usersAsync has data → calls data callback
      ///
      /// This is MUCH cleaner than doing if-else checks everywhere!
      body: usersAsync.when(
        // ======================================================================
        // LOADING STATE
        // ======================================================================

        /// Called while data is loading (waiting for API response)
        ///
        /// This runs when:
        /// - Screen first opens (initial load)
        /// - User pulls to refresh
        /// - Provider is refreshed programmatically
        ///
        /// WHAT TO SHOW:
        /// - Loading spinner
        /// - Loading skeleton
        /// - "Loading..." text
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Circular loading indicator
              CircularProgressIndicator(),
              SizedBox(height: 16),
              // Loading message
              Text(
                'Loading users...',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),

        // ======================================================================
        // ERROR STATE
        // ======================================================================

        /// Called when an error occurs
        ///
        /// Parameters:
        /// - [error]: The error object (Exception, String, etc.)
        /// - [stackTrace]: Stack trace for debugging
        ///
        /// This runs when:
        /// - Network request fails (no internet)
        /// - Server returns error (500, 404, etc.)
        /// - JSON parsing fails
        /// - Any exception is thrown
        ///
        /// WHAT TO SHOW:
        /// - Error icon
        /// - Error message
        /// - Retry button
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Error icon
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),

                // Error message
                Text(
                  'Oops! Something went wrong',
                  style: Theme.of(context).textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),

                // Error details
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),

                // Retry button
                ElevatedButton.icon(
                  onPressed: () {
                    // Refresh the provider to retry
                    // This will re-run the FutureProvider, making a new API call
                    ref.refresh(usersProvider);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),

        // ======================================================================
        // DATA STATE (SUCCESS!)
        // ======================================================================

        /// Called when we successfully have data
        ///
        /// Parameters:
        /// - [users]: List<User> - The actual user data from API
        ///
        /// This runs when:
        /// - API call succeeds
        /// - Data is parsed successfully
        /// - No errors occurred
        ///
        /// WHAT TO SHOW:
        /// - List of items
        /// - Grid of items
        /// - Empty state if list is empty
        data: (users) {
          // --------------------------------------------------------------------
          // HANDLE EMPTY STATE
          // --------------------------------------------------------------------

          /// Check if list is empty
          ///
          /// IMPORTANT: Always check for empty data!
          /// API might return empty array [] which is not an error,
          /// but we should show a helpful message to the user.
          if (users.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.inbox_outlined,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No users found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          // --------------------------------------------------------------------
          // DISPLAY THE LIST WITH PULL-TO-REFRESH
          // --------------------------------------------------------------------

          /// RefreshIndicator allows pull-to-refresh functionality
          ///
          /// HOW IT WORKS:
          /// 1. User pulls down on the list
          /// 2. onRefresh callback is called
          /// 3. We refresh the provider
          /// 4. List rebuilds with new data
          ///
          /// onRefresh MUST return a Future!
          /// We use Future.microtask to make ref.refresh async
          return RefreshIndicator(
            onRefresh: () async {
              // Refresh the provider
              // This invalidates the cache and makes a new API call
              ref.refresh(usersProvider);
            },
            child: ListView.builder(
              // Number of items in the list
              itemCount: users.length,

              // Build each item
              // [context]: BuildContext for this item
              // [index]: Position in the list (0, 1, 2, ...)
              itemBuilder: (context, index) {
                // Get the user at this index
                final user = users[index];

                // ============================================================
                // BUILD LIST ITEM
                // ============================================================

                /// ListTile is a Material Design list item
                ///
                /// It has:
                /// - leading: Widget on the left (avatar, icon)
                /// - title: Main text (user name)
                /// - subtitle: Secondary text (user email)
                /// - trailing: Widget on the right (arrow, button)
                /// - onTap: Called when user taps the item
                return ListTile(
                  // ----------------------------------------------------------
                  // LEADING: Avatar with user's first letter
                  // ----------------------------------------------------------
                  leading: CircleAvatar(
                    // Background color
                    backgroundColor: Colors.blue,
                    // Text color
                    foregroundColor: Colors.white,
                    // Display first letter of name
                    child: Text(
                      user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),

                  // ----------------------------------------------------------
                  // TITLE: User's name
                  // ----------------------------------------------------------
                  title: Text(
                    user.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                    ),
                  ),

                  // ----------------------------------------------------------
                  // SUBTITLE: User's email and username
                  // ----------------------------------------------------------
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(user.email),
                      Text(
                        '@${user.username}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),

                  // ----------------------------------------------------------
                  // TRAILING: Arrow icon
                  // ----------------------------------------------------------
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),

                  // ----------------------------------------------------------
                  // ON TAP: Navigate to detail screen
                  // ----------------------------------------------------------

                  /// Called when user taps this item
                  ///
                  /// We navigate to UserDetailScreen and pass the user's ID
                  onTap: () {
                    // Navigate to detail screen
                    // We use Navigator.push to add new screen to navigation stack
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => UserDetailScreen(
                          userId: user.id, // Pass user ID to detail screen
                        ),
                      ),
                    );
                  },

                  // ----------------------------------------------------------
                  // VISUAL: Add some padding for better UX
                  // ----------------------------------------------------------
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ============================================================================
// SUMMARY - Key Takeaways
// ============================================================================
//
// WIDGET TYPE:
// - Use ConsumerWidget instead of StatelessWidget
// - This gives you access to WidgetRef ref
//
// WATCHING PROVIDERS:
// - Use ref.watch(provider) to get data
// - Widget rebuilds when provider changes
//
// HANDLING ASYNC DATA:
// - FutureProvider returns AsyncValue<T>
// - Use .when(loading:, error:, data:) to handle all states
// - This is cleaner than if-else everywhere!
//
// REFRESHING DATA:
// - Use ref.refresh(provider) to reload data
// - Works great with RefreshIndicator for pull-to-refresh
//
// NAVIGATION:
// - Use Navigator.push to navigate to new screen
// - Pass data (like userId) through constructor
//
// STRUCTURE:
// - Loading state: Show spinner + message
// - Error state: Show icon + message + retry button
// - Empty state: Show message when no data
// - Data state: Show the actual content
//
// NEXT STEPS:
// - Look at user_detail_screen.dart to see how to fetch single items
// - Try building your own list screen for posts
// - Complete the practice tasks!
//
// ============================================================================
