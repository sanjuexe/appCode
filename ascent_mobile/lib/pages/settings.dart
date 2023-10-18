import 'package:ascent_models/ascent_models.dart';
import 'package:ascent_pms/pages/intro.dart';
import 'package:ascent_pms/repositories/backend.dart';
import 'package:ascent_pms/services/user.dart';
import 'package:ascent_pms/widgets/async_data_builder.dart';
import 'package:ascent_pms/widgets/popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  Widget buildSettingsUi(
    BuildContext context,
    WidgetRef ref,
    UserAccountModel user,
  ) {
    var theme = Theme.of(context);
    var textTheme = theme.textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        GestureDetector(
          onTap: () => onDeleteAccount(
              context, user, ref.read(accountRepositoryProvider)),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Icon(Icons.delete_sweep, color: Colors.red.shade700),
                  const SizedBox(width: 5),
                  Text('Delete Account', style: textTheme.bodyLarge),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Icon(
                        Icons.chevron_right,
                        color: theme.disabledColor,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
      ],
    );
  }

  void onDeleteAccount(
    BuildContext context,
    UserAccountModel user,
    AccountRepository accountRepository,
  ) {
    showPopup(
      context,
      content: 'Are you sure you want to delete your account?',
      actions: {
        'Cancel': () => Navigator.of(context).pop(),
        'Delete': () async {
          await accountRepository.delete();
          if (context.mounted) await gotoIntroPage(context);
        },
      },
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: AsyncDataBuilder(
              user,
              (user) => user.when(
                  some: (user) => buildSettingsUi(context, ref, user),
                  none: () => Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Text(
                              'Not logged in',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                          ),
                        ),
                      ))),
        ),
      ),
    );
  }

  Widget makeSubTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        color: Colors.blue,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
