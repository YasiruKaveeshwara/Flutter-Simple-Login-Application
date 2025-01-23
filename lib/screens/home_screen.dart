import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../db/db_helper.dart';
import '../models/user_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DBHelper _dbHelper = DBHelper();
  UserModel? _user;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  /// Fetch user data from the database and update the UI
  Future<void> _fetchUserData() async {
    try {
      final users = await _dbHelper.getUsers();
      if (users.isNotEmpty) {
        setState(() {
          _user = UserModel.fromMap(users.first);
        });
      } else {
        _showErrorDialog("No user data found.");
      }
    } catch (e) {
      _showErrorDialog("Failed to fetch user data: $e");
    }
  }

  /// Display an error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  /// Logout function to navigate back to the login screen
  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Clear all saved preferences

    // Navigate back to the login screen
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome'),
        backgroundColor: Colors.lightBlue,
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: _user == null
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Welcome, ${_user!.displayName}!",
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: Colors.lightBlue,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.email, color: Colors.lightBlue),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          "Email: ${_user!.email}",
                          style: const TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2, // Wraps to next line if necessary
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.badge, color: Colors.lightBlue),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          "Employee Code: ${_user!.employeeCode}",
                          style: const TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2, // Wraps to next line if necessary
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.domain, color: Colors.lightBlue),
                      const SizedBox(width: 10),
                      Flexible(
                        child: Text(
                          "Company Code: ${_user!.companyCode}",
                          style: const TextStyle(fontSize: 18),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2, // Wraps to next line if necessary
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/database');
                          },
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 20.0,
                            ),
                            backgroundColor: Colors.lightBlue,
                          ),
                          child: const Text(
                            "View Database",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _logout,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 12.0,
                              horizontal: 20.0,
                            ),
                            backgroundColor: Colors.lightBlue,
                          ),
                          child: const Text(
                            "Logout",
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
