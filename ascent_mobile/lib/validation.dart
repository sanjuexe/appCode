import 'package:form_validator/form_validator.dart';

final emailValidator = ValidationBuilder(requiredMessage: 'Email is required')
    .email('Enter valid email id')
    .build();

String? phoneValidator(String phone) {
  if (phone.isEmpty) return 'Phone number is required';

  if (!phone.startsWith('+')) {
    return 'Phone number should start with a country code (example +91)';
  }

  if (int.tryParse(phone.substring(1)) == null) {
    return 'Phone number should only contain digits';
  }

  if (phone.substring(3).length < 10) {
    return 'Phone number must have minimum 10 digits';
  }

  return null;
}

final newPasswordValidator =
    ValidationBuilder(requiredMessage: 'Password is required')
        .minLength(8, 'Password must be minimum 8 characters')
        .build();

final newUsernameValidator =
    ValidationBuilder(requiredMessage: 'Username is required')
        .minLength(1, 'Enter valid username')
        .build();
