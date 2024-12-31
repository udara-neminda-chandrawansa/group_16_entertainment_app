import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:group_16_entertainment_app/entities/question.dart';

class GameService {
  // url of api endpoint
  final String apiUrl =
      "https://quizapi.io/api/v1/questions?apiKey=Ieaj2jbcNs2s4ijvgnyJTTG76HZzfSyau6A2I2Aj&limit=1";

  // method to fetch a question from the api
  Future<Question?> fetchQuestion(String category, String difficulty) async {
    try {
      // get a response after adding the difficulty and category to the url
      final response = await http.get(
        Uri.parse("$apiUrl&difficulty=$difficulty&category=$category"),
      );
      if (response.statusCode == 200) {
        // decode the response body
        final List<dynamic> data = json.decode(response.body);
        // return the first question from the response
        return data.isNotEmpty ? Question.fromDetailedJson(data[0]) : null;
      } else {
        throw Exception("Failed to load question");
      }
    } catch (e) {
      print("Error fetching question: $e");
      return null;
    }
  }

  // method to save the progress of the user
  Future<void> saveProgress(String userId, int points) async {
    try {
      // Update the points of the user in the database using the user_id
      final response = await Supabase.instance.client
          .from('users')
          .update({'points': points})
          .eq('user_id', userId)
          .select('user_id, points');

      if (response.isEmpty) {
        throw Exception('Error updating points!');
      } else {
        print('Progress saved successfully for user: $userId');
      }
    } catch (e) {
      print('Unexpected error: $e');
      rethrow;
    }
  }
}
