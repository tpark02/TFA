import 'dart:async';
import 'dart:io';

import 'package:TFA/l10n/app_localizations.dart';
import 'package:TFA/providers/auth_provider.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/providers/flight/flight_search_state.dart';
import 'package:TFA/providers/navigation.dart';
import 'package:TFA/providers/route_observer.dart';
import 'package:TFA/providers/search_runner.dart';
import 'package:TFA/providers/startup_bootstrap.dart';
import 'package:TFA/providers/theme_provider.dart';
import 'package:TFA/screens/auth.dart';
import 'package:TFA/screens/menu.dart';
import 'package:TFA/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // // (Optional) warmup
  // final raw = await rootBundle.loadString('assets/data/airports.csv');
  // debugPrint("🧪 CSV line count: ${raw.split('\n').length}");

  // Create ONE container for the whole app
  final container = ProviderContainer();

  // ✅ Use `listen` (not `listenManual`) on the container you’ll pass to the app
  container.listen<FlightSearchState>(flightSearchProvider, (prev, next) async {
    if (prev == next) return;
    if (next.arrivalAirportCode.toLowerCase() == 'anywhere') return;
    if (!stateReady(next)) return;

    debugPrint('onStart Up : 🌍 Global listener → running search…');
    await SearchRunner(container).runFromState(next);
  }, fireImmediately: false);
  unawaited(runStartupBootstrap(container));

  container.listen<AsyncValue<User?>>(
    authStateProvider,
    (prev, next) async {
      final was = prev?.asData?.value;
      final now = next.asData?.value;

      // ✅ LOGIN: run bootstrap + enable FlightSearch listener
      if (was == null && now != null) {
        debugPrint('👤 Logged in → run bootstrap + enable listeners');

        // run bootstrap
        await runStartupBootstrap(container);

        // attach global flight search listener
        container.listen<FlightSearchState>(flightSearchProvider, (
          prev,
          next,
        ) async {
          if (prev == next) return;
          if (next.arrivalAirportCode.toLowerCase() == 'anywhere') return;
          if (!stateReady(next)) return;
          debugPrint('🌍 Global listener → running search…');
          await SearchRunner(container).runFromState(next);
        }, fireImmediately: false);
      }

      // ✅ LOGOUT: clear state
      if (was != null && now == null) {
        debugPrint('👤 Logged out → clear flight state');
        // container.read(flightSearchProvider.notifier).clearProcessedFlights();
        container.read(flightSearchProvider.notifier).clearAllSearch();
      }
    },
    fireImmediately: true, // handles cold start when already logged in
  );
  // ✅ Pass the SAME container into the widget tree
  runApp(UncontrolledProviderScope(container: container, child: const App()));
}

class App extends ConsumerStatefulWidget {
  const App({super.key});
  @override
  ConsumerState<App> createState() {
    return _AppState();
  }
}

class _AppState extends ConsumerState<App> {
  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(themeModeProvider); // or ref.watch if ConsumerWidget

    return MaterialApp(
      navigatorKey: rootNavigatorKey, // for global navigation
      title: 'TFA',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: mode,
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      navigatorObservers: [appRouteObserver],
      // Define a route for flight list if you used pushNamed above
      // routes: {'/flight_list': (_) => const FlightListPage()},
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snap) {
          if (snap.hasData) {
            return Platform.isAndroid
                ? const MenuScreen()
                : const CupertinoScaffold(body: MenuScreen());
          }
          return Platform.isAndroid
              ? const AuthScreen()
              : const CupertinoScaffold(body: AuthScreen());
        },
      ),
    );
  }
}
