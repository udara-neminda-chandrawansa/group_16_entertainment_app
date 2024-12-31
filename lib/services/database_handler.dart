import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseInitializer {
  static Future<void> initialize() async {
    // Initialize Supabase
    await Supabase.initialize(
      url: 'https://nzkxkiobcvdsdjlthjtd.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im56a3hraW9iY3Zkc2RqbHRoanRkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUzNzg1MTAsImV4cCI6MjA1MDk1NDUxMH0.RPT2E9NFxpE9fym4i1Jk8m3_Hj59pS4uaJC_prKieU8',
    );
  }
}

// method to save the user data in the database
Future<List<Map<String, dynamic>>> saveUser(
  String userId,
  String name,
  String password,
) async {
  // Insert the user data into the database
  final response = await Supabase.instance.client
      .from('users')
      .insert({
        'user_id': userId,
        'username': name,
        'password': password,
        'points': 0,
      })
      .select('user_id');
  return response;
}

// method to get the user data from the database using the username and password
Future<PostgrestMap> getUser(String username, String password) async {
  // Get the user data from the database
  final response =
      await Supabase.instance.client
          .from('users')
          .select('user_id, username, password, points')
          .filter('username', 'eq', username)
          .filter('password', 'eq', password)
          .single(); // Use .single() to retrieve a single user
  return response;
}

// method to get all the users from the database
Future<List<Map<String, dynamic>>> getAllUsers() async {
  final response = await Supabase.instance.client
      .from('users')
      .select('user_id');
  return response;
}
