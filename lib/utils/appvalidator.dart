import 'dart:math';

import 'package:flutter/material.dart';

class AppValidator{
  final TextEditingController password = TextEditingController();
  final TextEditingController confirmpassword = TextEditingController();

  String? validateUsername(value) {
    if (value!.isEmpty) {
      return 'Please enter a username';
    }
    return null;
  }

  String? validatePassword(value) {
    if (value!.isEmpty) {
      return 'Please enter a password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters ';
    }
    return null;
  }

  String? confirmPassword(value) {
    if (value!.isEmpty) {
      return 'Please re enter a password';
    }
    if (password.text != confirmpassword.text) {
      return 'Password do not match';
    }
    return null;
  }

  String? validateEmail(value) {
    if (value!.isEmpty) {
      return 'Please enter an email';
    }
    RegExp emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegExp.hasMatch(value)) {
      return 'please enter a valid email';
    }
    return null;
  }
  String? isEmptyCheck(value) {
    if (value!.isEmpty) {
      return 'Please fill detail';
    }
    return null;
  }
}