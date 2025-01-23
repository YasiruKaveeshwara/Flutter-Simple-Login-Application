import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/api_service.dart';
import '../db/db_helper.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  // API and DB helpers
  final ApiService _apiService = ApiService();
  final DBHelper _dbHelper = DBHelper();

  // Login function with improved error handling
  void _login() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        final response = await _apiService.login(
          _usernameController.text.trim(),
          _passwordController.text.trim(),
        );

        if (response['Status_Code'] == 200) {
          // Extract user data from the response
          final user = response['Response_Body'][0];

          // Validate user data before inserting into the database
          if (user['User_Code'] != null &&
              user['User_Display_Name'] != null &&
              user['Email'] != null &&
              user['User_Employee_Code'] != null &&
              user['Company_Code'] != null) {
            // Save or update user data in SQLite
            await _dbHelper.upsertUser({
              'user_code': user['User_Code'],
              'display_name': user['User_Display_Name'],
              'email': user['Email'],
              'employee_code': user['User_Employee_Code'],
              'company_code': user['Company_Code'],
            });

            // Save login state in SharedPreferences
            final prefs = await SharedPreferences.getInstance();
            await prefs.setBool('isLoggedIn', true);
            await prefs.setString('userCode', user['User_Code']); 

            _showToast("Login Successful!", Colors.green);

            // Navigate to the home screen
            Navigator.pushReplacementNamed(context, '/home');
          } else {
            _showToast(
                "Invalid user data received from the server.", Colors.red);
          }
        } else if (response['Status_Code'] == 401) {
          // Handle incorrect username or password
          _showToast("Incorrect username or password.", Colors.red);
        } else {
          // Handle other API errors
          _showToast(
              response['Message'] ?? "An unknown error occurred.", Colors.red);
        }
      } catch (error) {
        // Display any unhandled errors
        _showToast("An error occurred: $error", Colors.red);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Helper method to display a toast message
  void _showToast(String message, Color color) {
    Fluttertoast.showToast(
      msg: message,
      backgroundColor: color,
      textColor: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 50),
                Center(
                  child: Text(
                    dotenv.env['APP_NAME'] ?? "Welcome",
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                TextFormField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    labelText: "Username",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: const Icon(Icons.person),
                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Username is required.";
                    }
                    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                        .hasMatch(value)) {
                      return "Enter a valid email address.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    prefixIcon: const Icon(Icons.lock),
                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return "Password is required.";
                    }
                    if (value.length < 6) {
                      return "Password must be at least 6 characters.";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: _isLoading ? null : _login,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    backgroundColor: Colors.lightBlue,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        )
                      : const Text(
                          "Login",
                          style: TextStyle(fontSize: 18, color: Colors.white),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
