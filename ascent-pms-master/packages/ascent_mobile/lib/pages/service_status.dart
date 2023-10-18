import 'package:ascent_models/ascent_models.dart';
import 'package:ascent_pms/widgets/faint_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class ServiceStatusListPage extends ConsumerWidget {
  const ServiceStatusListPage(this.services, {super.key});

  final List<ServiceEnquiryModel> services;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Service Status')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ServiceStatusList(services),
      ),
    );
  }
}

class ServiceStatusList extends StatelessWidget {
  const ServiceStatusList(this.services, {super.key});

  final List<ServiceEnquiryModel> services;

  @override
  Widget build(BuildContext context) {
    if (services.isEmpty) {
      return const Center(child: FaintText('No services found'));
    }

    final formatter = DateFormat('d MMM y');

    return ListView.builder(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];

        final String statusText;
        final Color statusColor;
        switch (service.status) {
          case "active":
            statusText = 'Ongoing';
            statusColor = Colors.red;
            break;
          case 'pending':
            statusText = 'Pending';
            statusColor = Colors.blue;
            break;
          case 'completed':
            statusText = 'Finished';
            statusColor = Colors.green;
            break;
          default:
            statusText = 'Unknown';
            statusColor = Colors.grey;
        }

        final enquirydate = formatter.format(service.enquiry_date);
        final expriryDate = formatter.format(service.expected_delivery_date);
        return Card(
          child: ListTile(
            title: Text(
              service.service!.name,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              'Enquiry Date: $enquirydate\nExpiry Date: $expriryDate',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: Text(statusText, style: TextStyle(color: statusColor)),
          ),
        );
      },
    );
  }
}
