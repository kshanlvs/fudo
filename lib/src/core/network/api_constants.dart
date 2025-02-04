import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiEndpoints {
  static final String baseUrl = dotenv.env['BASE_URL'] ?? 'https://default-url.com';
  static const String getFoodItems = '/foodItems';
  static const String getCategories = '/categories';
  // Add other endpoints here
}
