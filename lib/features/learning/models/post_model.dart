// ============================================================================
// POST MODEL - Data Structure for Blog Post Objects
// ============================================================================
//
// PURPOSE: Defines what a "Post" (blog post/article) looks like
//
// This is another example of a model, simpler than User model.
// Study both to understand the pattern!
//
// ============================================================================

/// Represents a blog post in our application
///
/// Posts are articles/content created by users
class Post {
  // ============================================================================
  // PROPERTIES
  // ============================================================================

  /// Unique identifier for the post
  final int id;

  /// ID of the user who created this post
  /// This links the post to a specific user
  final int userId;

  /// Title of the post
  /// Example: "How to Learn Flutter"
  final String title;

  /// Main content/body of the post
  /// Example: "Flutter is a great framework because..."
  final String body;

  // ============================================================================
  // CONSTRUCTOR
  // ============================================================================

  /// Creates a new Post instance
  Post({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
  });

  // ============================================================================
  // FROM JSON - Parse API response to Post object
  // ============================================================================

  /// Creates a Post from JSON data
  ///
  /// Example API response from JSONPlaceholder:
  /// ```json
  /// {
  ///   "userId": 1,
  ///   "id": 1,
  ///   "title": "sunt aut facere repellat provident",
  ///   "body": "quia et suscipit\nsuscipit recusandae..."
  /// }
  /// ```
  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      userId: json['userId'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  // ============================================================================
  // TO JSON - Convert Post object to JSON
  // ============================================================================

  /// Converts this Post to JSON format (for sending to API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'body': body,
    };
  }

  // ============================================================================
  // HELPER METHODS
  // ============================================================================

  /// Creates a copy with modified fields
  Post copyWith({
    int? id,
    int? userId,
    String? title,
    String? body,
  }) {
    return Post(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      body: body ?? this.body,
    );
  }

  /// String representation for debugging
  @override
  String toString() {
    return 'Post(id: $id, userId: $userId, title: $title)';
  }

  /// Equality comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is Post &&
        other.id == id &&
        other.userId == userId &&
        other.title == title &&
        other.body == body;
  }

  /// Hash code
  @override
  int get hashCode {
    return id.hashCode ^ userId.hashCode ^ title.hashCode ^ body.hashCode;
  }
}

// ============================================================================
// PRACTICE EXERCISE
// ============================================================================
//
// Try creating your own Comment model! It should have:
// - int id
// - int postId (which post this comment belongs to)
// - String name (commenter's name)
// - String email (commenter's email)
// - String body (comment text)
//
// API endpoint: https://jsonplaceholder.typicode.com/comments
//
// Create a file: lib/features/practice/models/comment_model.dart
//
// ============================================================================
