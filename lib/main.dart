import 'package:flutter/material.dart';
import 'package:group_16_entertainment_app/screens/login.dart';
import 'package:group_16_entertainment_app/services/database_handler.dart';

Future<void> main() async {
  // initialize Flutter widgets binding ()
  WidgetsFlutterBinding.ensureInitialized();
  // initialize Supabase
  SupabaseInitializer.initialize();
  // run the app
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Quiz App - Group 16",
      theme: ThemeData.light(), // change theme here
      home: LoginPage(), // Set LoginPage as the home screen
    );
  }
}
