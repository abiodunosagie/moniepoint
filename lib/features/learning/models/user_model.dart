// ============================================================================
// USER MODEL - Data Structure for User Objects
// ============================================================================
//
// PURPOSE: This file defines what a "User" looks like in our app.
//
// WHAT IS A MODEL?
// A model is a blueprint/template for data. Think of it like a form:
// - The form has fields (name, email, etc.)
// - Each person who fills it out creates one instance
// - The model defines what fields exist and their types
//
// WHY DO WE NEED MODELS?
// Instead of using Map<String, dynamic> everywhere (which is error-prone),
// we create a class that:
// 1. Makes code more readable (user.name vs user['name'])
// 2. Catches errors at compile-time (typos won't work)
// 3. Provides autocomplete in your IDE
// 4. Makes testing easier
//
// ============================================================================

/// Represents a user in our application
///
/// This class holds all the information about a single user.
/// We fetch this data from the API and convert it to this class format.
class User {
  // ============================================================================
  // PROPERTIES (The data each user has)
  // ============================================================================

  /// Unique identifier for the user
  /// Example: 1, 2, 3, etc.
  /// This comes from the API and helps us identify specific users
  final int id;

  /// User's full name
  /// Example: "John Doe"
  final String name;

  /// User's username (shorter than full name)
  /// Example: "johndoe123"
  final String username;

  /// User's email address
  /// Example: "john@example.com"
  final String email;

  /// User's phone number
  /// Example: "1-770-736-8031"
  /// NOTE: This is optional (nullable) because not all APIs return it
  final String? phone;

  /// User's website
  /// Example: "example.com"
  /// NOTE: This is optional (nullable) because not all users have websites
  final String? website;

  // ============================================================================
  // CONSTRUCTOR - How to create a User object
  // ============================================================================

  /// Creates a new User instance
  ///
  /// Example usage:
  /// ```dart
  /// final user = User(
  ///   id: 1,
  ///   name: 'John Doe',
  ///   username: 'johndoe',
  ///   email: 'john@example.com',
  ///   phone: '123-456-7890',
  ///   website: 'example.com',
  /// );
  /// ```
  ///
  /// Parameters:
  /// - [id]: Required - every user must have an ID
  /// - [name]: Required - every user must have a name
  /// - [username]: Required - every user must have a username
  /// - [email]: Required - every user must have an email
  /// - [phone]: Optional - can be null
  /// - [website]: Optional - can be null
  User({
    required this.id, // "required" means you MUST provide this value
    required this.name,
    required this.username,
    required this.email,
    this.phone, // No "required" = optional
    this.website,
  });

  // ============================================================================
  // FACTORY CONSTRUCTOR - Convert JSON to User object
  // ============================================================================

  /// Creates a User from JSON data (from API)
  ///
  /// WHY DO WE NEED THIS?
  /// When we fetch data from an API, we get JSON (a string that looks like this):
  /// {"id": 1, "name": "John", "email": "john@example.com"}
  ///
  /// We need to convert that JSON into a User object so we can use it in our app.
  ///
  /// HOW IT WORKS:
  /// 1. API sends JSON string: '{"id": 1, "name": "John"}'
  /// 2. We parse it to Map: {'id': 1, 'name': 'John'}
  /// 3. This factory extracts each value and creates a User object
  ///
  /// Example usage:
  /// ```dart
  /// // JSON from API (as a Map)
  /// Map<String, dynamic> jsonData = {
  ///   'id': 1,
  ///   'name': 'John Doe',
  ///   'username': 'johndoe',
  ///   'email': 'john@example.com',
  ///   'phone': '123-456-7890',
  ///   'website': 'example.com',
  /// };
  ///
  /// // Convert to User object
  /// User user = User.fromJson(jsonData);
  ///
  /// // Now we can use it like:
  /// print(user.name); // Output: John Doe
  /// print(user.email); // Output: john@example.com
  /// ```
  ///
  /// WHAT IS "factory"?
  /// - A special type of constructor
  /// - Can return an existing instance or create a new one
  /// - Useful for parsing JSON
  ///
  /// Parameters:
  /// - [json]: A Map containing the JSON data from the API
  ///
  /// Returns: A new User object
  factory User.fromJson(Map<String, dynamic> json) {
    // Extract each field from the JSON map
    // json['key'] gets the value for that key
    //
    // IMPORTANT: The keys ('id', 'name', etc.) must match exactly
    // what the API sends! Check API documentation for correct keys.
    //
    // EXAMPLE API RESPONSE from JSONPlaceholder:
    // {
    //   "id": 1,
    //   "name": "Leanne Graham",
    //   "username": "Bret",
    //   "email": "Sincere@april.biz",
    //   "phone": "1-770-736-8031 x56442",
    //   "website": "hildegard.org"
    // }

    return User(
      // Get 'id' from JSON and ensure it's an int
      // If the value is null, this will throw an error (which is good - we need ID!)
      id: json['id'] as int,

      // Get 'name' from JSON
      name: json['name'] as String,

      // Get 'username' from JSON
      username: json['username'] as String,

      // Get 'email' from JSON
      email: json['email'] as String,

      // Optional fields - use 'as String?' to allow null
      // If the JSON doesn't have 'phone', this will be null (which is fine)
      phone: json['phone'] as String?,

      // Optional website field
      website: json['website'] as String?,
    );
  }

  // ============================================================================
  // TO JSON - Convert User object back to JSON (for sending to API)
  // ============================================================================

  /// Converts this User object to JSON format
  ///
  /// WHY DO WE NEED THIS?
  /// When we want to send data TO the API (e.g., creating or updating a user),
  /// we need to convert our User object back to JSON format.
  ///
  /// Example usage:
  /// ```dart
  /// User user = User(
  ///   id: 1,
  ///   name: 'John Doe',
  ///   username: 'johndoe',
  ///   email: 'john@example.com',
  /// );
  ///
  /// // Convert to JSON
  /// Map<String, dynamic> json = user.toJson();
  ///
  /// // Send to API
  /// await http.post(
  ///   Uri.parse('https://api.example.com/users'),
  ///   body: jsonEncode(json), // Convert Map to JSON string
  /// );
  /// ```
  ///
  /// Returns: A Map that can be converted to JSON string
  Map<String, dynamic> toJson() {
    // Create a Map with key-value pairs
    // Keys are strings (API field names)
    // Values are our object properties
    return {
      'id': id,
      'name': name,
      'username': username,
      'email': email,

      // Only include phone if it's not null
      // The '?' means "if phone is not null, use it, otherwise use null"
      if (phone != null) 'phone': phone,

      // Only include website if it's not null
      if (website != null) 'website': website,
    };
  }

  // ============================================================================
  // HELPFUL METHODS (Optional but useful)
  // ============================================================================

  /// Creates a copy of this User with some fields changed
  ///
  /// WHY IS THIS USEFUL?
  /// In Flutter, we often need to create new objects instead of modifying existing ones
  /// (this is called "immutability"). This method makes it easy.
  ///
  /// Example usage:
  /// ```dart
  /// User user = User(id: 1, name: 'John', username: 'john', email: 'john@example.com');
  ///
  /// // Create a copy with changed name
  /// User updatedUser = user.copyWith(name: 'Jane');
  /// // updatedUser.name = 'Jane', but id, username, email stay the same
  /// ```
  User copyWith({
    int? id,
    String? name,
    String? username,
    String? email,
    String? phone,
    String? website,
  }) {
    return User(
      // If new ID is provided, use it, otherwise use current ID
      // ?? means "if left side is null, use right side"
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      website: website ?? this.website,
    );
  }

  /// String representation of User (helpful for debugging)
  ///
  /// This makes it easy to print user info during development
  ///
  /// Example usage:
  /// ```dart
  /// User user = User(id: 1, name: 'John', username: 'john', email: 'john@example.com');
  /// print(user); // Output: User(id: 1, name: John, email: john@example.com)
  /// ```
  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email)';
  }

  /// Equality comparison (helpful for testing and comparisons)
  ///
  /// This allows us to check if two User objects are the same
  ///
  /// Example usage:
  /// ```dart
  /// User user1 = User(id: 1, name: 'John', username: 'john', email: 'john@example.com');
  /// User user2 = User(id: 1, name: 'John', username: 'john', email: 'john@example.com');
  /// print(user1 == user2); // Output: true (they have same values)
  /// ```
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is User &&
        other.id == id &&
        other.name == name &&
        other.username == username &&
        other.email == email &&
        other.phone == phone &&
        other.website == website;
  }

  /// Hash code for User (required when overriding ==)
  ///
  /// This is used internally by Dart for collections and comparisons
  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        username.hashCode ^
        email.hashCode ^
        phone.hashCode ^
        website.hashCode;
  }
}

// ============================================================================
// SUMMARY - Key Takeaways
// ============================================================================
//
// 1. Models define the structure of your data
// 2. fromJson() converts API data (JSON) to Dart objects
// 3. toJson() converts Dart objects to JSON for sending to API
// 4. Use "required" for fields that must exist
// 5. Use "?" for nullable fields (optional fields)
// 6. Models make your code type-safe and easier to work with
//
// NEXT STEPS:
// - Look at the repository file to see how we use this model
// - Look at the providers file to see how we manage state
// - Look at the UI file to see how we display user data
//
// ============================================================================
