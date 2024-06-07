# Change_Password
Change the password in a special way from a project I am working on
This Flutter project implements a ChangePasswordPage that allows users to change their password with validation and server-side update functionality. The page includes password visibility toggles, validation checks for password strength, and integration with an API to update the password.

# Features
Password Validation: Ensures the new password meets the following criteria:

Minimum 8 characters

At least one uppercase letter

At least one lowercase letter

At least one number

At least one special character

Password Visibility Toggle: Users can toggle the visibility of the current, new, and confirm password fields.

Password Update: Sends a request to update the password on the server if all criteria are met.

User Feedback: Provides feedback to the user for successful or failed password updates.


# Packages Used

Flutter Packages

flutter/material.dart: Provides the material design widgets and theme for the Flutter application.

grad project/Pages/Change_ok.dart: Custom page import for navigation after a successful password change.

gradproject/Pages/pref.dart: Handles preference management, such as retrieving the authentication token.

gradproject/Pages/Login (1).dart: Custom login page import for navigation purposes.

# Code Overview

Widgets and State Management

ChangePasswordPage: A StatefulWidget that provides the structure for the password change page.

_ChangePasswordPageState: Manages the state for ChangePasswordPage, including user inputs and validation status.

# Controllers

TextEditingController: Used to manage the text input for current, new, and confirm password fields.

# Validation Logic
  Regular Expressions: Used to validate the password against the defined criteria.
  
    RegExp lengthRegEx = RegExp(r'.{8,}');
    
    RegExp upperCaseRegEx = RegExp(r'[A-Z]');
    
    RegExp lowerCaseRegEx = RegExp(r'[a-z]');
    
    RegExp numberRegEx = RegExp(r'[0-9]');
    
    RegExp specialCharRegEx = RegExp(r'[!@#$%^&*(),.?":{}|<>]');

# Password Update Function

   updatePassword: The Async function sends a PATCH request to the server to update the password.

# Error Handling and User Feedback

   ScaffoldMessenger: Provides feedback to the user for success or error messages.
   
    ScaffoldMessenger.of(context).showSnackBar( SnackBar( content: Text('Failed to update password. Please try again.'),),);




