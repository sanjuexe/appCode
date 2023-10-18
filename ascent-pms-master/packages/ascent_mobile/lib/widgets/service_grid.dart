import 'package:ascent_models/ascent_models.dart';
import 'package:ascent_pms/pages/my_account.dart';
import 'package:ascent_pms/pages/profile.dart';
import 'package:ascent_pms/pages/sellable_description.dart';
import 'package:ascent_pms/pages/service_status.dart';
import 'package:ascent_pms/repositories/backend.dart';
import 'package:ascent_pms/services/user.dart';
import 'package:ascent_pms/widgets/async_data_builder.dart';
import 'package:ascent_pms/widgets/booking_button.dart';
import 'package:ascent_pms/widgets/popup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'service_grid.g.dart';

enum ServiceDisplayMode { details, purchase }

class ServiceGrid extends StatelessWidget {
  final List<ServicesModel> services;
  final ServiceDisplayMode displayMode;

  const ServiceGrid(this.services, this.displayMode, {super.key});

  static const columnCount = 3;

  // Approx height, assuming that each grid cell is a square.
  static rowHeight(BuildContext context) =>
      MediaQuery.of(context).size.width / columnCount;

  @override
  Widget build(BuildContext context) {
    final grid = GridView.count(
      crossAxisCount: columnCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: services
          .map((s) => SellableTile(
                title: s.name,
                imageId: s.image_id,
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => switch (displayMode) {
                      ServiceDisplayMode.details => ServiceDescriptionPage(s),
                      ServiceDisplayMode.purchase => ServiceBookingPage(s),
                    },
                  ),
                ),
              ))
          .toList(),
    );
    return grid;

    // return Container(
    //   decoration: const BoxDecoration(
    //     borderRadius: BorderRadius.all(Radius.circular(16)),
    //     boxShadow: [
    //       BoxShadow(color: Colors.grey),
    //       BoxShadow(
    //         color: Colors.white,
    //         spreadRadius: 3.0,
    //         blurRadius: 7.0,
    //       ),
    //     ],
    //   ),
    //   child: grid,
    // );
  }
}

class ServiceDescriptionPage extends ConsumerWidget {
  final ServicesModel service;
  const ServiceDescriptionPage(this.service, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: SellableDescription(
            imageId: service.image_id,
            title: '${service.name} Service',
            shortDescription: service.short_description,
            longDescription: service.long_description,
          ),
        ),
      ),
    );
  }
}

@riverpod
Future<List<ServiceEnquiryModel>> serviceEnquiryFor(
  ServiceEnquiryForRef ref,
  String serviceId,
) async {
  final maybeUser = await ref.watch(userServiceProvider.future);
  if (maybeUser.isNone()) return [];
  final user = maybeUser.unwrap();

  final enquiries = await ref.watch(serviceEnquiryProvider(user.id).future);
  return [
    for (final enq in enquiries)
      if (enq.service?.id == serviceId) enq
  ];
}

class ServiceBookingPage extends ConsumerStatefulWidget {
  const ServiceBookingPage(this.service, {super.key});
  final ServicesModel service;

  @override
  ConsumerState<ServiceBookingPage> createState() => _ServiceBookingPageState();
}

class _ServiceBookingPageState extends ConsumerState<ServiceBookingPage> {
  DateTime deliveryDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Service Booking'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              SellableDescription.buildImageAndHeading(
                context,
                '${widget.service.name} Service',
                widget.service.image_id,
              ),
              const SizedBox(height: 16),
              buildHistory(context),
              const SizedBox(height: 16),
              buildCalendarDatePicker(),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: buildButtonRow(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ConstrainedBox buildHistory(BuildContext context) {
    return ConstrainedBox(
      constraints:
          BoxConstraints(maxHeight: MediaQuery.of(context).size.height / 6),
      child: AsyncDataBuilder(
        ref.watch(serviceEnquiryForProvider(widget.service.id)),
        (service) => service.isEmpty
            ? const SizedBox.shrink()
            : CupertinoScrollbar(child: ServiceStatusList(service)),
        flexLoading: false,
      ),
    );
  }

  CalendarDatePicker buildCalendarDatePicker() {
    return CalendarDatePicker(
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      onDateChanged: (date) => setState(() => deliveryDate = date),
    );
  }

  Row buildButtonRow(BuildContext context) {
    return Row(children: [
      const Expanded(
        child: Align(
          alignment: Alignment.centerLeft,
          child: IconButton(
            icon: Icon(Icons.headset_mic, size: 40),
            onPressed: openSupport,
          ),
        ),
      ),
      Expanded(
        child: BookingButton(onPressed: (user) async {
          await ref.read(backendRepositoryProvider).createServiceEnquiry(
                userId: user.id,
                serviceId: widget.service.id,
                enquiryDate: DateTime.now(),
                expectedDeliveryDate: deliveryDate,
              );
          if (context.mounted) {
            // We don't await the popup so that the loading icon stops
            // before the popup is shown.
            // ignore: unawaited_futures
            showOkPopup(
              context,
              'Request for booking service sent successfully.',
            );
          }
        }),
      ),
    ]);
  }
}
