import 'dart:async';
import 'dart:io';
import 'package:TFA/constants/colors.dart';
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
import 'package:dynamic_color/dynamic_color.dart';
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
  final container = ProviderContainer();

  container.listen<FlightSearchState>(flightSearchProvider, (prev, next) async {
    if (prev == next) return;
    if (next.arrivalAirportCode.toLowerCase() == 'anywhere') return;
    if (!stateReady(next)) return;
    await SearchRunner(container).runFromState(next);
  }, fireImmediately: false);

  unawaited(runStartupBootstrap(container));

  container.listen<AsyncValue<User?>>(authStateProvider, (prev, next) async {
    final was = prev?.asData?.value;
    final now = next.asData?.value;

    if (was == null && now != null) {
      await runStartupBootstrap(container);
      container.listen<FlightSearchState>(flightSearchProvider, (
        prev,
        next,
      ) async {
        if (prev == next) return;
        if (next.arrivalAirportCode.toLowerCase() == 'anywhere') return;
        if (!stateReady(next)) return;
        await SearchRunner(container).runFromState(next);
      }, fireImmediately: false);
    }

    if (was != null && now == null) {
      container.read(flightSearchProvider.notifier).clearAllSearch();
    }
  }, fireImmediately: true);

  runApp(UncontrolledProviderScope(container: container, child: const App()));
}

class App extends ConsumerStatefulWidget {
  const App({super.key});
  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  Widget build(BuildContext context) {
    final mode = ref.watch(themeModeProvider);
    return DynamicColorBuilder(
      builder: (lightDynamic, darkDynamic) {
        final light = Platform.isAndroid && lightDynamic != null
            ? lightDynamic.harmonized()
            : lightColorScheme;
        final dark = Platform.isAndroid && darkDynamic != null
            ? darkDynamic.harmonized()
            : darkColorScheme;

        return MaterialApp(
          navigatorKey: rootNavigatorKey,
          title: 'TFA',
          theme: AppTheme.fromScheme(light),
          darkTheme: AppTheme.fromScheme(dark),
          themeMode: mode,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          navigatorObservers: [appRouteObserver],
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
      },
    );
  }
}
