import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:registrationproject/home.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  GlobalKey<FormState> _formKey = GlobalKey();
  bool isButtonEnabled = false;
  FocusNode focusNode = FocusNode();
  String? _phoneNumber;
  final ImagePicker _picker = ImagePicker();
  String? _selectedImagePath;
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _fatherNameController = TextEditingController();
  final _motherNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();

  DateTime? _dob;
  String? _gender;
  String? _category;
  final _genderOptions = ['Male', 'Female', 'Other'];
  final _categoryOptions = ['General', 'ST', 'SC', 'OBC'];

  Future<void> _selectImage() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Profile Picture'),
          content: Text('Choose an option for your profile picture:'),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _pickImage(ImageSource.gallery);
              },
              child: Text('Gallery'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await _pickImage(ImageSource.camera);
              },
              child: Text('Camera'),
            ),
            if (_selectedImagePath != null)
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  setState(() {
                    _selectedImagePath = null;
                  });
                },
                child: Text(
                  'Remove Picture',
                  style: TextStyle(color: Colors.red),
                ),
              ),
          ],
        );
      },
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    final XFile? pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _selectedImagePath = pickedFile.path;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Registration Page')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: GestureDetector(
                  onTap: _selectImage,
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _selectedImagePath != null
                        ? FileImage(File(_selectedImagePath!))
                        : null,
                    child: _selectedImagePath == null
                        ? Icon(
                      Icons.camera_alt,
                      size: 40,
                      color: Colors.grey[700],
                    )
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _firstNameController,
                decoration: InputDecoration(labelText: 'First Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your first name';
                  }
                  if (!RegExp(r'^[a-zA-Z\s\-]+$').hasMatch(value)) {
                    return 'Please enter a valid first name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(labelText: 'Last Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your last name';
                  }
                  if (!RegExp(r'^[a-zA-Z\s\-]+$').hasMatch(value)) {
                    return 'Please enter a valid last name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _fatherNameController,
                decoration: InputDecoration(labelText: 'Father\'s Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your father\'s name';
                  }
                  if (!RegExp(r'^[a-zA-Z\s\-]+$').hasMatch(value)) {
                    return 'Please enter a valid father\'s name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _motherNameController,
                decoration: InputDecoration(labelText: 'Mother\'s Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your mother\'s name';
                  }
                  if (!RegExp(r'^[a-zA-Z\s\-]+$').hasMatch(value)) {
                    return 'Please enter a valid mother\'s name';
                  }
                  return null;
                },
              ),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  child: TextFormField(
                    decoration: InputDecoration(labelText: 'Date of Birth'),
                    controller: TextEditingController(
                        text: _dob == null ? '' : DateFormat('yyyy-MM-dd')
                            .format(_dob!)
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select your date of birth';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Row(
                children: [
                  Text('Gender:'),
                  for (var option in _genderOptions)
                    Row(
                      children: [
                        Radio<String>(
                          value: option,
                          groupValue: _gender,
                          onChanged: (value) {
                            setState(() {
                              _gender = value;
                            });
                          },
                        ),
                        Text(option),
                      ],
                    ),
                ],
              ),
              DropdownButtonFormField<String>(
                value: _category,
                decoration: InputDecoration(labelText: 'Category'),
                items: _categoryOptions.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _category = value;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  } else
                  if (!RegExp(r'^[a-zA-Z0-9]+@[a-zA-Z]+\.[a-zA-Z]+').hasMatch(
                      value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              IntlPhoneField(
                focusNode: focusNode,
                decoration: InputDecoration(
                  labelText: 'Enter phone number',
                ),
                validator: (value) {
                  if (value == null || value.isValidNumber()) {
                    return 'Please enter a valid phone number';
                  }
                  return null;
                },
                onChanged: (phone) {
                  setState(() {
                    _phoneNumber = phone.completeNumber;
                    isButtonEnabled = phone.completeNumber.length >= 10;
                  });
                },
              ),
              TextFormField(
                controller: _addressController,
                decoration: InputDecoration(labelText: 'Address'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your password';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: _register,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _dob) {
      setState(() {
        _dob = picked;
      });
    }
  }

  Future<void> _register() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('firstName', _firstNameController.text);
      await prefs.setString('lastName', _lastNameController.text);
      await prefs.setString('fatherName', _fatherNameController.text);
      await prefs.setString('motherName', _motherNameController.text);
      await prefs.setString('dob', DateFormat('yyyy-MM-dd').format(_dob!));
      await prefs.setString('gender', _gender ?? '');
      await prefs.setString('category', _category ?? '');
      await prefs.setString('email', _emailController.text);
      await prefs.setString('phone', _phoneNumber ?? '');
      await prefs.setString('address', _addressController.text);
      await prefs.setString('password', _passwordController.text);
      if (_selectedImagePath != null) {
        await prefs.setString('imagePath', _selectedImagePath!);
      }
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomePage(userData: {},)),
      );
    }
  }
}
