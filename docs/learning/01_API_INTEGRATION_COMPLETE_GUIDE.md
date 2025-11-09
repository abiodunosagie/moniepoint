# 📚 COMPLETE API INTEGRATION GUIDE FOR BEGINNERS

> **Your Journey Starts Here!** This guide will take you from confusion to confidence in API integration.

---

## 🎯 TABLE OF CONTENTS

1. [What is an API?](#what-is-an-api)
2. [How APIs Work](#how-apis-work)
3. [Understanding HTTP Methods](#understanding-http-methods)
4. [API Documentation - How to Read It](#api-documentation)
5. [JSON - The Language of APIs](#json-format)
6. [Making Your First API Call](#first-api-call)
7. [Error Handling](#error-handling)
8. [Best Practices](#best-practices)

---

## 📖 WHAT IS AN API?

### The Simple Explanation

**API stands for Application Programming Interface**

Think of an API like a **waiter in a restaurant**:

- **You (the app)**: The customer who wants food
- **The Kitchen (the server)**: Where the food is prepared
- **The Waiter (the API)**: Takes your order to the kitchen and brings back your food

You don't go into the kitchen yourself. You tell the waiter what you want, and they bring it to you!

### Real-World Example

When you use a weather app:
1. **You open the app** → The app sends a request to a weather API
2. **The API contacts the weather database** → Gets the current temperature
3. **The API sends the data back** → Your app displays "25°C"

You never see steps 2-3. The API handles everything!

---

## 🔄 HOW APIs WORK

### The Request-Response Cycle

```
YOUR APP                    API SERVER                 DATABASE
   |                            |                           |
   |----(1) REQUEST------------>|                           |
   |    "Give me user data"     |                           |
   |                            |----(2) QUERY------------->|
   |                            |    "Find user data"       |
   |                            |                           |
   |                            |<---(3) RESULTS------------|
   |                            |    "Here's the data"      |
   |<---(4) RESPONSE------------|                           |
   |    "Here's user data"      |                           |
```

### Breaking It Down Step-by-Step

**STEP 1: Your App Makes a Request**
```dart
// This is like saying "Hey API, give me the list of users"
final response = await http.get(Uri.parse('https://api.example.com/users'));
```

**STEP 2: The API Processes Your Request**
- The API receives your request
- Checks if you're allowed to access this data
- Queries its database
- Prepares the data in JSON format

**STEP 3: The API Sends a Response**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "John Doe",
      "email": "john@example.com"
    }
  ]
}
```

**STEP 4: Your App Receives and Uses the Data**
```dart
// Convert JSON to Dart objects
final users = (response.data as List)
    .map((json) => User.fromJson(json))
    .toList();

// Display in your UI
ListView.builder(
  itemCount: users.length,
  itemBuilder: (context, index) => Text(users[index].name),
);
```

---

## 🛠️ UNDERSTANDING HTTP METHODS

HTTP methods tell the API **what action you want to perform**. Think of them as verbs:

### 1. GET - "Give me data"
**Purpose**: Retrieve/Read data (doesn't change anything)

**Real-world analogy**: Looking at a menu in a restaurant

```dart
// Example: Get list of all users
final response = await http.get(
  Uri.parse('https://api.example.com/users')
);

// Example: Get one specific user
final response = await http.get(
  Uri.parse('https://api.example.com/users/123')
);
```

**When to use GET**:
- Fetching a list of items (products, users, posts)
- Getting details of one item
- Searching for something
- Loading initial data when screen opens

---

### 2. POST - "Create new data"
**Purpose**: Create new records

**Real-world analogy**: Placing an order at a restaurant

```dart
// Example: Create a new user
final response = await http.post(
  Uri.parse('https://api.example.com/users'),
  headers: {'Content-Type': 'application/json'},
  body: json.encode({
    'name': 'Jane Doe',
    'email': 'jane@example.com',
    'age': 25
  }),
);
```

**When to use POST**:
- Creating a new user account
- Submitting a form
- Uploading a new photo
- Adding items to cart

---

### 3. PUT - "Update existing data (complete replacement)"
**Purpose**: Update an entire record

**Real-world analogy**: Replacing your entire meal order

```dart
// Example: Update user (all fields must be provided)
final response = await http.put(
  Uri.parse('https://api.example.com/users/123'),
  headers: {'Content-Type': 'application/json'},
  body: json.encode({
    'name': 'Jane Smith',        // Changed
    'email': 'jane@example.com', // Same
    'age': 26                    // Changed
  }),
);
```

---

### 4. PATCH - "Update existing data (partial update)"
**Purpose**: Update only specific fields

**Real-world analogy**: Just changing your drink order, keeping the food the same

```dart
// Example: Update only the name
final response = await http.patch(
  Uri.parse('https://api.example.com/users/123'),
  headers: {'Content-Type': 'application/json'},
  body: json.encode({
    'name': 'Jane Smith'  // Only update the name
  }),
);
```

---

### 5. DELETE - "Remove data"
**Purpose**: Delete a record

**Real-world analogy**: Canceling your restaurant order

```dart
// Example: Delete a user
final response = await http.delete(
  Uri.parse('https://api.example.com/users/123')
);
```

**When to use DELETE**:
- Deleting your account
- Removing items from cart
- Deleting a post or comment

---

## 📄 API DOCUMENTATION - HOW TO READ IT

API documentation can look scary, but it's just a manual! Let's break it down:

### Example API Documentation

```
Endpoint: GET /api/users/{id}
Description: Get a user by ID
Authentication: Required (Bearer Token)

Path Parameters:
  - id (integer, required): The user ID

Query Parameters:
  - include (string, optional): Additional data to include (e.g., "posts,comments")

Headers:
  - Authorization: Bearer YOUR_TOKEN_HERE
  - Content-Type: application/json

Response (200 OK):
{
  "id": 1,
  "name": "John Doe",
  "email": "john@example.com"
}

Response (404 Not Found):
{
  "error": "User not found"
}
```

### Breaking Down Each Section

#### 1. **Endpoint**
```
GET /api/users/{id}
```
- **GET**: The HTTP method
- **/api/users/{id}**: The URL path
- **{id}**: A placeholder - you replace this with actual ID like `123`

**Full URL Example**: `https://example.com/api/users/123`

#### 2. **Path Parameters**
These are part of the URL itself:
```dart
// {id} is a path parameter
final userId = 123;
final url = 'https://api.example.com/users/$userId';
//                                           ^^^
//                                  This is path parameter
```

#### 3. **Query Parameters**
These come after `?` in the URL:
```dart
// Add query parameters with ?key=value&key2=value2
final url = 'https://api.example.com/users?age=25&city=Lagos';
//                                         ^^^^^^^^^^^^^^^^^^^^^
//                                         These are query parameters

// In Flutter:
final uri = Uri.parse('https://api.example.com/users').replace(
  queryParameters: {
    'age': '25',
    'city': 'Lagos'
  }
);
```

#### 4. **Headers**
Extra information sent with your request:
```dart
final response = await http.get(
  Uri.parse('https://api.example.com/users/123'),
  headers: {
    'Authorization': 'Bearer YOUR_TOKEN_HERE',
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  },
);
```

**Common Headers Explained**:
- **Authorization**: Proves who you are (like showing ID)
- **Content-Type**: What format you're sending (usually JSON)
- **Accept**: What format you want back (usually JSON)

#### 5. **Request Body**
Data you send (for POST, PUT, PATCH):
```dart
final response = await http.post(
  Uri.parse('https://api.example.com/users'),
  headers: {'Content-Type': 'application/json'},
  body: json.encode({  // ← This is the request body
    'name': 'John',
    'email': 'john@example.com'
  }),
);
```

#### 6. **Response Codes**
The API tells you what happened:

| Code | Meaning | What Happened |
|------|---------|---------------|
| **200** | OK | Success! Here's your data |
| **201** | Created | New record created successfully |
| **400** | Bad Request | You sent wrong/missing data |
| **401** | Unauthorized | You need to log in first |
| **403** | Forbidden | You're logged in but not allowed to do this |
| **404** | Not Found | The thing you requested doesn't exist |
| **500** | Server Error | The API broke (not your fault!) |

---

## 📝 JSON - THE LANGUAGE OF APIs

### What is JSON?

**JSON** = **J**ava**S**cript **O**bject **N**otation

It's a way to structure data that both humans and computers can read easily.

### JSON Basics

#### 1. **JSON Object** (Like a Dart Map)
```json
{
  "name": "John Doe",
  "age": 30,
  "isStudent": false
}
```

In Dart, this becomes:
```dart
Map<String, dynamic> person = {
  "name": "John Doe",
  "age": 30,
  "isStudent": false
};
```

#### 2. **JSON Array** (Like a Dart List)
```json
[
  "Apple",
  "Banana",
  "Orange"
]
```

In Dart:
```dart
List<String> fruits = ["Apple", "Banana", "Orange"];
```

#### 3. **Nested JSON** (Objects inside objects)
```json
{
  "user": {
    "id": 1,
    "name": "John Doe",
    "address": {
      "street": "123 Main St",
      "city": "Lagos",
      "country": "Nigeria"
    },
    "hobbies": ["Reading", "Coding", "Gaming"]
  }
}
```

### Converting Between JSON and Dart

#### String → Dart Object (Decoding)
```dart
// You get this string from API
String jsonString = '{"name":"John","age":30}';

// Convert to Dart Map
Map<String, dynamic> jsonMap = json.decode(jsonString);

// Access the data
print(jsonMap['name']); // Output: John
print(jsonMap['age']);  // Output: 30
```

#### Dart Object → String (Encoding)
```dart
// You have Dart Map
Map<String, dynamic> userData = {
  'name': 'John',
  'age': 30
};

// Convert to JSON string to send to API
String jsonString = json.encode(userData);
print(jsonString); // Output: {"name":"John","age":30}
```

### Creating Model Classes (IMPORTANT!)

Instead of using `Map<String, dynamic>` everywhere, create classes:

```dart
// ❌ BAD: Using raw maps (confusing and error-prone)
Map<String, dynamic> user = json.decode(response.body);
print(user['name']); // What if you typo 'nam'? No error until runtime!

// ✅ GOOD: Using a model class (clean and safe)
class User {
  final int id;
  final String name;
  final String email;

  User({
    required this.id,
    required this.name,
    required this.email,
  });

  // Convert JSON to User object
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  // Convert User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}

// Now use it:
User user = User.fromJson(json.decode(response.body));
print(user.name); // IDE helps with autocomplete! Much safer!
```

---

## 🚀 MAKING YOUR FIRST API CALL

Let's make a real API call step-by-step!

### Step 1: Import Required Packages
```dart
import 'dart:convert'; // For json.decode() and json.encode()
import 'package:http/http.dart' as http; // For making HTTP requests
```

### Step 2: Create the Function
```dart
Future<void> fetchUsers() async {
  // The await keyword means "wait for this to complete"
  // We'll explain this more in the async/await guide!

  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/users')
  );

  // Check if request was successful
  if (response.statusCode == 200) {
    // Success! Convert JSON string to Dart list
    List<dynamic> jsonList = json.decode(response.body);

    // Print first user's name
    print(jsonList[0]['name']);
  } else {
    // Something went wrong
    print('Error: ${response.statusCode}');
  }
}
```

### Step 3: Call It
```dart
void main() async {
  await fetchUsers();
}
```

### What Just Happened? (Line by Line)

```dart
final response = await http.get(
  Uri.parse('https://jsonplaceholder.typicode.com/users')
);
```
- `http.get()`: Makes a GET request to the API
- `Uri.parse()`: Converts string to proper URL format
- `await`: Pauses and waits for the response
- `response`: Contains everything the API sent back

```dart
if (response.statusCode == 200) {
```
- `statusCode`: The HTTP response code (200 = success)
- We check this to see if the request worked

```dart
List<dynamic> jsonList = json.decode(response.body);
```
- `response.body`: The actual data (as a string)
- `json.decode()`: Converts JSON string to Dart object
- `List<dynamic>`: We know the API returns an array

---

## ⚠️ ERROR HANDLING

APIs can fail for many reasons. Always handle errors!

### Types of Errors

1. **Network Errors**: No internet connection
2. **Server Errors**: API is down
3. **Client Errors**: You sent wrong data
4. **Parsing Errors**: JSON structure is unexpected

### Proper Error Handling Pattern

```dart
Future<List<User>> fetchUsers() async {
  try {
    // Try to make the request
    final response = await http.get(
      Uri.parse('https://jsonplaceholder.typicode.com/users'),
    );

    // Check status code
    if (response.statusCode == 200) {
      // Success! Parse the data
      final List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => User.fromJson(json)).toList();
    } else if (response.statusCode == 404) {
      // Not found
      throw Exception('Users not found');
    } else if (response.statusCode == 500) {
      // Server error
      throw Exception('Server error. Try again later.');
    } else {
      // Other errors
      throw Exception('Failed to load users: ${response.statusCode}');
    }
  } catch (e) {
    // Catch any errors (network issues, parsing errors, etc.)
    print('Error occurred: $e');
    rethrow; // Pass the error up so UI can handle it
  }
}
```

### Using Error Handling in UI

```dart
class UsersScreen extends StatefulWidget {
  @override
  _UsersScreenState createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  List<User>? users;  // Null means not loaded yet
  String? errorMessage;  // Null means no error
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadUsers();
  }

  Future<void> loadUsers() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final fetchedUsers = await fetchUsers();
      setState(() {
        users = fetchedUsers;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading indicator
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }

    // Show error message
    if (errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Error: $errorMessage'),
            ElevatedButton(
              onPressed: loadUsers,
              child: Text('Retry'),
            ),
          ],
        ),
      );
    }

    // Show users list
    if (users != null) {
      return ListView.builder(
        itemCount: users!.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(users![index].name),
          );
        },
      );
    }

    // Fallback
    return Center(child: Text('No data'));
  }
}
```

---

## ✅ BEST PRACTICES

### 1. Always Use Try-Catch
```dart
// ❌ BAD
Future<void> fetchData() async {
  final response = await http.get(Uri.parse(url));
  // What if this fails?
}

// ✅ GOOD
Future<void> fetchData() async {
  try {
    final response = await http.get(Uri.parse(url));
  } catch (e) {
    print('Error: $e');
  }
}
```

### 2. Create Separate Layers

**Model** → **Repository** → **Provider** → **UI**

```
User Model ←→ User Repository ←→ Users Provider ←→ Users Screen
(What data)   (How to get it)    (State mgmt)     (Display it)
```

### 3. Never Put API Calls in UI
```dart
// ❌ BAD: API call directly in widget
class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    http.get(...); // NO!
  }
}

// ✅ GOOD: API call in repository, accessed via provider
class UserRepository {
  Future<List<User>> getUsers() async {
    final response = await http.get(...);
    // ...
  }
}
```

### 4. Use Timeouts
```dart
final response = await http.get(
  Uri.parse(url),
).timeout(
  Duration(seconds: 10),
  onTimeout: () {
    throw Exception('Request timed out');
  },
);
```

### 5. Add Base URL Configuration
```dart
class ApiConfig {
  static const String baseUrl = 'https://api.example.com';
  static const Duration timeout = Duration(seconds: 30);

  static Uri endpoint(String path) {
    return Uri.parse('$baseUrl$path');
  }
}

// Usage
final response = await http.get(ApiConfig.endpoint('/users'));
```

---

## 🎓 SUMMARY - Key Takeaways

1. **API** = A bridge between your app and a server
2. **HTTP Methods**: GET (read), POST (create), PUT (update all), PATCH (update some), DELETE (remove)
3. **JSON** = The data format APIs use
4. **Always handle errors** with try-catch
5. **Use models** instead of raw Maps
6. **Separate concerns**: Model → Repository → Provider → UI
7. **Read documentation carefully** - it tells you exactly what to send and what you'll get back

---

## 🚀 NEXT STEPS

1. Read the `02_ASYNC_AWAIT_GUIDE.md` to understand async programming
2. Read the `03_DEPENDENCY_INJECTION_GUIDE.md` to understand DI
3. Read the `04_RIVERPOD_STATE_MANAGEMENT_GUIDE.md` to master Riverpod
4. Study the example code in `lib/features/learning/`
5. Complete the tasks in `PROGRESSIVE_LEARNING_TASKS.md`

---

**Remember**: Every expert was once a beginner. Take it one step at a time, and you WILL master this! 💪

The confusion you feel now is temporary. Understanding is permanent. Keep going!
