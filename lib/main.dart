import 'package:TFA/constants/colors.dart';
import 'package:TFA/screens/auth.dart';
import 'package:TFA/screens/search.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  final raw = await rootBundle.loadString('assets/data/airports.csv');
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
      // theme: ThemeData(
      //   // Define the default brightness and colors.
      //   colorScheme: ColorScheme.fromSeed(
      //     seedColor: Colors.blueAccent,
      //     // ···
      //     // brightness: Brightness.dark,
      //   ),

      //   // Define the default `TextTheme`. Use this to specify the default
      //   // text styling for headlines, titles, bodies of text, and more.
      //   textTheme: TextTheme(
      //     displayLarge: const TextStyle(
      //       fontSize: 72,
      //       fontWeight: FontWeight.bold,
      //     ),
      //     // ···
      //     titleLarge: GoogleFonts.lato(
      //       fontSize: 30,
      //       // fontStyle: FontStyle.italic,
      //     ),
      //     bodyMedium: GoogleFonts.lato(),
      //     displaySmall: GoogleFonts.lato(),
      //   ),
      // ),
      theme: ThemeData(useMaterial3: true, colorScheme: lightColorScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkColorScheme),
      themeMode: ThemeMode.light,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en')], // or [Locale('ko')] for Korean
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return const SearchScreen();
          }

          return const AuthScreen();
          // return const MenuScreen();
        },
      ),
    );
  }
}
