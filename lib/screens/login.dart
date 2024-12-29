// imports
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import '../main.dart';
import '../screens/signup.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

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
                .select('username, password, points')
                .filter('username', 'eq', username)
                .filter('password', 'eq', password)
                .single(); // Use .single() to retrieve a single user

        // Check if the sign-in was successful
        if (response.isNotEmpty) {
          // User is logged in successfully, navigate to HomePage
          print('Logged in successfully: $username');
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => HomePage()),
          );
        } else {
          // Handle invalid credentials or errors
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Login Failed!")));
        }
      } catch (e) {
        // Handle any other errors
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Login Failed - Error: ${e.toString()}')),
        );
      }
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
                      'Tech Quiz',
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
                      prefixIcon: const Icon(Icons.email_outlined),
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
