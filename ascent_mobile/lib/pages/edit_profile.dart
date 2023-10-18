import 'package:ascent_models/ascent_models.dart';
import 'package:ascent_pms/pages/loading_button.dart';
import 'package:ascent_pms/pages/onboarding_page.dart';
import 'package:ascent_pms/services/user.dart';
import 'package:ascent_pms/widgets/async_data_builder.dart';
import 'package:ascent_pms/widgets/popup.dart';
import 'package:ascent_pms/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditProfilePage extends ConsumerWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return OnboardingPage(
      title: 'Edit Profile',
      form: AsyncDataBuilder(
        ref.watch(userServiceProvider),
        (user) => EditProfileForm(
            user.unwrap()), // TODO: accept user as arg to page constructor
        flexLoading: false,
      ),
    );
  }
}

class EditProfileForm extends ConsumerStatefulWidget {
  const EditProfileForm(this.user, {super.key});

  final UserAccountModel user;

  @override
  ConsumerState<EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends ConsumerState<EditProfileForm> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void initState() {
    nameController.text = widget.user.name;
    emailController.text = widget.user.email;
    phoneController.text = widget.user.phone;
    super.initState();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        LoginTextField.username(nameController),
        const SizedBox(height: 15),
        LoginTextField.email(emailController),
        const SizedBox(height: 15),
        LoginTextField.phoneNumber(phoneController),
        const SizedBox(height: 20),
        LoadingButton(
          'Save',
          ref.watch(userServiceProvider).isLoading,
          () => onSave(context),
        ),
      ],
    );
  }

  void onSave(BuildContext context) {
    // Show a dialog to ask for the user's password.
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Enter Your Password"),
          content: LoginTextField.password(passwordController),
          actions: [
            TextButton(
              child: const Text("Cancel"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text("Save"),
              onPressed: () async {
                Navigator.of(context).pop();

                final name = widget.user.name == nameController.text
                    ? null
                    : nameController.text;
                final phone = widget.user.phone == phoneController.text
                    ? null
                    : phoneController.text;
                final email = widget.user.email == emailController.text
                    ? null
                    : emailController.text;

                final result =
                    await ref.read(userServiceProvider.notifier).editProfile(
                          name: name,
                          phone: phone,
                          email: email,
                          password: passwordController.text,
                        );
                if (result.isErr() && context.mounted) {
                  await showOkPopup(context, result.unwrapErr());
                  return;
                }
              },
            ),
          ],
        );
      },
    );
  }
}
