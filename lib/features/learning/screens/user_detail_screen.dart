// ============================================================================
// USER DETAIL SCREEN - Display Single User Details
// ============================================================================
//
// PURPOSE: This screen demonstrates how to:
// 1. Use FutureProvider.family (provider with parameter)
// 2. Fetch single item by ID
// 3. Display detailed information
// 4. Handle loading and error states for detail views
//
// This is the pattern for detail/show pages!
//
// ============================================================================

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/user_providers.dart';

// ============================================================================
// MAIN WIDGET
// ============================================================================

/// Screen that displays details of a single user
///
/// IMPORTANT: This screen receives userId as a parameter!
///
/// WHY?
/// - We need to know which user to display
/// - The previous screen passes the ID when navigating here
/// - We use this ID to fetch the specific user from the API
class UserDetailScreen extends ConsumerWidget {
  /// The ID of the user to display
  ///
  /// This is passed from the previous screen:
  /// ```dart
  /// Navigator.push(
  ///   context,
  ///   MaterialPageRoute(
  ///     builder: (context) => UserDetailScreen(userId: 5),
  ///   ),
  /// );
  /// ```
  final int userId;

  /// Constructor
  ///
  /// Parameters:
  /// - [userId]: Required - which user to display
  /// - [key]: Optional - widget key (standard Flutter)
  const UserDetailScreen({
    Key? key,
    required this.userId, // Must provide userId!
  }) : super(key: key);

  // ============================================================================
  // BUILD METHOD
  // ============================================================================

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // ========================================================================
    // WATCH THE FAMILY PROVIDER WITH PARAMETER
    // ========================================================================

    /// Watch the userProvider with userId parameter
    ///
    /// IMPORTANT: We pass userId to the provider!
    ///
    /// HOW .family WORKS:
    /// - userProvider is a FutureProvider.family<User, int>
    /// - It takes an int parameter (the user ID)
    /// - We call it like a function: userProvider(userId)
    /// - This fetches the user with that specific ID
    ///
    /// EXAMPLE:
    /// - userProvider(1) fetches user with ID 1
    /// - userProvider(2) fetches user with ID 2
    /// - Both are cached separately!
    ///
    /// WHAT HAPPENS:
    /// 1. We call ref.watch(userProvider(userId))
    /// 2. Provider calls repository.getUser(userId)
    /// 3. Repository makes GET /users/{userId}
    /// 4. API returns user data
    /// 5. Provider converts JSON to User object
    /// 6. We get AsyncValue<User>
    final userAsync = ref.watch(userProvider(userId));

    // ========================================================================
    // BUILD THE SCAFFOLD
    // ========================================================================

    return Scaffold(
      // ------------------------------------------------------------------------
      // APP BAR
      // ------------------------------------------------------------------------
      appBar: AppBar(
        title: const Text('User Details'),
        actions: [
          // Refresh button
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              // Refresh this specific user
              // Note: We refresh userProvider(userId), not userProvider!
              ref.refresh(userProvider(userId));
            },
            tooltip: 'Refresh user',
          ),
        ],
      ),

      // ------------------------------------------------------------------------
      // BODY - Handle loading/error/data states
      // ------------------------------------------------------------------------
      body: userAsync.when(
        // ======================================================================
        // LOADING STATE
        // ======================================================================
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Loading user details...'),
            ],
          ),
        ),

        // ======================================================================
        // ERROR STATE
        // ======================================================================
        error: (error, stackTrace) => Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  size: 64,
                  color: Colors.red,
                ),
                const SizedBox(height: 16),
                Text(
                  'Failed to load user',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  error.toString(),
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.refresh(userProvider(userId));
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                ),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Go back
                  },
                  child: const Text('Go Back'),
                ),
              ],
            ),
          ),
        ),

        // ======================================================================
        // DATA STATE (SUCCESS!)
        // ======================================================================
        data: (user) {
          // --------------------------------------------------------------------
          // BUILD THE DETAIL VIEW
          // --------------------------------------------------------------------

          /// We have the user data! Display it nicely.
          ///
          /// STRUCTURE:
          /// - Header with avatar and name
          /// - Information cards
          /// - Action buttons
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // ==============================================================
                // HEADER SECTION
                // ==============================================================

                /// Large avatar and name at the top
                Center(
                  child: Column(
                    children: [
                      // Large avatar
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        child: Text(
                          user.name.isNotEmpty
                              ? user.name[0].toUpperCase()
                              : '?',
                          style: const TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // User name
                      Text(
                        user.name,
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 4),

                      // Username
                      Text(
                        '@${user.username}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ==============================================================
                // INFORMATION CARDS
                // ==============================================================

                /// Display user information in cards
                ///
                /// PATTERN: Each piece of info gets its own card
                /// This looks clean and organized

                // Email card
                _InfoCard(
                  icon: Icons.email,
                  title: 'Email',
                  value: user.email,
                  onTap: () {
                    // TODO: Could open email app
                    // launch('mailto:${user.email}');
                  },
                ),

                const SizedBox(height: 12),

                // Phone card (if available)
                if (user.phone != null)
                  _InfoCard(
                    icon: Icons.phone,
                    title: 'Phone',
                    value: user.phone!,
                    onTap: () {
                      // TODO: Could open phone dialer
                      // launch('tel:${user.phone}');
                    },
                  ),

                if (user.phone != null) const SizedBox(height: 12),

                // Website card (if available)
                if (user.website != null)
                  _InfoCard(
                    icon: Icons.language,
                    title: 'Website',
                    value: user.website!,
                    onTap: () {
                      // TODO: Could open browser
                      // launch('https://${user.website}');
                    },
                  ),

                const SizedBox(height: 32),

                // ==============================================================
                // ACTION BUTTONS
                // ==============================================================

                /// Buttons for common actions
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () {
                          // Show edit dialog
                          _showEditDialog(context, ref, user);
                        },
                        icon: const Icon(Icons.edit),
                        label: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          // Show delete confirmation
                          _showDeleteConfirmation(context, ref, user);
                        },
                        icon: const Icon(Icons.delete),
                        label: const Text('Delete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Shows a dialog to edit user (placeholder)
  ///
  /// NOTE: This is just a placeholder to show the pattern!
  /// In a real app, you would:
  /// 1. Show a form with user's current data
  /// 2. Let user edit the fields
  /// 3. Call repository.updateUser(updatedUser)
  /// 4. Refresh the provider
  void _showEditDialog(BuildContext context, WidgetRef ref, user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit User'),
        content: const Text(
          'This is a placeholder.\n\n'
          'In a real app, you would show a form here to edit user data.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              // TODO: Call repository.updateUser()
              // ref.read(userRepositoryProvider).updateUser(updatedUser);
              // ref.refresh(userProvider(userId));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  /// Shows confirmation dialog before deleting user
  void _showDeleteConfirmation(BuildContext context, WidgetRef ref, user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context); // Go back to list
              // TODO: Call repository.deleteUser()
              // ref.read(userRepositoryProvider).deleteUser(userId);
              // ref.refresh(usersProvider);

              // Show confirmation
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${user.name} deleted (simulated)'),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// ============================================================================
// INFO CARD WIDGET (Reusable component)
// ============================================================================

/// A card that displays one piece of user information
///
/// WHY CREATE A SEPARATE WIDGET?
/// - Reusable: Use same card for email, phone, website
/// - Cleaner code: Main build method stays readable
/// - Easier to maintain: Change all cards by editing one widget
///
/// This is a GOOD PRACTICE!
class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final VoidCallback? onTap;

  const _InfoCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.value,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(width: 16),

              // Title and value
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      value,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow icon (if tappable)
              if (onTap != null)
                Icon(
                  Icons.arrow_forward_ios,
                  size: 16,
                  color: Colors.grey[400],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ============================================================================
// SUMMARY - Key Takeaways
// ============================================================================
//
// FAMILY PROVIDER:
// - Use FutureProvider.family when you need to pass parameters
// - Call it like: ref.watch(userProvider(userId))
// - Each parameter value gets its own cached instance
//
// DETAIL SCREEN PATTERN:
// - Receive ID through constructor
// - Pass ID to family provider
// - Handle loading/error/data states
// - Display detailed information nicely
//
// REUSABLE WIDGETS:
// - Extract repeated UI into separate widgets (_InfoCard)
// - Makes code cleaner and more maintainable
// - Prefix with _ to make it private to this file
//
// USER ACTIONS:
// - Show dialogs for destructive actions (delete)
// - Show forms for editing data
// - Use SnackBar for confirmations
//
// NAVIGATION:
// - Use Navigator.pop() to go back
// - Can pop multiple times to go back several screens
//
// NEXT STEPS:
// - Try creating a post detail screen
// - Add more fields to display
// - Implement the edit functionality
// - Add more actions (share, favorite, etc.)
//
// ============================================================================
