# 📝 PROGRESSIVE LEARNING TASKS

> **Learn by Doing!** Complete these tasks in order to master API integration with Riverpod.

---

## 🎯 HOW TO USE THIS GUIDE

1. **Read the documentation first** (guides 01-05)
2. **Study the example code** in `lib/features/learning/`
3. **Complete tasks in order** (they build on each other)
4. **Don't skip tasks** - each teaches important concepts
5. **Take your time** - understanding is more important than speed

### ✅ Mark Tasks as Complete

As you finish each task, check it off:
- [ ] Task name

---

## 🌟 LEVEL 1: ABSOLUTE BEGINNER

**Goal**: Understand the basics before writing any code

### Task 1.1: Read and Understand Documentation ⏱️ 2-3 hours

- [ ] Read `01_API_INTEGRATION_COMPLETE_GUIDE.md` thoroughly
- [ ] Read `02_ASYNC_AWAIT_GUIDE.md` thoroughly
- [ ] Read `03_DEPENDENCY_INJECTION_GUIDE.md` thoroughly
- [ ] Read `04_RIVERPOD_STATE_MANAGEMENT_GUIDE.md` thoroughly
- [ ] Read `05_DUMMY_APIs_REFERENCE.md` thoroughly

**Why this matters**: You need to understand concepts before writing code!

---

### Task 1.2: Install Dependencies ⏱️ 5 minutes

- [ ] Run `flutter pub get` to install Riverpod and other packages
- [ ] Verify installation completed without errors

**Command**:
```bash
flutter pub get
```

---

### Task 1.3: Wrap App with ProviderScope ⏱️ 5 minutes

- [ ] Open `lib/main.dart`
- [ ] Import Riverpod: `import 'package:flutter_riverpod/flutter_riverpod.dart';`
- [ ] Wrap your app with `ProviderScope`

**Example**:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:t_store/app.dart';

void main() {
  runApp(
    ProviderScope(  // ← ADD THIS
      child: const App(),
    ),
  );
}
```

**Test**: Run the app - it should work the same as before

---

### Task 1.4: Study the Example Code ⏱️ 1 hour

- [ ] Read all files in `lib/features/learning/models/`
- [ ] Read all files in `lib/features/learning/repositories/`
- [ ] Read all files in `lib/features/learning/providers/`
- [ ] Read all files in `lib/features/learning/screens/`

**Goal**: Understand how all pieces fit together

---

## 🚀 LEVEL 2: BEGINNER

**Goal**: Make your first API call and display data

### Task 2.1: Create Your First Model ⏱️ 15 minutes

Create a simple User model.

- [ ] Create file: `lib/features/practice/models/simple_user.dart`
- [ ] Create a `SimpleUser` class with: `id`, `name`, `email`
- [ ] Add `fromJson` factory constructor
- [ ] Add `toJson` method

**Hint**: Copy the structure from the example in `lib/features/learning/models/user_model.dart`

<details>
<summary>Click to see solution (try yourself first!)</summary>

```dart
class SimpleUser {
  final int id;
  final String name;
  final String email;

  SimpleUser({
    required this.id,
    required this.name,
    required this.email,
  });

  factory SimpleUser.fromJson(Map<String, dynamic> json) {
    return SimpleUser(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
    };
  }
}
```
</details>

---

### Task 2.2: Create a Simple Repository ⏱️ 20 minutes

Create a repository that fetches users from JSONPlaceholder.

- [ ] Create file: `lib/features/practice/repositories/simple_user_repository.dart`
- [ ] Create `SimpleUserRepository` class
- [ ] Add method `Future<List<SimpleUser>> getUsers()`
- [ ] Use `http.get()` to fetch from `https://jsonplaceholder.typicode.com/users`
- [ ] Parse JSON and return list of `SimpleUser` objects
- [ ] Add error handling with try-catch

<details>
<summary>Click to see solution</summary>

```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/simple_user.dart';

class SimpleUserRepository {
  final http.Client httpClient;

  SimpleUserRepository({required this.httpClient});

  Future<List<SimpleUser>> getUsers() async {
    try {
      final response = await http.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = json.decode(response.body);
        return jsonList.map((json) => SimpleUser.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load users: ${response.statusCode}');
      }
    } catch (e) {
      print('Error in getUsers: $e');
      rethrow;
    }
  }
}
```
</details>

---

### Task 2.3: Create Providers ⏱️ 15 minutes

Create providers for dependency injection.

- [ ] Create file: `lib/features/practice/providers/simple_user_providers.dart`
- [ ] Create `httpClientProvider`
- [ ] Create `simpleUserRepositoryProvider`
- [ ] Create `simpleUsersProvider` (FutureProvider)

<details>
<summary>Click to see solution</summary>

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import '../repositories/simple_user_repository.dart';
import '../models/simple_user.dart';

// HTTP Client Provider
final httpClientProvider = Provider<http.Client>((ref) {
  return http.Client();
});

// Repository Provider
final simpleUserRepositoryProvider = Provider<SimpleUserRepository>((ref) {
  final httpClient = ref.watch(httpClientProvider);
  return SimpleUserRepository(httpClient: httpClient);
});

// Users List Provider
final simpleUsersProvider = FutureProvider<List<SimpleUser>>((ref) async {
  final repository = ref.watch(simpleUserRepositoryProvider);
  return await repository.getUsers();
});
```
</details>

---

### Task 2.4: Create a Simple UI Screen ⏱️ 30 minutes

Create a screen that displays the list of users.

- [ ] Create file: `lib/features/practice/screens/simple_users_screen.dart`
- [ ] Create `SimpleUsersScreen` extending `ConsumerWidget`
- [ ] Use `ref.watch(simpleUsersProvider)` to get data
- [ ] Use `.when()` to handle loading, error, and data states
- [ ] Display users in a `ListView`

<details>
<summary>Click to see solution</summary>

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/simple_user_providers.dart';

class SimpleUsersScreen extends ConsumerWidget {
  const SimpleUsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersAsync = ref.watch(simpleUsersProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Users'),
      ),
      body: usersAsync.when(
        // Loading state
        loading: () => const Center(
          child: CircularProgressIndicator(),
        ),

        // Error state
        error: (error, stackTrace) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error: $error'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  ref.invalidate(simpleUsersProvider);
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),

        // Success state
        data: (users) => ListView.builder(
          itemCount: users.length,
          itemBuilder: (context, index) {
            final user = users[index];
            return ListTile(
              leading: CircleAvatar(
                child: Text(user.name[0]),
              ),
              title: Text(user.name),
              subtitle: Text(user.email),
            );
          },
        ),
      ),
    );
  }
}
```
</details>

---

### Task 2.5: Test Your Screen ⏱️ 10 minutes

- [ ] Add navigation to your screen from somewhere in the app (e.g., from home screen)
- [ ] Run the app
- [ ] Verify users are displayed correctly
- [ ] Test error state by turning off internet
- [ ] Test retry button

**Celebrate!** 🎉 You just made your first API call with Riverpod!

---

## 💪 LEVEL 3: INTERMEDIATE

**Goal**: Add more features and handle complex scenarios

### Task 3.1: Add Pull to Refresh ⏱️ 15 minutes

- [ ] Wrap your `ListView` with `RefreshIndicator`
- [ ] In `onRefresh`, invalidate the provider
- [ ] Test pull-to-refresh functionality

**Hint**:
```dart
RefreshIndicator(
  onRefresh: () async {
    ref.invalidate(simpleUsersProvider);
  },
  child: ListView.builder(...),
)
```

---

### Task 3.2: Create a User Detail Screen ⏱️ 45 minutes

Create a screen that shows details of a single user.

- [ ] Create a provider with `.family` to fetch a single user by ID
- [ ] Create `UserDetailScreen` that takes `userId` as parameter
- [ ] Display user details (name, email, phone, website)
- [ ] Add a back button
- [ ] Navigate to this screen when user taps a user in the list

**Provider Hint**:
```dart
final userDetailProvider = FutureProvider.family<SimpleUser, int>((ref, userId) async {
  final repository = ref.watch(simpleUserRepositoryProvider);
  return await repository.getUser(userId);
});
```

**Repository Method**:
```dart
Future<SimpleUser> getUser(int id) async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/users/$id'),
  );

  if (response.statusCode == 200) {
    return SimpleUser.fromJson(json.decode(response.body));
  } else {
    throw Exception('User not found');
  }
}
```

---

### Task 3.3: Add a Search Feature ⏱️ 1 hour

Create a search bar that filters users by name.

- [ ] Add a `TextField` for search input
- [ ] Create a `StateProvider` for search query
- [ ] Create a provider that filters users based on search query
- [ ] Update UI to use filtered list

**Hint - Search Query Provider**:
```dart
final searchQueryProvider = StateProvider<String>((ref) => '');
```

**Hint - Filtered Users Provider**:
```dart
final filteredUsersProvider = Provider<AsyncValue<List<SimpleUser>>>((ref) {
  final usersAsync = ref.watch(simpleUsersProvider);
  final searchQuery = ref.watch(searchQueryProvider);

  return usersAsync.whenData((users) {
    if (searchQuery.isEmpty) {
      return users;
    }
    return users.where((user) {
      return user.name.toLowerCase().contains(searchQuery.toLowerCase());
    }).toList();
  });
});
```

---

### Task 3.4: Create a Posts Feature ⏱️ 1.5 hours

Create a feature to display posts.

- [ ] Create `Post` model (id, userId, title, body)
- [ ] Create `PostRepository` with `getPosts()` method
- [ ] Create providers for posts
- [ ] Create `PostsScreen` to display posts
- [ ] Show author name for each post (fetch user data)

**API Endpoint**: `https://jsonplaceholder.typicode.com/posts`

---

### Task 3.5: Add Loading State with StateNotifier ⏱️ 1 hour

Replace FutureProvider with StateNotifierProvider for more control.

- [ ] Create a state class: `UsersState` with loading, data, and error states
- [ ] Create `UsersNotifier extends StateNotifier<UsersState>`
- [ ] Add methods: `loadUsers()`, `refresh()`
- [ ] Update UI to use the new provider

**State Class Hint**:
```dart
class UsersState {
  final bool isLoading;
  final List<SimpleUser> users;
  final String? error;

  UsersState({
    required this.isLoading,
    required this.users,
    this.error,
  });

  UsersState.initial()
      : isLoading = false,
        users = [],
        error = null;

  UsersState.loading()
      : isLoading = true,
        users = [],
        error = null;

  UsersState.data(this.users)
      : isLoading = false,
        error = null;

  UsersState.error(this.error)
      : isLoading = false,
        users = [];
}
```

---

## 🔥 LEVEL 4: ADVANCED

**Goal**: Master complex scenarios and best practices

### Task 4.1: Implement Pagination ⏱️ 2 hours

Use ReqRes API which supports pagination.

- [ ] Create models for paginated response
- [ ] Create repository method that accepts page number
- [ ] Create StateNotifier to manage pagination state
- [ ] Implement "Load More" button or infinite scroll
- [ ] Handle loading states for initial load vs. loading more

**API**: `https://reqres.in/api/users?page=1`

---

### Task 4.2: Implement Login Flow ⏱️ 2 hours

Create a complete login feature.

- [ ] Create login screen with email and password fields
- [ ] Create `AuthRepository` with `login()` method
- [ ] Create `AuthNotifier` to manage auth state
- [ ] Store token in state after successful login
- [ ] Show error messages on failure
- [ ] Navigate to home screen on success

**API**: `https://reqres.in/api/login`

**Test Credentials**:
- Email: `eve.holt@reqres.in`
- Password: any string

---

### Task 4.3: Add Token to Headers ⏱️ 1 hour

Modify repository to include auth token in requests.

- [ ] Create a provider for auth token
- [ ] Modify HTTP client to include token in headers
- [ ] Create an interceptor (or wrapper) for authenticated requests

**Hint**:
```dart
final authTokenProvider = StateProvider<String?>((ref) => null);

final authenticatedClientProvider = Provider<http.Client>((ref) {
  final token = ref.watch(authTokenProvider);
  // Return a custom client that adds token to headers
});
```

---

### Task 4.4: Implement Offline Caching ⏱️ 3 hours

Cache API responses locally.

- [ ] Add `get_storage` or `shared_preferences` package
- [ ] Create a cache service
- [ ] Modify repository to check cache before API call
- [ ] Save API responses to cache
- [ ] Add cache expiration logic

---

### Task 4.5: Create a Product Catalog ⏱️ 3 hours

Build a complete e-commerce product list with search and categories.

- [ ] Use DummyJSON API for products
- [ ] Create Product model
- [ ] Implement category filtering
- [ ] Implement search
- [ ] Add product detail screen with images
- [ ] Add "Add to Cart" functionality (state only, no API)

**APIs**:
- All products: `https://dummyjson.com/products`
- Search: `https://dummyjson.com/products/search?q=phone`
- By category: `https://dummyjson.com/products/category/smartphones`

---

## 🎯 LEVEL 5: EXPERT

**Goal**: Professional-level features

### Task 5.1: Implement Optimistic Updates ⏱️ 2 hours

Update UI immediately, then sync with API.

- [ ] When creating a post, add it to local state immediately
- [ ] Show the post in the list right away
- [ ] Make API call in background
- [ ] If API fails, remove the post and show error
- [ ] If API succeeds, update with real ID from server

---

### Task 5.2: Add Proper Error Types ⏱️ 1.5 hours

Create custom error classes.

- [ ] Create `ApiException` class hierarchy
- [ ] Different exceptions: `NetworkException`, `ServerException`, `ValidationException`
- [ ] Update repositories to throw specific exceptions
- [ ] Update UI to show different messages for different errors

---

### Task 5.3: Add Request Debouncing for Search ⏱️ 1 hour

Prevent too many API calls while user is typing.

- [ ] Use a timer to debounce search input
- [ ] Only make API call 500ms after user stops typing
- [ ] Cancel previous request if new one comes in

---

### Task 5.4: Implement Multi-Step Form ⏱️ 3 hours

Create a signup form with validation.

- [ ] Step 1: Email validation
- [ ] Step 2: Password validation
- [ ] Step 3: Profile info
- [ ] Save progress locally
- [ ] Submit all data at the end
- [ ] Handle API errors at each step

---

### Task 5.5: Build a Complete Feature ⏱️ 5+ hours

Build a complete blog/social media feature with:

- [ ] User authentication (login/logout)
- [ ] List of posts with pagination
- [ ] Create new post
- [ ] Edit existing post
- [ ] Delete post with confirmation
- [ ] Like/unlike posts (state only)
- [ ] Comments section
- [ ] User profiles
- [ ] Pull to refresh
- [ ] Search
- [ ] Error handling
- [ ] Loading states
- [ ] Empty states

---

## ✅ COMPLETION CHECKLIST

Track your overall progress:

- [ ] Completed all Level 1 tasks (Absolute Beginner)
- [ ] Completed all Level 2 tasks (Beginner)
- [ ] Completed all Level 3 tasks (Intermediate)
- [ ] Completed all Level 4 tasks (Advanced)
- [ ] Completed all Level 5 tasks (Expert)

---

## 🎓 FINAL PROJECT

**Build your own app idea using everything you learned!**

Ideas:
- Recipe app (fetch recipes from API)
- Weather app
- News reader
- Movie database browser
- Task manager with sync
- Chat app UI (with fake messages)

---

## 📚 ADDITIONAL CHALLENGES

Once you've completed all tasks:

1. **Refactor**: Go back and improve your earlier code
2. **Test**: Write unit tests for your repositories
3. **Document**: Add comments explaining complex code
4. **Share**: Show your work to others for feedback
5. **Teach**: Help someone else learn what you just learned!

---

## 🎉 CONGRATULATIONS!

If you completed all these tasks, you are now **proficient in API integration with Riverpod!**

You can:
- ✅ Make any type of API call
- ✅ Handle async operations confidently
- ✅ Use Riverpod for state management
- ✅ Apply dependency injection
- ✅ Read and understand API documentation
- ✅ Build production-ready features

**Your job is safe. Your future is bright!** 🌟

---

## 🆘 NEED HELP?

If you get stuck:

1. Re-read the relevant guide
2. Study the example code
3. Check the API documentation
4. Try breaking the problem into smaller pieces
5. Take a break and come back fresh

**Remember**: Struggling is part of learning. Every expert struggled when they started!

You got this! 💪
