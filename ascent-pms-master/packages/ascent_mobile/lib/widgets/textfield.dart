import 'package:flutter/material.dart';

class LoginTextField {
  static TextField phoneNumber(TextEditingController controller) {
    return TextField(
      keyboardType: TextInputType.phone,
      controller: controller,
      decoration: const InputDecoration(label: Text('Phone Number')),
    );
  }

  static TextField password(TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      decoration: const InputDecoration(label: Text('Password')),
    );
  }

  static TextField username(TextEditingController controller) {
    return TextField(
      keyboardType: TextInputType.name,
      controller: controller,
      decoration: const InputDecoration(label: Text('Username')),
    );
  }

  static TextField email(TextEditingController controller) {
    return TextField(
      keyboardType: TextInputType.emailAddress,
      controller: controller,
      decoration: const InputDecoration(label: Text('Email')),
    );
  }
}
