import 'package:ascent_models/ascent_models.dart';
import 'package:ascent_pms/pages/intro.dart';
import 'package:ascent_pms/pages/loading_button.dart';
import 'package:ascent_pms/services/user.dart';
import 'package:ascent_pms/widgets/popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxidized/oxidized.dart';

class BookingButton extends ConsumerStatefulWidget {
  const BookingButton({required this.onPressed, super.key});

  final Future<void> Function(UserAccountModel) onPressed;

  @override
  ConsumerState<BookingButton> createState() => _BookingButtonState();
}

class _BookingButtonState extends ConsumerState<BookingButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userServiceProvider);
    return SizedBox(
      width: double.maxFinite,
      child: LoadingButton(
        'Book Now',
        _isLoading,
        user.whenOrNull(
          data: (user) => () async {
            setState(() => _isLoading = true);
            await _onPressed(context, ref, user);
            setState(() => _isLoading = false);
          },
        ),
      ),
    );
  }

  Future<void> _onPressed(
    BuildContext context,
    WidgetRef ref,
    Option<UserAccountModel> maybeUser,
  ) async {
    if (maybeUser.isNone()) {
      await showOkCancelPopup(context, 'Login or Sign Up to continue',
          onOk: () {
            Navigator.of(context).pop();
            Navigator.of(context, rootNavigator: true).push(
              MaterialPageRoute(
                builder: (context) => const IntroPage(),
              ),
            );
          },
          onCancel: () => Navigator.of(context).pop());
      return;
    }
    await widget.onPressed(maybeUser.unwrap());
  }
}
