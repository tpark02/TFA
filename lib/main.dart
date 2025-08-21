import 'package:TFA/screens/auth.dart';
import 'package:TFA/screens/menu.dart';
import 'package:TFA/theme/app_theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final String raw = await rootBundle.loadString('assets/data/airports.csv');
  debugPrint("🧪 CSV line count: ${raw.split('\n').length}");

  WidgetsFlutterBinding.ensureInitialized(); // ✅ required for plugins

  runApp(const ProviderScope(child: App()));
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TFA',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, // light/dark based on OS
      localizationsDelegates: const <LocalizationsDelegate>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('en'),
      ], // or [Locale('ko')] for Korean

      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (BuildContext ctx, AsyncSnapshot<User?> snapshot) {
          if (snapshot.hasData) {
            return const CupertinoScaffold(body: MenuScreen());
          }

          return const CupertinoScaffold(body: AuthScreen());
          // return const MenuScreen();
        },
      ),
    );
  }
}
