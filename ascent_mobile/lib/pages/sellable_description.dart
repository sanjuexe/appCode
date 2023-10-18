import 'package:ascent_pms/util/colors.dart';
import 'package:ascent_pms/widgets/logo.dart';
import 'package:ascent_pms/widgets/svg_from_id.dart';
import 'package:flutter/material.dart';

class SellableDescription extends StatelessWidget {
  const SellableDescription({
    super.key,
    required this.imageId,
    required this.title,
    required this.shortDescription,
    required this.longDescription,
  });

  final String imageId;
  final String title;
  final String? shortDescription;
  final String? longDescription;

  static Widget buildImageAndHeading(
    BuildContext context,
    String title,
    String imageId,
  ) {
    return Column(children: [
      Align(
        alignment: Alignment.center,
        child: SvgFromId(imageId),
      ),
      const SizedBox(height: 10),
      Text(
        title,
        style: Theme.of(context).textTheme.titleLarge,
        textAlign: TextAlign.center,
      )
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        buildImageAndHeading(context, title, imageId),
        const SizedBox(height: 13),
        if (shortDescription != null)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(shortDescription!),
            ),
          ),
        if (longDescription != null) ...[
          Card(
            color: lighten(lightGold, 79),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  Text(longDescription!),
                ],
              ),
            ),
          ),
        ]
      ],
    );
  }
}

class SellableTile extends StatelessWidget {
  final void Function() onTap;
  final String imageId;
  final String title;

  const SellableTile(
      {required this.imageId,
      required this.onTap,
      super.key,
      required this.title});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(4.0),
        child: Column(
          children: [
            Expanded(flex: 3, child: SvgFromId(imageId)),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(top: 2.0),
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
