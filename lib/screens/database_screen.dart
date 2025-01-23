import 'package:flutter/material.dart';
import '../db/db_helper.dart';

class DatabaseScreen extends StatefulWidget {
  const DatabaseScreen({super.key});

  @override
  _DatabaseScreenState createState() => _DatabaseScreenState();
}

class _DatabaseScreenState extends State<DatabaseScreen> {
  final DBHelper _dbHelper = DBHelper();
  List<Map<String, dynamic>> _data = [];

  @override
  void initState() {
    super.initState();
    _fetchDatabaseData();
  }

  Future<void> _fetchDatabaseData() async {
    try {
      // Fetch all users from the database
      final users = await _dbHelper.getUsers();

      setState(() {
        _data = users;
      });
    } catch (e) {
      _showErrorDialog("Failed to fetch database data: $e");
    }
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Database Data from SQLite"),
        backgroundColor: Colors.lightBlue,
      ),
      body: _data.isEmpty
          ? const Center(
              child: Text(
                "No data available.",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(10.0),
              itemCount: _data.length,
              itemBuilder: (context, index) {
                final user = _data[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ListTile(
                    title: Text(user['display_name']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Email: ${user['email']}"),
                        Text("User Code: ${user['user_code']}"),
                        Text("Employee Code: ${user['employee_code']}"),
                        Text("Company Code: ${user['company_code']}"),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
