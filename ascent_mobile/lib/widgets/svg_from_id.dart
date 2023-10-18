import 'package:ascent_pms/repositories/backend.dart';
import 'package:ascent_utils/ascent_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shimmer/shimmer.dart';

class SvgFromId extends ConsumerWidget {
  final String id;
  const SvgFromId(this.id, {super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SvgPicture.network(
      assetUrl(
        id,
        ref.watch(endpointProvider),
        ref.watch(projectIdProvider),
      ),
      placeholderBuilder: (context) => buildShimmer(),
    );
  }

  Shimmer buildShimmer() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade100,
      highlightColor: Colors.grey.shade200,
      child: Container(color: Colors.white, child: const SizedBox.expand()),
    );
  }
}
