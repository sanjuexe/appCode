import 'package:ascent_models/ascent_models.dart';
import 'package:ascent_pms/pages/notifications.dart';
import 'package:ascent_pms/pages/profile.dart';
import 'package:ascent_pms/pages/service_status.dart';
import 'package:ascent_pms/repositories/backend.dart';
import 'package:ascent_pms/services/user.dart';
import 'package:ascent_pms/util/colors.dart';
import 'package:ascent_pms/widgets/async_data_builder.dart';
import 'package:ascent_pms/widgets/faint_text.dart';
import 'package:ascent_pms/widgets/heading.dart';
import 'package:ascent_pms/widgets/logged_out.dart';
import 'package:ascent_pms/widgets/logo.dart';
import 'package:ascent_pms/widgets/refreshable_column.dart';
import 'package:ascent_pms/widgets/service_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:oxidized/oxidized.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'no_internet.dart';

part 'my_account.g.dart';

@riverpod
Future<(List<ServicesModel>, List<ServicesModel>)?>
    purchasedAndAdditionalServices(
        PurchasedAndAdditionalServicesRef ref, String userId) async {
  final packagePurchases =
      await ref.read(packagePurchaseHistoryProvider(userId).future);

  final PackagePurchaseHistoryModel activePackage;
  if (packagePurchases.currentlyPurchasedPackage() case Some(:final some)) {
    activePackage = some;
  } else {
    return null;
  }

  final purchasedServices = activePackage.package!.services;
  if (purchasedServices == null) return null;

  final additionalService =
      await ref.read(backendRepositoryProvider).services().then((services) {
    services.removeWhere(
      (s) => purchasedServices.where((ps) => ps.id == s.id).firstOrNull != null,
    );
    return services;
  });

  return (purchasedServices, additionalService);
}

@riverpod
Future<List<ServiceEnquiryModel>> serviceEnquiry(
        ServiceEnquiryRef ref, String userId) =>
    ref.watch(backendRepositoryProvider).serviceEnquiries(userId);

@riverpod
Future<List<ServiceEnquiryModel>> serviceEnquiryByStatus(
  ServiceEnquiryByStatusRef ref,
  String userId,
  String status,
) async {
  final enquiries = await ref.watch(serviceEnquiryProvider(userId).future);

  return [
    for (final e in enquiries)
      if (e.status == status) e
  ];
}

@riverpod
Future<(List<NotificationsModel>, DateTime?)> notifications(
  NotificationsRef ref,
) async {
  final notifsFuture = ref.watch(backendRepositoryProvider).notifications();
  final lastReadFuture =
      ref.watch(accountRepositoryProvider).lastNotificationReadTime();
  final (notifs, lastRead) = await (notifsFuture, lastReadFuture).wait;

  // Sort by most recent date first (descending)
  notifs.sort((a, b) => b.creation_date.compareTo(a.creation_date));
  return (notifs, lastRead);
}

class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({Key? key}) : super(key: key);

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  Widget buildPackageDetails(
    BuildContext context,
    WidgetRef ref,
    AsyncValue<List<PackagePurchaseHistoryModel>> purchases,
  ) {
    return AsyncDataBuilder(
      purchases,
      (purchases) => buildPackageCard(context, purchases),
    );
  }

  Widget buildPackageCard(
    BuildContext context,
    List<PackagePurchaseHistoryModel> purchases,
  ) {
    String? hint;
    String packageText;
    String subtitleText;
    IconData icon;

    final current = purchases.currentlyPurchasedPackage();

    switch (current) {
      case Some(some: final package):
        packageText = package.package?.name ?? 'Package Purchased';
        subtitleText = 'Currently active package';
        icon = Icons.check_circle;

        final formatter = DateFormat('d MMM y');
        final from = formatter.format(package.valid_from);
        final to = formatter.format(package.valid_to);
        hint = '$from To $to';

        break;
      case None():
        if (purchases.hasExpiredPackage()) {
          packageText = 'Package Expired';
          subtitleText = 'Purchase a new package';
          icon = Icons.sync_problem;
        } else if (purchases.hasPendingPackage()) {
          packageText = 'Package Pending';
          subtitleText = 'Package enquiry has been done';
          icon = Icons.pending_actions;
        } else {
          packageText = 'No Active Package';
          subtitleText = 'Purchase a package first';
          icon = Icons.error;
        }
        break;
    }

    final theme = Theme.of(context);
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
      clipBehavior: Clip.hardEdge,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [lightGold, lighten(lightGold, 30)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(packageText, style: theme.textTheme.titleMedium),
                  Text(subtitleText),
                  if (hint != null) ...[
                    Text(
                      hint,
                      style: TextStyle(color: theme.disabledColor),
                    )
                  ]
                ],
              ),
              const Spacer(),
              Icon(icon, color: Colors.white, size: 35)
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    final user = ref.watch(userServiceProvider);

    return Scaffold(
      appBar: AppBar(
        // only to color the status bar the same as [UserDisplay]
        backgroundColor: lightBlue,
        toolbarHeight: 0,
      ),
      body: AsyncDataBuilder(
        user,
        (user) => switch (user) {
          Some(some: final user) => buildLoggedInView(context, ref, user),
          None() => buildLoggedOutView(context),
        },
      ),
    );
  }

  Widget buildLoggedOutView(BuildContext context) {
    return const Column(
      children: [
        SizedBox(height: 15),
        Expanded(
          child: Center(
            child: TakeToLoginPageButton(),
          ),
        ),
      ],
    );
  }

  Widget buildLoggedInView(
    BuildContext context,
    WidgetRef ref,
    UserAccountModel user,
  ) {
    final packagePurchases = ref.watch(packagePurchaseHistoryProvider(user.id));
    final purchasedAndAdditionalServices =
        ref.watch(purchasedAndAdditionalServicesProvider(user.id));

    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildPackageDetails(context, ref, packagePurchases),
        const Heading('Service Status'),
        Row(
          children: [
            Expanded(
              child: ServiceStatusCard(
                title: 'Active',
                enquiries: ref
                    .watch(serviceEnquiryByStatusProvider(user.id, "active")),
                color: const Color(0xFF2A67A0),
              ),
            ),
            Expanded(
              child: ServiceStatusCard(
                title: 'Pending',
                enquiries: ref
                    .watch(serviceEnquiryByStatusProvider(user.id, "pending")),
                color: const Color(0xFF9C5757),
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: ServiceStatusCard(
                title: 'Completed',
                enquiries: ref.watch(
                    serviceEnquiryByStatusProvider(user.id, "completed")),
                color: const Color(0xFF3C832D),
              ),
            ),
            Expanded(
              child: ServiceStatusCard(
                title: 'View All',
                enquiries: ref.watch(serviceEnquiryProvider(user.id)),
                color: darkGold,
              ),
            ),
          ],
        ),
        if (purchasedAndAdditionalServices
                .whenData((d) => d?.$1)
                .whenOrNull(data: (purchased) => purchased?.isNotEmpty) ??
            false) ...[
          const Heading(
            'Purchased Services',
            subtitle: 'Services included in your purchased package',
          ),
          buildServiceGrid(
              purchasedAndAdditionalServices.whenData((d) => d?.$1), context),
        ],
        if (purchasedAndAdditionalServices
                .whenData((d) => d?.$2)
                .whenOrNull(data: (additional) => additional?.isNotEmpty) ??
            false) ...[
          const Heading(
            'Additional Services',
            subtitle: 'Services that can be purchased separately',
          ),
          buildServiceGrid(
              purchasedAndAdditionalServices.whenData((d) => d?.$2), context)
        ],
      ],
    );

    return ProviderRefreshingColumn(
      providers: [
        packagePurchaseHistoryProvider(user.id),
        purchasedAndAdditionalServicesProvider(user.id),
        serviceEnquiryProvider(user.id),
        notificationsProvider,
      ],
      children: [
        const Stack(children: [
          UserDisplay(),
          Positioned(
            top: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(12.0),
              child: NotificationIcon(),
            ),
          )
        ]),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: content,
        ),
      ],
    );
  }

  Widget buildServiceGrid(
    AsyncValue<List<ServicesModel>?> services,
    BuildContext context,
  ) {
    return services.when(
        loading: () => SizedBox(
              height: ServiceGrid.rowHeight(context) * 2,
              child: const Center(child: CircularProgressIndicator()),
            ),
        error: (error, _) => handleNoInternet(error, context),
        data: (services) => services == null
            ? const Center(child: FaintText('No services found'))
            : ServiceGrid(services, ServiceDisplayMode.purchase));
  }
}

class ServiceStatusCard extends StatelessWidget {
  const ServiceStatusCard({
    super.key,
    required this.title,
    required this.color,
    required this.enquiries,
  });

  final String title;
  final AsyncValue<List<ServiceEnquiryModel>> enquiries;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: InkWell(
        onTap: () {
          enquiries.whenData(
            (enquiries) => Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => ServiceStatusListPage(enquiries))),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [color, lighten(color, 40)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.bodyLarge
                        ?.copyWith(color: Colors.white),
                    overflow: TextOverflow.fade,
                    softWrap: false,
                    maxLines: 1,
                  ),
                ),
                CircleAvatar(
                    child: enquiries.when(
                        error: (_, __) => const Text('-'),
                        loading: () => const Padding(
                              padding: EdgeInsets.all(12.0),
                              child: CircularProgressIndicator(
                                  color: Colors.white70),
                            ),
                        data: (e) => Text('${e.length}'))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationIcon extends ConsumerWidget {
  const NotificationIcon({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifsAndLastRead = ref.watch(notificationsProvider);

    Widget icon = const Icon(
      Icons.notifications_outlined,
      color: Colors.white,
      size: 28,
    );

    if (notifsAndLastRead
        case AsyncData(value: (final notifs, final lastRead?))) {
      final unread = notifs.countUnread(lastRead);
      if (unread > 0) {
        icon = Badge(
          backgroundColor: darkGold,
          label: Text('$unread'),
          child: icon,
        );
      }
    }

    return GestureDetector(
        child: CircleAvatar(
            radius: 22, backgroundColor: Colors.white24, child: icon),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => NotificationsPage(notifsAndLastRead)),
          );
        });
  }
}
