// imports
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../screens/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

// login page class
class _LoginPageState extends State<LoginPage> {
  // assign a unique identifier to the form
  final _formKey = GlobalKey<FormState>();
  // text controllers
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false; // var to store psw visibility

  // Login function
  void _login() async {
    // this verifies the controls are all filled out
    if (_formKey.currentState!.validate()) {
      // Get the email and password from the controllers
      final username = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      try {
        // Attempt to sign in using Supabase authentication
        final response =
            await Supabase.instance.client
                .from('users') // Replace 'users' with your actual table name
                .select('user_id, username, password, points')
                .filter('username', 'eq', username)
                .filter('password', 'eq', password)
                .single(); // Use .single() to retrieve a single user

        // Check if the sign-in was successful
        if (response.isNotEmpty) {
          var userId = response.values.first;
          var score = response.values.last;
          // User is logged in successfully, navigate to HomePage
          print('Logged in successfully: $username User ID: $userId');
          // save user auth data locally (offline capability)
          saveAuthDataLocally(userId, username, password, score);
          // load home
          Navigator.push(
            context,
            MaterialPageRoute(
              builder:
                  (context) => HomePage(
                    userId: userId,
                    username: username,
                    prevScore: score,
                  ),
            ),
          );
        } else {
          List<Map<String, dynamic>> user = await loadCachedUser();
          if (user.isEmpty) {
            // Handle invalid credentials or errors
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Login Failed!")));
          } else {
            print("Saved user: $user");
          }
        }
      } catch (e) {
        // Handle any other errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Connection Failed - Error: ${e.toString()}')),
        );
        // ** try login using local user data
        List<Map<String, dynamic>> user = await loadCachedUser();
        if (user.isEmpty) {
          // Handle invalid credentials or errors
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Local Login Failed!")));
        } else {
          // validate local user against input
          if (user[0]["username"] == username &&
              user[0]["password"] == password) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text("Local Login Success!")));
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => HomePage(
                      userId: user[0]["user_id"],
                      username: user[0]["username"],
                      prevScore: user[0]["points"],
                    ),
              ),
            );
          }
        }
      }
    }
  }

  // use shared preferences to save auth data locally (offline capability)
  Future<void> saveAuthDataLocally(
    String userId,
    String username,
    String password,
    int score,
  ) async {
    List<Map<String, dynamic>> user = [
      {
        "user_id": userId,
        "username": username,
        "password": password,
        "points": score,
      },
    ];
    try {
      // Save user to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cached_user', jsonEncode(user));
      print("User saved: $user");
    } catch (ex) {
      print(ex.toString());
    }
  }

  // load offline user data
  Future<List<Map<String, dynamic>>> loadCachedUser() async {
    final prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('cached_user');

    if (cachedData != null) {
      List<dynamic> decodedData = jsonDecode(cachedData);
      return decodedData.map((e) => Map<String, dynamic>.from(e)).toList();
    } else {
      return []; // No cached data found
    }
  }

  // building login page
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 32),
                  Center(
                    // show app name as banner text
                    child: const Text(
                      'Tech Quiz Login',
                      style: TextStyle(
                        color: Colors.purpleAccent,
                        fontSize: 30,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Username Input
                  TextFormField(
                    controller: _usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      prefixIcon: const Icon(
                        Icons.supervised_user_circle_outlined,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      // check if user has input data
                      if (value == null || value.isEmpty) {
                        return 'Please enter your username';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16), // spacing
                  // Password Input
                  TextFormField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        // btn to change psw visibity
                        icon: Icon(
                          // icon is changed according to psw visibility
                          _isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            // change psw visibility state
                            _isPasswordVisible = !_isPasswordVisible;
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    obscureText: !_isPasswordVisible,
                    validator: (value) {
                      // check if user has input data
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16), // spacing
                  // Login Button
                  ElevatedButton(
                    onPressed: _login, // call method to login
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Login', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(height: 16), // spacing
                  // Sign Up Option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Don\'t have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            // show sign up page
                            context,
                            MaterialPageRoute(
                              builder: (context) => SignupPage(),
                            ),
                          );
                        },
                        child: const Text('Sign Up'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // Clean up controllers
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
