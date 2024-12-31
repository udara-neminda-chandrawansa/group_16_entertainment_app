import 'package:group_16_entertainment_app/services/database_handler.dart';
import 'login.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  _SignupPageState createState() => _SignupPageState();
}

// sign up page class
class _SignupPageState extends State<SignupPage> {
  // assign a unique identifier to the form
  final _formKey = GlobalKey<FormState>();
  // text controllers
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false; // var to store psw visibility

  void _signup() async {
    // this verifies the controls are all filled out
    if (_formKey.currentState!.validate()) {
      final name = _usernameController.text.trim();
      final password = _passwordController.text.trim();

      try {
        // Get the number of rows in the users table
        final response = await getAllUsers();

        var rowCount = 0;
        var userId = "user_1";

        // if the response is not empty, get the number of rows
        if (response.isNotEmpty) {
          rowCount = response.length;
          // Generate a new user ID based on the number of rows
          userId = 'user_${rowCount + 1}';
        }

        // Insert new user into the database
        final insertResponse = await saveUser(userId, name, password);

        if (insertResponse.isNotEmpty) {
          print('Signed up successfully');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Account created successfully!')),
          );

          // Navigate to the login page
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          );
        } else {
          // Show error message
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Sign up failed!')));
        }
      } catch (e) {
        // Handle any other errors
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error: ${e.toString()}')));
      }
    }
  }

  // build signup page
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
                    // display banner text
                    child: const Text(
                      'Tech Quiz Sign Up',
                      style: TextStyle(color: Colors.blueAccent, fontSize: 30),
                    ),
                  ),
                  const SizedBox(height: 32),
                  // Email Input
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
                        return 'Please enter your email';
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
                          // change psw visibility state
                          setState(() {
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
                        return 'Please enter a password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16), // spacing
                  // Sign Up Button
                  ElevatedButton(
                    onPressed: _signup, // call method to signup
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 16), // spacing
                  // Go back to login Option
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('Already have an account?'),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            // show sign up page
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginPage(),
                            ),
                          );
                        },
                        child: const Text('Login'),
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
