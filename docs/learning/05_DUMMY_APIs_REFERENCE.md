# 🌐 DUMMY APIs FOR LEARNING

> **Free APIs for Practice!** No API keys, no signup, just code and learn!

---

## 🎯 APIs WE'LL USE

We'll use these **FREE** public APIs for learning:

1. **JSONPlaceholder** - General purpose (users, posts, comments, todos)
2. **ReqRes** - Authentication simulation (login, signup, users)
3. **DummyJSON** - E-commerce (products, cart, auth)

**All of these are FREE and don't require API keys!** ✅

---

## 1️⃣ JSONPLACEHOLDER

**Base URL**: `https://jsonplaceholder.typicode.com`

**What it's good for**: Learning basic CRUD operations

### Available Endpoints

#### GET - Fetch All Users
```
GET https://jsonplaceholder.typicode.com/users
```

**Response**:
```json
[
  {
    "id": 1,
    "name": "Leanne Graham",
    "username": "Bret",
    "email": "Sincere@april.biz",
    "phone": "1-770-736-8031",
    "website": "hildegard.org"
  },
  // ... 9 more users
]
```

**Dart Example**:
```dart
Future<List<User>> getUsers() async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/users'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> jsonList = json.decode(response.body);
    return jsonList.map((json) => User.fromJson(json)).toList();
  } else {
    throw Exception('Failed to load users');
  }
}
```

---

#### GET - Fetch Single User
```
GET https://jsonplaceholder.typicode.com/users/1
```

**Response**:
```json
{
  "id": 1,
  "name": "Leanne Graham",
  "username": "Bret",
  "email": "Sincere@april.biz"
}
```

**Dart Example**:
```dart
Future<User> getUser(int id) async {
  final response = await http.get(
    Uri.parse('https://jsonplaceholder.typicode.com/users/$id'),
  );

  if (response.statusCode == 200) {
    return User.fromJson(json.decode(response.body));
  } else {
    throw Exception('User not found');
  }
}
```

---

#### GET - Fetch Posts
```
GET https://jsonplaceholder.typicode.com/posts
```

**Response**:
```json
[
  {
    "userId": 1,
    "id": 1,
    "title": "sunt aut facere repellat",
    "body": "quia et suscipit\nsuscipit recusandae..."
  },
  // ... 99 more posts
]
```

---

#### GET - Fetch User's Posts
```
GET https://jsonplaceholder.typicode.com/posts?userId=1
```

**Query parameter**: `userId=1` filters posts by user

---

#### POST - Create New Post
```
POST https://jsonplaceholder.typicode.com/posts
Content-Type: application/json

{
  "title": "My New Post",
  "body": "This is the content",
  "userId": 1
}
```

**Response**:
```json
{
  "id": 101,
  "title": "My New Post",
  "body": "This is the content",
  "userId": 1
}
```

**Dart Example**:
```dart
Future<Post> createPost(Post post) async {
  final response = await http.post(
    Uri.parse('https://jsonplaceholder.typicode.com/posts'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'title': post.title,
      'body': post.body,
      'userId': post.userId,
    }),
  );

  if (response.statusCode == 201) {
    return Post.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to create post');
  }
}
```

---

#### PUT - Update Post (Replace Completely)
```
PUT https://jsonplaceholder.typicode.com/posts/1
Content-Type: application/json

{
  "id": 1,
  "title": "Updated Title",
  "body": "Updated content",
  "userId": 1
}
```

---

#### PATCH - Update Post (Partial Update)
```
PATCH https://jsonplaceholder.typicode.com/posts/1
Content-Type: application/json

{
  "title": "Updated Title Only"
}
```

---

#### DELETE - Delete Post
```
DELETE https://jsonplaceholder.typicode.com/posts/1
```

**Response**: `{}` (empty object = success)

---

### Other JSONPlaceholder Endpoints

| Endpoint | Description |
|----------|-------------|
| `/posts` | 100 posts |
| `/comments` | 500 comments |
| `/albums` | 100 albums |
| `/photos` | 5000 photos |
| `/todos` | 200 todos |
| `/users` | 10 users |

---

## 2️⃣ REQRES

**Base URL**: `https://reqres.in/api`

**What it's good for**: Learning authentication flows (login, signup, user management)

### Available Endpoints

#### POST - Login (Simulated)
```
POST https://reqres.in/api/login
Content-Type: application/json

{
  "email": "eve.holt@reqres.in",
  "password": "cityslicka"
}
```

**Success Response** (200):
```json
{
  "token": "QpwL5tke4Pnpja7X4"
}
```

**Error Response** (400):
```json
{
  "error": "Missing password"
}
```

**Dart Example**:
```dart
Future<String> login(String email, String password) async {
  final response = await http.post(
    Uri.parse('https://reqres.in/api/login'),
    headers: {'Content-Type': 'application/json'},
    body: json.encode({
      'email': email,
      'password': password,
    }),
  );

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    return data['token'];
  } else {
    final error = json.decode(response.body);
    throw Exception(error['error']);
  }
}
```

**Valid Test Credentials**:
- Email: `eve.holt@reqres.in`
- Password: Any string (e.g., `cityslicka`)

---

#### POST - Register (Simulated)
```
POST https://reqres.in/api/register
Content-Type: application/json

{
  "email": "eve.holt@reqres.in",
  "password": "pistol"
}
```

**Success Response** (200):
```json
{
  "id": 4,
  "token": "QpwL5tke4Pnpja7X4"
}
```

---

#### GET - List Users (Paginated)
```
GET https://reqres.in/api/users?page=1
```

**Response**:
```json
{
  "page": 1,
  "per_page": 6,
  "total": 12,
  "total_pages": 2,
  "data": [
    {
      "id": 1,
      "email": "george.bluth@reqres.in",
      "first_name": "George",
      "last_name": "Bluth",
      "avatar": "https://reqres.in/img/faces/1-image.jpg"
    },
    // ... more users
  ]
}
```

**Dart Example with Pagination**:
```dart
class UsersResponse {
  final int page;
  final int totalPages;
  final List<User> users;

  UsersResponse({
    required this.page,
    required this.totalPages,
    required this.users,
  });

  factory UsersResponse.fromJson(Map<String, dynamic> json) {
    return UsersResponse(
      page: json['page'],
      totalPages: json['total_pages'],
      users: (json['data'] as List)
          .map((user) => User.fromJson(user))
          .toList(),
    );
  }
}

Future<UsersResponse> getUsers(int page) async {
  final response = await http.get(
    Uri.parse('https://reqres.in/api/users?page=$page'),
  );

  if (response.statusCode == 200) {
    return UsersResponse.fromJson(json.decode(response.body));
  } else {
    throw Exception('Failed to load users');
  }
}
```

---

#### GET - Single User
```
GET https://reqres.in/api/users/2
```

**Response**:
```json
{
  "data": {
    "id": 2,
    "email": "janet.weaver@reqres.in",
    "first_name": "Janet",
    "last_name": "Weaver",
    "avatar": "https://reqres.in/img/faces/2-image.jpg"
  }
}
```

---

#### POST - Create User
```
POST https://reqres.in/api/users
Content-Type: application/json

{
  "name": "John Doe",
  "job": "Developer"
}
```

**Response** (201):
```json
{
  "name": "John Doe",
  "job": "Developer",
  "id": "123",
  "createdAt": "2024-01-15T10:30:00.000Z"
}
```

---

#### PUT - Update User
```
PUT https://reqres.in/api/users/2
Content-Type: application/json

{
  "name": "Jane Smith",
  "job": "Senior Developer"
}
```

---

#### DELETE - Delete User
```
DELETE https://reqres.in/api/users/2
```

**Response**: 204 No Content (success)

---

## 3️⃣ DUMMYJSON

**Base URL**: `https://dummyjson.com`

**What it's good for**: E-commerce features (products, cart, categories)

### Available Endpoints

#### GET - All Products
```
GET https://dummyjson.com/products
```

**Response**:
```json
{
  "products": [
    {
      "id": 1,
      "title": "iPhone 9",
      "description": "An apple mobile...",
      "price": 549,
      "discountPercentage": 12.96,
      "rating": 4.69,
      "stock": 94,
      "brand": "Apple",
      "category": "smartphones",
      "thumbnail": "https://dummyjson.com/image/i/products/1/thumbnail.jpg",
      "images": ["url1", "url2"]
    },
    // ... more products
  ],
  "total": 100,
  "skip": 0,
  "limit": 30
}
```

---

#### GET - Single Product
```
GET https://dummyjson.com/products/1
```

---

#### GET - Search Products
```
GET https://dummyjson.com/products/search?q=phone
```

**Query parameter**: `q=phone` searches for "phone"

---

#### GET - Products by Category
```
GET https://dummyjson.com/products/category/smartphones
```

**Available categories**:
- smartphones
- laptops
- fragrances
- skincare
- groceries
- home-decoration

---

#### GET - All Categories
```
GET https://dummyjson.com/products/categories
```

**Response**:
```json
["smartphones", "laptops", "fragrances", ...]
```

---

#### POST - Login (DummyJSON)
```
POST https://dummyjson.com/auth/login
Content-Type: application/json

{
  "username": "kminchelle",
  "password": "0lelplR"
}
```

**Response**:
```json
{
  "id": 15,
  "username": "kminchelle",
  "email": "kminchelle@qq.com",
  "firstName": "Jeanne",
  "lastName": "Halvorson",
  "gender": "female",
  "image": "https://robohash.org/Jeanne.png?set=set4",
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

**Valid Test Credentials**:
- Username: `kminchelle`
- Password: `0lelplR`

---

#### GET - Cart
```
GET https://dummyjson.com/carts/1
```

**Response**:
```json
{
  "id": 1,
  "products": [
    {
      "id": 1,
      "title": "iPhone 9",
      "price": 549,
      "quantity": 1,
      "total": 549
    }
  ],
  "total": 549,
  "discountedTotal": 549,
  "userId": 1,
  "totalProducts": 1,
  "totalQuantity": 1
}
```

---

## 🎯 QUICK COMPARISON

| API | Best For | Auth Required? | Has Pagination? |
|-----|----------|----------------|-----------------|
| **JSONPlaceholder** | Basic CRUD | ❌ No | ❌ No |
| **ReqRes** | Auth, Pagination | ❌ No (simulated) | ✅ Yes |
| **DummyJSON** | E-commerce, Search | ❌ No (simulated) | ✅ Yes |

---

## 🛠️ COMMON HEADERS FOR ALL APIs

```dart
final headers = {
  'Content-Type': 'application/json',  // Required for POST/PUT/PATCH
  'Accept': 'application/json',        // Optional, but good practice
};
```

---

## 📝 IMPORTANT NOTES

### These APIs are "Fake"!

⚠️ **Important**: These APIs don't actually save data!

```dart
// When you create a post:
POST /posts { "title": "My Post" }
// Response: { "id": 101, "title": "My Post" }

// But immediately fetching it returns 404:
GET /posts/101
// Response: 404 Not Found (because it was never actually saved!)
```

**This is PERFECT for learning!**
- You can practice without worrying about breaking real data
- No cleanup needed
- Unlimited requests

---

## 🚀 NEXT STEPS

Now that you know what APIs are available:

1. Read through the guides in order (01 → 04)
2. Look at the example code in `lib/features/learning/`
3. Complete the tasks in `PROGRESSIVE_LEARNING_TASKS.md`

---

## 📚 ADDITIONAL RESOURCES

- **JSONPlaceholder Guide**: https://jsonplaceholder.typicode.com/guide/
- **ReqRes Documentation**: https://reqres.in/
- **DummyJSON Documentation**: https://dummyjson.com/docs/

---

**You now have everything you need to practice API integration! No excuses! 💪**
