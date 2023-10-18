import 'package:ascent_models/ascent_models.dart';
import 'package:ascent_pms/pages/my_account.dart';
import 'package:ascent_pms/repositories/backend.dart';
import 'package:ascent_pms/widgets/async_data_builder.dart';
import 'package:ascent_pms/widgets/faint_text.dart';
import 'package:ascent_pms/widgets/svg_from_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class NotificationsPage extends ConsumerStatefulWidget {
  const NotificationsPage(this.notifications, {super.key});

  final AsyncValue<(List<NotificationsModel>, DateTime?)> notifications;

  @override
  ConsumerState<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends ConsumerState<NotificationsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) {
        ref.read(accountRepositoryProvider).markNotificationRead();
        ref.invalidate(notificationsProvider);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: AsyncDataBuilder(
          widget.notifications,
          (n) => buildListView(n.$1, n.$2),
        ),
      ),
    );
  }

  Widget buildListView(
    List<NotificationsModel> notifications,
    DateTime? lastRead,
  ) {
    if (notifications.isEmpty) {
      return const Center(child: FaintText('No notifications'));
    }

    final formatter = DateFormat('d MMM y');
    return ListView.builder(
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notif = notifications[index];

        return Card(
          child: ListTile(
            title: Row(
              children: [
                Expanded(
                  child: Text(
                    notif.title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(formatter.format(notif.creation_date),
                    style: Theme.of(context).textTheme.bodySmall)
              ],
            ),
            subtitle:
                notif.image_id != null ? SvgFromId(notif.image_id!) : null,
          ),
        );
      },
    );
  }
}
