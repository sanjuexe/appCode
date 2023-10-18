import 'package:ascent_pms/pages/home.dart';
import 'package:ascent_pms/pages/intro.dart';
import 'package:ascent_pms/pages/my_account.dart';
import 'package:ascent_pms/pages/profile.dart';
import 'package:ascent_pms/pages/splash.dart';
import 'package:ascent_pms/repositories/backend.dart';
import 'package:ascent_pms/services/user.dart';
import 'package:ascent_pms/util/colors.dart';
import 'package:ascent_pms/widgets/logo.dart';
import 'package:ascent_utils/ascent_utils.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

final themeData = ThemeData(
  useMaterial3: true,
  fontFamily: 'WorkSans',
  filledButtonTheme: FilledButtonThemeData(
    style: FilledButton.styleFrom(
      backgroundColor: lightGold,
      foregroundColor: const Color(0xff000000),
    ),
  ),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: lighten(lightBlue, 40),
  ),
  textSelectionTheme: TextSelectionThemeData(
    // Overriding the handle color further down the widget tree does not work
    // as of now: https://github.com/flutter/flutter/issues/74890. The default
    // handle color looks out of place in the login screen, therefore override
    // it globally.
    selectionHandleColor: lightGold.withOpacity(0.8),
  ),
  colorScheme: ColorScheme.fromSeed(seedColor: lightGold),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // We have a local copy of the fonts
  // GoogleFonts.config.allowRuntimeFetching = false;

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  await FirebaseMessaging.instance.subscribeToTopic("main");
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  // Splash screen doesn't need any providers
  // ignore: missing_provider_scope
  runApp(MaterialApp(theme: themeData, home: const SplashScreen()));

  final (endpoint, projectId) = await getEndpointAndProjectId();

  runApp(
    ProviderScope(
      overrides: [
        clientProvider.overrideWithValue(buildClient(endpoint, projectId)),
        endpointProvider.overrideWithValue(endpoint),
        projectIdProvider.overrideWithValue(projectId),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Ascent PMS',
        theme: themeData,
        home: const AscentPmsApp(),
      ),
    ),
  );
}

class AscentPmsApp extends ConsumerStatefulWidget {
  const AscentPmsApp({super.key});

  @override
  ConsumerState<AscentPmsApp> createState() => _AscentPmsAppState();
}

class _AscentPmsAppState extends ConsumerState<AscentPmsApp> {
  @override
  void initState() {
    // preload home page data
    // ignore: unused_result
    ref.refresh(bannersProvider);
    // ignore: unused_result
    ref.refresh(getPackagesProvider);
    // ignore: unused_result
    ref.refresh(featuredServicesProvider);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userServiceProvider);
    return user.when(
      loading: () => const SplashScreen(),
      error: (e, __) => const IntroPage(),
      data: (user) => user.when(
        some: (user) => const MainTabbedUI(),
        none: () => const IntroPage(),
      ),
    );
  }
}

class MainTabbedUI extends StatefulWidget {
  const MainTabbedUI({Key? key}) : super(key: key);

  @override
  State<MainTabbedUI> createState() => _MainTabbedUIState();
}

class _MainTabbedUIState extends State<MainTabbedUI> {
  var _navigationIndex = 0;

  final List<Widget> _pages = const [
    HomePage(),
    DashboardPage(),
    ProfilePage(),
  ];

  late final PageController _pageController =
      PageController(initialPage: _navigationIndex);

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_navigationIndex == 0) {
          return true;
        } else {
          // Goto home if back is pressed from any other tab
          gotoPage(0);
          return false;
        }
      },
      child: Scaffold(
          bottomNavigationBar: NavigationBar(
            surfaceTintColor: lightBlue,
            indicatorColor: lightBlue.withOpacity(0.15),
            height: 65,
            onDestinationSelected: gotoPage,
            selectedIndex: _navigationIndex,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.explore_outlined),
                selectedIcon: Icon(Icons.explore, color: lightBlue),
                label: 'Explore',
              ),
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard_rounded, color: lightBlue),
                label: 'Dashboard',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outlined),
                selectedIcon: Icon(Icons.person, color: lightBlue),
                label: 'Profile',
              ),
            ],
          ),
          body: PageView(
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            children: _pages,
          )),
    );
  }

  void gotoPage(int index) {
    setState(() {
      _navigationIndex = index;
      _pageController.animateToPage(
        index,
        duration: const Duration(milliseconds: 600),
        curve: Curves.fastLinearToSlowEaseIn,
      );
    });
  }
}
