import 'package:TFA/l10n/app_localizations.dart';
import 'package:TFA/screens/flight/flight_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (RouteSettings settings) =>
          MaterialPageRoute(builder: (_) => const _SearchContent()),
    );
  }
}

class _SearchContent extends ConsumerStatefulWidget {
  const _SearchContent();

  @override
  ConsumerState<_SearchContent> createState() => _SearchContentState();
}

class _SearchContentState extends ConsumerState<_SearchContent> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final AppLocalizations text = AppLocalizations.of(context)!;
    final ColorScheme cs = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          text.search,
          style: TextStyle(color: cs.onPrimary, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
        backgroundColor: cs.primary,
        elevation: 0,
      ),
      body: Column(
        children: <Widget>[
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) =>
                FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.0, 0.1),
                      end: Offset.zero,
                    ).animate(animation),
                    child: child,
                  ),
                ),
            child: const FlightPage(key: ValueKey(0)),
          ),
          const SizedBox(height: 50),
        ],
      ),
    );
  }
}
