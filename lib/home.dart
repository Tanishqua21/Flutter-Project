import 'dart:io';
import 'package:flutter/material.dart';
import 'package:registrationproject/login.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  final Map<String, String?> userData;

  HomePage({Key? key, required this.userData}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Map<String, String?> _userData = {};
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userData = {
        'First Name': prefs.getString('firstName'),
        'Last Name': prefs.getString('lastName'),
        'Father\'s Name': prefs.getString('fatherName'),
        'Mother\'s Name': prefs.getString('motherName'),
        'Date of Birth': prefs.getString('dob'),
        'Gender': prefs.getString('gender'),
        'Category': prefs.getString('category'),
        'Email': prefs.getString('email'),
        'Phone': prefs.getString('phone'),
        'Address': prefs.getString('address'),
      };
      _imagePath = prefs.getString('imagePath');
    });
  }

  Future<void> _logout() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            if (_imagePath != null)
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: FileImage(File(_imagePath!)),
                ),
              ),
            SizedBox(height: 20),
            if (_userData.isNotEmpty) ...[
              for (var entry in _userData.entries)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${entry.key}:',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          entry.value ?? 'Not Provided',
                          style: TextStyle(fontSize: 16),
                          textAlign: TextAlign.end,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ],
        ),
      ),
    );
  }
}
