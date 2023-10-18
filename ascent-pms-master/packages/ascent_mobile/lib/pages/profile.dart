import 'dart:io';

import 'package:ascent_models/ascent_models.dart';
import 'package:ascent_pms/pages/edit_profile.dart';
import 'package:ascent_pms/pages/settings.dart';
import 'package:ascent_pms/services/user.dart';
import 'package:ascent_pms/util/intersperse.dart';
import 'package:ascent_pms/widgets/async_data_builder.dart';
import 'package:ascent_pms/widgets/logged_out.dart';
import 'package:ascent_pms/widgets/logo.dart';
import 'package:ascent_pms/widgets/popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:oxidized/oxidized.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import 'intro.dart';

const packageId = 'com.ascent.ascent_pms';
const androidStoreLink = 'market://details?id=$packageId';
const shareMessage = '''Checkout the Ascent Property Management App:

https://play.google.com/store/apps/details?id=$packageId''';
const supportPhone = '+919567345740';

Future<void> openSupport() async {
  await launchUrl(
      Uri.parse('https://api.whatsapp.com/send?phone=$supportPhone'),
      mode: LaunchMode.externalApplication);
}

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  static const _gap = 8.0;
  static const _gapWidget = SizedBox(height: _gap);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userServiceProvider);
    return Scaffold(
      appBar: AppBar(
        // only to color the status bar the same as [UserDisplay]
        backgroundColor: lightBlue,
        toolbarHeight: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const UserDisplay(),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 32, 8, 16),
              child: AsyncDataBuilder(
                  user, (user) => buildMainContent(context, user.isSome())),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildMainContent(BuildContext context, bool isLoggedIn) {
    const gap = _gapWidget;

    return Column(
      children: [
        if (isLoggedIn)
          ProfileButtonGroup([
            ProfileButton(
              'Edit Profile',
              Icons.edit_note_rounded,
              callback: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const EditProfilePage(),
                ),
              ),
            ),
            ProfileButton(
              'Settings',
              Icons.settings_rounded,
              callback: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsPage()),
              ),
            ),
          ]),
        gap,
        ProfileButtonGroup([
          const ProfileButton('Help & Support', Icons.call_rounded,
              callback: openSupport),
          ProfileButton('Invite a Friend', Icons.send_rounded, callback: () {
            // NOTE: Might not work properly on iPad:
            // https://github.com/fluttercommunity/plus_plugins/tree/main/packages/share_plus/share_plus#ipad
            Share.share(shareMessage);
          }),
          ProfileButton('Rate Us', Icons.star, callback: () {
            launchUrl(
                Uri.parse(
                  Platform.isAndroid
                      ? androidStoreLink
                      : '', // TODO: Use AppStore bundleId after upload
                ),
                mode: LaunchMode.externalApplication);
          }),
        ]),
        gap,
        ProfileButtonGroup([
          const ProfileButton(
              'Terms & Conditions', Icons.document_scanner), // TODO
          ProfileButton(
            'Privacy Policy',
            Icons.health_and_safety,
            callback: () => launchUrl(
              Uri.parse('https://ascentpms.care/privacy-policy/'),
              mode: LaunchMode.externalApplication,
            ),
          ),
          ProfileButton(
            'About Us',
            Icons.info,
            callback: () => launchUrl(
              Uri.parse('https://ascentpms.care/about/'),
              mode: LaunchMode.externalApplication,
            ),
          ),
        ]),
        gap,
        gap,
        const SocialMediaStrip(),
        gap,
        gap,
        isLoggedIn ? const LogoutButton() : const TakeToLoginPageButton(),
      ],
    );
  }
}

class UserDisplay extends ConsumerWidget {
  const UserDisplay({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userServiceProvider);

    var textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: const BoxDecoration(
        color: lightBlue,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.elliptical(1000, 400),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: AsyncDataBuilder(
            user,
            (user) => Column(children: [
              const Icon(Icons.person_pin, color: lightGold, size: 100),
              Text(
                user.toNullable()?.name ?? 'Not Logged In',
                style: textTheme.titleMedium?.copyWith(color: Colors.white),
              ),
              if (user case Some(some: UserAccountModel(:final phone)))
                Text(
                  phone,
                  style: textTheme.bodyMedium?.copyWith(color: Colors.white),
                ),
            ]),
          ),
        ),
      ),
    );
  }
}

class ProfileButtonGroup extends StatelessWidget {
  final List<ProfileButton> buttons;

  const ProfileButtonGroup(this.buttons, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: intersperse(
            Divider(
              thickness: 0.8,
              color: Colors.grey.shade300,
            ),
            buttons,
          ).toList(),
        ),
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? iconColor;
  final Function()? callback;

  const ProfileButton(
    this.label,
    this.icon, {
    super.key,
    this.iconColor,
    this.callback,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final font = theme.textTheme.bodyLarge;

    return GestureDetector(
      onTap: callback,
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: font?.fontSize),
          const SizedBox(width: 5),
          Text(label, style: font),
          const Spacer(),
          Icon(
            Icons.chevron_right,
            color: theme.disabledColor,
          )
        ],
      ),
    );
  }
}

class SocialMedia {
  final IconData icon;
  final String url;

  const SocialMedia(this.icon, this.url);
}

class SocialMediaStrip extends StatelessWidget {
  const SocialMediaStrip({super.key});

  static const sites = [
    SocialMedia(
      FontAwesomeIcons.facebook,
      'https://www.facebook.com/people/Ascent-Pmscare/100092470716408/',
    ),
    SocialMedia(
      FontAwesomeIcons.instagram,
      'https://www.instagram.com/ascentpmscare/',
    ),
    SocialMedia(
      FontAwesomeIcons.globe,
      'https://www.ascentpms.care/',
    ),
    SocialMedia(
      FontAwesomeIcons.envelope,
      'mailto:ascentpmscare@gmail.com',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        for (final site in sites)
          GestureDetector(
            onTap: () => launchUrl(
              Uri.parse(site.url),
              mode: LaunchMode.externalApplication,
            ),
            child: FaIcon(site.icon, color: lightBlue),
          )
      ],
    );
  }
}

class LogoutButton extends ConsumerWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return FilledButton.icon(
      icon: const Icon(Icons.logout),
      label: const Text('Logout'),
      onPressed: () async {
        await showPopup(
          context,
          title: 'Logout',
          content: 'Are you sure you want to logout?',
          actions: {
            'Cancel': () => Navigator.of(context).pop(false),
            'Logout': () async {
              await ref.read(userServiceProvider.notifier).logout();
              if (context.mounted) await gotoIntroPage(context);
            },
          },
        );
      },
    );
  }
}
