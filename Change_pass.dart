import 'package:flutter/material.dart';
import 'package:gradproject/Pages/Change_ok.dart';
import 'package:gradproject/Pages/pref.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:gradproject/Pages/Login%20(1).dart';

class ChangePasswordPage extends StatefulWidget {
  @override
  _ChangePasswordPageState createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _showCurrentPassword = false;
  bool _showNewPassword = false;
  bool _showConfirmPassword = false;

  bool _isPasswordValid = false;

  bool _isMinLengthChecked = false;
  bool _isUpperCaseChecked = false;
  bool _isLowerCaseChecked = false;
  bool _isSpecialCharChecked = false;
  bool _isNumberChecked = false;

  void _validatePassword(String value) {
    // Regular expressions to check for password requirements
    RegExp lengthRegEx = RegExp(r'.{8,}');
    RegExp upperCaseRegEx = RegExp(r'[A-Z]');
    RegExp lowerCaseRegEx = RegExp(r'[a-z]');
    RegExp numberRegEx = RegExp(r'[0-9]');
    RegExp specialCharRegEx = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

    setState(() {
      _isPasswordValid = lengthRegEx.hasMatch(value) &&
          upperCaseRegEx.hasMatch(value) &&
          lowerCaseRegEx.hasMatch(value) &&
          numberRegEx.hasMatch(value) &&
          specialCharRegEx.hasMatch(value);

      _isMinLengthChecked = lengthRegEx.hasMatch(value);
      _isUpperCaseChecked = upperCaseRegEx.hasMatch(value);
      _isLowerCaseChecked = lowerCaseRegEx.hasMatch(value);
      _isSpecialCharChecked = specialCharRegEx.hasMatch(value);
      _isNumberChecked = numberRegEx.hasMatch(value);
    });
  }

  Future<void> updatePassword() async {
    String currentPassword = currentPasswordController.text;
    String newPassword = newPasswordController.text;
    String confirmPassword = confirmPasswordController.text;

    // Retrieve authentication token from preferences
    String? authToken = Prefs.getString('token');

    if (authToken == null) {
      // If authentication token is null, user is not logged in
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('You are not logged in! Please log in to get access.'),
        ),
      );
      return;
    }

    final url =
        Uri.parse('https://doctorz.onrender.com/api/v1/auth/updateMyPassword');

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $authToken',
    };

    final body = jsonEncode({
      "passwordCurrent": currentPassword,
      "password": newPassword,
      "passwordConfirm": confirmPassword
    });

    try {
      final response = await http.patch(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const passChanged()),
        );
      } else {
        // Failed to update password
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to update password. Please try again.'),
          ),
        );
      }
    } catch (error) {
      // An error occurred while updating password
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('An error occurred while updating password.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: Icon(Icons.arrow_back_ios),
        title: Text(
          'Change Password',
          style: TextStyle(fontWeight: FontWeight.w500),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 35.0, left: 20, right: 20),
          child: Theme(
            data: ThemeData(
              inputDecorationTheme: InputDecorationTheme(
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff3E8989)),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff3E8989)),
                ),
                errorBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xff3E8989)),
                ),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: currentPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Current Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showCurrentPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _showCurrentPassword = !_showCurrentPassword;
                        });
                      },
                    ),
                  ),
                  obscureText: !_showCurrentPassword,
                ),
                SizedBox(height: 25),
                TextFormField(
                  controller: newPasswordController,
                  decoration: InputDecoration(
                    labelText: 'New Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showNewPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _showNewPassword = !_showNewPassword;
                        });
                      },
                    ),
                    suffix: _showNewPassword
                        ? Icon(
                            _isPasswordValid
                                ? Icons.check_circle
                                : Icons.error_outline,
                            color: _isPasswordValid
                                ? Color(0xff3E8989)
                                : Colors.red,
                          )
                        : null,
                  ),
                  obscureText: !_showNewPassword,
                  onChanged: _validatePassword,
                ),
                SizedBox(height: 25),
                TextFormField(
                  controller: confirmPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Confirm New Password',
                    suffixIcon: IconButton(
                      icon: Icon(
                        _showConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _showConfirmPassword = !_showConfirmPassword;
                        });
                      },
                    ),
                  ),
                  obscureText: !_showConfirmPassword,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 40.0),
                  child: Text(
                    'Password should contain :',
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _isMinLengthChecked,
                              onChanged: null,
                              activeColor: Colors.green,
                              fillColor: MaterialStateProperty.all(
                                  _isMinLengthChecked
                                      ? Color(0xff3E8989)
                                      : Colors.grey),
                              shape: CircleBorder(),
                              checkColor: Colors.white,
                            ),
                            Text('Min 8 characters'),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _isUpperCaseChecked,
                              onChanged: null,
                              activeColor: Colors.green,
                              fillColor: MaterialStateProperty.all(
                                  _isUpperCaseChecked
                                      ? Color(0xff3E8989)
                                      : Colors.grey),
                              shape: CircleBorder(),
                              checkColor: Colors.white,
                            ),
                            Text('Upper case letter'),
                          ],
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                              value: _isLowerCaseChecked,
                              onChanged: null,
                              activeColor: Colors.green,
                              fillColor: MaterialStateProperty.all(
                                  _isLowerCaseChecked
                                      ? Color(0xff3E8989)
                                      : Colors.grey),
                              shape: CircleBorder(),
                              checkColor: Colors.white,
                            ),
                            Text('Lower case letter'),
                          ],
                        ),
                        Row(
                          children: [
                            Checkbox(
                              value: _isSpecialCharChecked,
                              onChanged: null,
                              activeColor: Colors.green,
                              fillColor: MaterialStateProperty.all(
                                  _isSpecialCharChecked
                                      ? Color(0xff3E8989)
                                      : Colors.grey),
                              shape: CircleBorder(),
                              checkColor: Colors.white,
                            ),
                            Text('Special character'),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.only(left: 111.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _isNumberChecked,
                        onChanged: null,
                        activeColor: Colors.green,
                        fillColor: MaterialStateProperty.all(
                            _isNumberChecked ? Color(0xff3E8989) : Colors.grey),
                        shape: CircleBorder(),
                        checkColor: Colors.white,
                      ),
                      Text('Number'),
                    ],
                  ),
                ),
                SizedBox(height: 45),
                ElevatedButton(
                  onPressed: _isPasswordValid ? updatePassword : null,
                  child: Text(
                    'Update Password',
                    style: TextStyle(
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(70, 50), // Adjust the width
                    backgroundColor: _isPasswordValid
                        ? Color(0xff3E8989)
                        : Colors.red, // Change color to red
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
