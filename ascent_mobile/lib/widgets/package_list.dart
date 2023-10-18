import 'package:ascent_models/ascent_models.dart';
import 'package:ascent_pms/pages/sellable_description.dart';
import 'package:ascent_pms/repositories/backend.dart';
import 'package:ascent_pms/widgets/booking_button.dart';
import 'package:ascent_pms/widgets/popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PackageList extends StatelessWidget {
  final List<PackagesModel> packages;

  const PackageList({Key? key, required this.packages}) : super(key: key);

  static height(BuildContext context) => MediaQuery.of(context).size.width / 3;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: packages
          .map((p) => SellableTile(
                title: p.name,
                imageId: p.image_id,
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => PackageBookingPage(p),
                )),
              ))
          .toList(),
    );
  }
}

class PackageBookingPage extends ConsumerWidget {
  final PackagesModel package;
  const PackageBookingPage(this.package, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Package Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: SellableDescription(
                  imageId: package.image_id,
                  title: package.name,
                  shortDescription: package.short_description,
                  longDescription: package.long_description,
                ),
              ),
            ),
            const SizedBox(height: 8),
            BookPackageButton(package),
          ],
        ),
      ),
    );
  }
}

class BookPackageButton extends ConsumerWidget {
  const BookPackageButton(this.package, {super.key});
  final PackagesModel package;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return BookingButton(onPressed: (user) async {
      final purchases =
          await ref.read(packagePurchaseHistoryProvider(user.id).future);
      if (purchases.currentlyPurchasedPackage().isSome()) {
        if (!context.mounted) {
          return;
        }
        await showOkPopup(context, 'A package is already active.');
        return;
      }

      await ref
          .read(backendRepositoryProvider)
          .createPackageEnquiry(user.id, package.id, DateTime.now());

      if (context.mounted) {
        await showOkPopup(
            context, 'Request for booking package sent successfully.');
      }
    });
  }
}
