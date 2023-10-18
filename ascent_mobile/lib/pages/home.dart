import 'package:ascent_models/ascent_models.dart';
import 'package:ascent_pms/pages/no_internet.dart';
import 'package:ascent_pms/pages/splash.dart';
import 'package:ascent_pms/repositories/backend.dart';
import 'package:ascent_pms/services/user.dart';
import 'package:ascent_pms/widgets/async_data_builder.dart';
import 'package:ascent_pms/widgets/banner.dart';
import 'package:ascent_pms/widgets/heading.dart';
import 'package:ascent_pms/widgets/package_list.dart';
import 'package:ascent_pms/widgets/refreshable_column.dart';
import 'package:ascent_pms/widgets/service_grid.dart';
import 'package:ascent_pms/widgets/svg_from_id.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:oxidized/oxidized.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:url_launcher/url_launcher.dart';

part 'home.g.dart';

@riverpod
Future<List<BannersModel>> banners(BannersRef ref) async {
  return await ref.watch(backendRepositoryProvider).banners();
}

@riverpod
Future<List<PackagesModel>> getPackages(GetPackagesRef ref) async {
  return await ref.watch(backendRepositoryProvider).homepagePackages();
}

@riverpod
Future<List<ServicesModel>> featuredServices(FeaturedServicesRef ref) async {
  return await ref.watch(backendRepositoryProvider).services();
}

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final user = ref.watch(userServiceProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Welcome!'),
        automaticallyImplyLeading: false,
        actions: [
          if (user case AsyncData(value: Some()))
            Visibility(
              visible: false, // TODO
              child: IconButton(
                icon: const Icon(Icons.notifications),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).push(
                  MaterialPageRoute(builder: (context) => const SplashScreen()),
                ),
              ),
            ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0).copyWith(top: 0),
        child: ProviderRefreshingColumn(
          providers: [
            getPackagesProvider,
            featuredServicesProvider,
            bannersProvider,
          ],
          children: [
            _buildBannerCarousel(context, ref),
            const SizedBox(height: 5),
            const Heading('Our Packages'),
            _buildPackageList(context, ref),
            const Heading('Our Services'),
            _buildServiceGrid(context, ref),
          ],
        ),
      ),
    );
  }

  Widget _buildBannerCarousel(BuildContext context, WidgetRef ref) {
    final banners = ref.watch(bannersProvider);

    return AsyncDataBuilder(
      banners,
      (banners) => banners.isEmpty
          ? const SizedBox.shrink()
          : CarouselWithIndicator([
              for (final b in banners)
                GestureDetector(
                  onTap: () {
                    if (b.action_url != null) {
                      launchUrl(Uri.parse(b.action_url!),
                          mode: LaunchMode.externalApplication);
                    }
                  },
                  child: SvgFromId(b.image_id),
                )
            ]),
    );
  }

  Widget _buildPackageList(BuildContext context, WidgetRef ref) {
    final packages = ref.watch(getPackagesProvider);

    return packages.when(
      loading: () => SizedBox(
        height: PackageList.height(context),
        child: const Center(child: CircularProgressIndicator()),
      ),
      error: (err, stack) => handleNoInternet(err, context),
      data: (packages) => PackageList(packages: packages),
    );
  }

  Widget _buildServiceGrid(BuildContext context, WidgetRef ref) {
    final services = ref.watch(featuredServicesProvider);

    return AsyncDataBuilder(
      services,
      (services) => Padding(
        padding: const EdgeInsets.only(left: 6.0),
        child: ServiceGrid(services, ServiceDisplayMode.details),
      ),
    );
  }
}
