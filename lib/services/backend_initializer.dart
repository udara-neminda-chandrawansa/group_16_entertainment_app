import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseInitializer {
  static Future<void> initialize() async {
    await Supabase.initialize(
      url: 'https://nzkxkiobcvdsdjlthjtd.supabase.co',
      anonKey:
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6Im56a3hraW9iY3Zkc2RqbHRoanRkIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MzUzNzg1MTAsImV4cCI6MjA1MDk1NDUxMH0.RPT2E9NFxpE9fym4i1Jk8m3_Hj59pS4uaJC_prKieU8',
    );
  }
}
