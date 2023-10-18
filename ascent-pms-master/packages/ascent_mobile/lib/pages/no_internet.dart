import 'dart:io';

import 'package:ascent_pms/main.dart';
import 'package:ascent_pms/repositories/backend.dart';
import 'package:ascent_pms/widgets/faint_text.dart';
import 'package:ascent_utils/ascent_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class NoInternetPage extends ConsumerStatefulWidget {
  const NoInternetPage({Key? key}) : super(key: key);

  @override
  ConsumerState<NoInternetPage> createState() => _NoInternetPageState();
}

class _NoInternetPageState extends ConsumerState<NoInternetPage> {
  @override
  Widget build(BuildContext context) {
    final backend = ref.watch(backendRepositoryProvider);

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Column(
              children: [
                Icon(Icons.wifi_off_rounded, size: 150),
                FaintText('Could not connect to server'),
              ],
            ),
            Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
              child: FilledButton(
                child: const Text('Retry'),
                onPressed: () async {
                  try {
                    await backend.banners(); // test the connection
                    if (!mounted) {
                      return;
                    }
                    await Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(
                        builder: (context) => const AscentPmsApp(),
                      ),
                      (route) => false,
                    );
                  } catch (e) {
                    // Any exception here can be swallowed since we can't display
                    // any live data or screens anyway. In case of a SocketException
                    // there is nothing to be done either, maybe except to show a
                    // retry failed message in the future.
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget handleNoInternet(Object err, BuildContext context) {
  if (err is SocketException) {
    logger.w('No internet');
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const NoInternetPage()),
        (route) => false,
      ),
    );
    return const Center(child: FaintText('No Internet Connection'));
  }
  logger.e('Error', error: err);
  return const Center(child: FaintText('An error occured'));
}
