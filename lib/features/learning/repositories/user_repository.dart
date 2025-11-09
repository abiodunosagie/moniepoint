// ============================================================================
// USER REPOSITORY - Handles All User-Related API Calls
// ============================================================================
//
// PURPOSE: This is where ALL user-related API calls happen
//
// WHAT IS A REPOSITORY?
// A repository is a layer that handles data fetching/saving. Think of it as:
// - A librarian who gets books (data) for you
// - You ask the librarian (repository) for a book (data)
// - The librarian knows where to find it (API endpoint)
// - The librarian brings it to you (returns the data)
//
// WHY USE A REPOSITORY?
// 1. **Separation of Concerns**: UI doesn't need to know HOW to fetch data
// 2. **Reusability**: Multiple screens can use the same repository
// 3. **Testability**: Easy to test API calls separately from UI
// 4. **Maintainability**: All API logic in one place
// 5. **Flexibility**: Easy to switch from API to local database
//
// REPOSITORY PATTERN:
// UI → Provider → Repository → API
//     ←           ←            ←
//
// ============================================================================

// Import required packages
import 'dart:convert'; // For json.decode() and json.encode()
import 'package:http/http.dart' as http; // For making HTTP requests
import '../models/user_model.dart'; // Import our User model

/// Repository for managing user data from JSONPlaceholder API
///
/// This class handles all operations related to users:
/// - Fetching all users
/// - Fetching a single user
/// - Creating new users
/// - Updating users
/// - Deleting users
class UserRepository {
  // ============================================================================
  // DEPENDENCIES
  // ============================================================================

  /// HTTP client for making requests
  ///
  /// WHY INJECT THIS?
  /// Instead of creating http.Client() inside this class, we receive it
  /// from outside (dependency injection). Benefits:
  /// - Can inject a mock client for testing
  /// - Can inject a client with custom configuration
  /// - Can inject a client that caches responses
  /// - Single instance shared across app
  final http.Client httpClient;

  /// Base URL for the API
  ///
  /// All endpoints start with this URL
  /// We can change this to point to different environments:
  /// - Development: https://dev-api.example.com
  /// - Staging: https://staging-api.example.com
  /// - Production: https://api.example.com
  static const String _baseUrl = 'https://jsonplaceholder.typicode.com';

  // ============================================================================
  // CONSTRUCTOR
  // ============================================================================

  /// Creates a UserRepository with required dependencies
  ///
  /// Example usage:
  /// ```dart
  /// final client = http.Client();
  /// final repository = UserRepository(httpClient: client);
  /// ```
  UserRepository({
    required this.httpClient, // Must be provided (dependency injection!)
  });

  // ============================================================================
  // GET ALL USERS
  // ============================================================================

  /// Fetches all users from the API
  ///
  /// WHAT THIS DOES:
  /// 1. Makes a GET request to /users endpoint
  /// 2. Waits for response (this is async, could take 1-3 seconds)
  /// 3. Checks if request was successful (status code 200)
  /// 4. Converts JSON response to List of User objects
  /// 5. Returns the list
  ///
  /// ENDPOINT: GET https://jsonplaceholder.typicode.com/users
  ///
  /// Example usage:
  /// ```dart
  /// try {
  ///   List<User> users = await repository.getUsers();
  ///   print('Fetched ${users.length} users');
  /// } catch (e) {
  ///   print('Error: $e');
  /// }
  /// ```
  ///
  /// Returns: List of User objects
  /// Throws: Exception if request fails
  Future<List<User>> getUsers() async {
    // TRY-CATCH: Wrap API call in try-catch to handle errors gracefully
    try {
      // STEP 1: Make GET request
      // ------------------------------------------------------------------
      // http.get() makes an HTTP GET request to the specified URL
      // await: Wait for the request to complete (could take 1-3 seconds)
      // Uri.parse(): Convert string URL to Uri object
      final response = await httpClient.get(
        Uri.parse('$_baseUrl/users'), // Full URL: https://jsonplaceholder.typicode.com/users
      );

      // STEP 2: Check if request was successful
      // ------------------------------------------------------------------
      // Status codes:
      // 200 = Success
      // 404 = Not found
      // 500 = Server error
      // etc.
      if (response.statusCode == 200) {
        // SUCCESS! Parse the response

        // STEP 3: Decode JSON string to List
        // ------------------------------------------------------------------
        // response.body is a STRING that looks like:
        // '[{"id":1,"name":"John"},{"id":2,"name":"Jane"}]'
        //
        // json.decode() converts it to Dart List:
        // [{'id':1,'name':'John'},{'id':2,'name':'Jane'}]
        //
        // We cast it to List<dynamic> because json.decode returns dynamic
        final List<dynamic> jsonList = json.decode(response.body) as List;

        // STEP 4: Convert each JSON object to User object
        // ------------------------------------------------------------------
        // jsonList is List<dynamic> containing Maps
        // We need to convert each Map to a User object
        //
        // .map() iterates over each item in the list
        // For each item (json), we call User.fromJson(json)
        // This creates a User object from the JSON data
        //
        // .toList() converts the Iterable to a List
        final List<User> users = jsonList
            .map((json) => User.fromJson(json as Map<String, dynamic>))
            .toList();

        // STEP 5: Return the list of users
        return users;
      } else {
        // FAILURE! Request didn't return 200
        // Throw an exception so the caller knows it failed
        throw Exception(
          'Failed to load users. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      // STEP 6: Handle any errors
      // ------------------------------------------------------------------
      // Errors that might occur:
      // - No internet connection
      // - Server is down
      // - JSON parsing error
      // - Timeout
      //
      // We log the error and re-throw it so the UI can handle it
      print('Error in getUsers: $e');
      rethrow; // Re-throw the error so it can be caught by the caller
    }
  }

  // ============================================================================
  // GET SINGLE USER
  // ============================================================================

  /// Fetches a single user by ID
  ///
  /// ENDPOINT: GET https://jsonplaceholder.typicode.com/users/{id}
  ///
  /// Example usage:
  /// ```dart
  /// try {
  ///   User user = await repository.getUser(1);
  ///   print('User: ${user.name}');
  /// } catch (e) {
  ///   print('User not found');
  /// }
  /// ```
  ///
  /// Parameters:
  /// - [id]: The user ID to fetch
  ///
  /// Returns: User object
  /// Throws: Exception if user not found or request fails
  Future<User> getUser(int id) async {
    try {
      // Make GET request with user ID in URL
      // Example: https://jsonplaceholder.typicode.com/users/1
      final response = await httpClient.get(
        Uri.parse('$_baseUrl/users/$id'), // $id is replaced with actual ID
      );

      if (response.statusCode == 200) {
        // SUCCESS! Parse single user

        // response.body is a STRING like:
        // '{"id":1,"name":"John","email":"john@example.com"}'
        //
        // json.decode() converts it to Map:
        // {'id':1,'name':'John','email':'john@example.com'}
        final Map<String, dynamic> jsonData = json.decode(response.body) as Map<String, dynamic>;

        // Convert Map to User object using fromJson factory
        return User.fromJson(jsonData);
      } else if (response.statusCode == 404) {
        // User not found
        throw Exception('User with ID $id not found');
      } else {
        // Other error
        throw Exception('Failed to load user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getUser: $e');
      rethrow;
    }
  }

  // ============================================================================
  // CREATE USER
  // ============================================================================

  /// Creates a new user
  ///
  /// WHAT THIS DOES:
  /// 1. Converts User object to JSON
  /// 2. Makes a POST request with JSON data in body
  /// 3. API creates the user and returns it with an ID
  /// 4. Converts response JSON back to User object
  /// 5. Returns the created user
  ///
  /// ENDPOINT: POST https://jsonplaceholder.typicode.com/users
  ///
  /// Example usage:
  /// ```dart
  /// User newUser = User(
  ///   id: 0, // ID will be set by server
  ///   name: 'John Doe',
  ///   username: 'johndoe',
  ///   email: 'john@example.com',
  /// );
  ///
  /// User createdUser = await repository.createUser(newUser);
  /// print('Created user with ID: ${createdUser.id}');
  /// ```
  ///
  /// Parameters:
  /// - [user]: The user data to create
  ///
  /// Returns: Created user with ID from server
  /// Throws: Exception if creation fails
  Future<User> createUser(User user) async {
    try {
      // STEP 1: Convert User object to JSON
      final Map<String, dynamic> userData = user.toJson();

      // STEP 2: Make POST request
      // ------------------------------------------------------------------
      final response = await httpClient.post(
        Uri.parse('$_baseUrl/users'),
        headers: {
          // Tell the server we're sending JSON
          'Content-Type': 'application/json',
          // Tell the server we expect JSON back
          'Accept': 'application/json',
        },
        // STEP 3: Convert Map to JSON string for the request body
        // json.encode() converts Map to JSON string
        // {'name':'John'} becomes '{"name":"John"}'
        body: json.encode(userData),
      );

      // STEP 4: Check if creation was successful
      // Status code 201 = Created successfully
      if (response.statusCode == 201) {
        // SUCCESS! Parse the created user from response
        final Map<String, dynamic> jsonData = json.decode(response.body) as Map<String, dynamic>;
        return User.fromJson(jsonData);
      } else {
        throw Exception('Failed to create user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in createUser: $e');
      rethrow;
    }
  }

  // ============================================================================
  // UPDATE USER (Complete replacement)
  // ============================================================================

  /// Updates a user (replaces all fields)
  ///
  /// WHAT IS PUT?
  /// PUT replaces the ENTIRE resource. You must send ALL fields.
  /// If you don't send a field, it might be set to null!
  ///
  /// ENDPOINT: PUT https://jsonplaceholder.typicode.com/users/{id}
  ///
  /// Example usage:
  /// ```dart
  /// User updatedUser = existingUser.copyWith(name: 'Jane Doe');
  /// User result = await repository.updateUser(updatedUser);
  /// ```
  ///
  /// Parameters:
  /// - [user]: The user with updated data (must include ID)
  ///
  /// Returns: Updated user from server
  /// Throws: Exception if update fails
  Future<User> updateUser(User user) async {
    try {
      final response = await httpClient.put(
        Uri.parse('$_baseUrl/users/${user.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(user.toJson()),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body) as Map<String, dynamic>;
        return User.fromJson(jsonData);
      } else {
        throw Exception('Failed to update user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in updateUser: $e');
      rethrow;
    }
  }

  // ============================================================================
  // PARTIAL UPDATE (Only update specific fields)
  // ============================================================================

  /// Partially updates a user (only specified fields)
  ///
  /// WHAT IS PATCH?
  /// PATCH updates only the fields you send. Other fields stay unchanged.
  ///
  /// ENDPOINT: PATCH https://jsonplaceholder.typicode.com/users/{id}
  ///
  /// Example usage:
  /// ```dart
  /// // Only update the name
  /// User result = await repository.patchUser(1, {'name': 'New Name'});
  /// ```
  ///
  /// Parameters:
  /// - [id]: User ID to update
  /// - [updates]: Map of fields to update
  ///
  /// Returns: Updated user from server
  /// Throws: Exception if update fails
  Future<User> patchUser(int id, Map<String, dynamic> updates) async {
    try {
      final response = await httpClient.patch(
        Uri.parse('$_baseUrl/users/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(updates),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body) as Map<String, dynamic>;
        return User.fromJson(jsonData);
      } else {
        throw Exception('Failed to patch user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in patchUser: $e');
      rethrow;
    }
  }

  // ============================================================================
  // DELETE USER
  // ============================================================================

  /// Deletes a user
  ///
  /// ENDPOINT: DELETE https://jsonplaceholder.typicode.com/users/{id}
  ///
  /// Example usage:
  /// ```dart
  /// await repository.deleteUser(1);
  /// print('User deleted');
  /// ```
  ///
  /// Parameters:
  /// - [id]: User ID to delete
  ///
  /// Returns: void (nothing)
  /// Throws: Exception if deletion fails
  Future<void> deleteUser(int id) async {
    try {
      final response = await httpClient.delete(
        Uri.parse('$_baseUrl/users/$id'),
      );

      // Status code 200 or 204 = Successfully deleted
      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete user. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in deleteUser: $e');
      rethrow;
    }
  }
}

// ============================================================================
// SUMMARY - Key Takeaways
// ============================================================================
//
// 1. Repository handles ALL data operations for a specific domain (users)
// 2. Each method does ONE thing (single responsibility)
// 3. Always use try-catch for error handling
// 4. Check status codes to know if request succeeded
// 5. Convert between JSON and Dart objects using fromJson/toJson
// 6. Inject dependencies (httpClient) instead of creating them inside
//
// HTTP METHODS RECAP:
// - GET: Fetch data (doesn't change anything)
// - POST: Create new resource
// - PUT: Replace entire resource
// - PATCH: Update specific fields
// - DELETE: Remove resource
//
// NEXT STEPS:
// - Look at providers file to see how we use this repository
// - Look at UI file to see how we display the data
// - Try creating your own repository for posts!
//
// ============================================================================
