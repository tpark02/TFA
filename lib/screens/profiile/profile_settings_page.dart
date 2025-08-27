// lib/screens/profile/profile_settings_page.dart
import 'package:TFA/providers/menu_tab_provider.dart';
import 'package:TFA/screens/profiile/currency_selector_sheet.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileSettingsPage extends ConsumerWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account', style: TextStyle(color: Colors.white)),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        children: <Widget>[
          const _SectionHeader('Profile'),

          const _Login(),
          Divider(height: 0, color: Colors.grey.shade200),

          _CurrencyRow(),
          Divider(height: 0, color: Colors.grey.shade200),

          const _SectionHeader('App'),
          const _SimpleItem(title: 'About'),
          Divider(height: 0, color: Colors.grey.shade200),

          const _SimpleItem(title: 'Share'),
          Divider(height: 0, color: Colors.grey.shade200),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Login extends ConsumerStatefulWidget {
  const _Login({super.key});

  @override
  ConsumerState<_Login> createState() {
    return _LoginState();
  }
}

class _LoginState extends ConsumerState<_Login> {
  @override
  Widget build(BuildContext context) {
    Color color = Theme.of(context).colorScheme.primary;

    return ListTile(
      leading: Icon(Icons.person, color: color),
      title: Text(
        "${FirebaseAuth.instance.currentUser != null ? FirebaseAuth.instance.currentUser!.email : "N/A"}",
        style: TextStyle(color: color, fontWeight: FontWeight.bold),
      ),
      trailing: OutlinedButton(
        style: OutlinedButton.styleFrom(
          backgroundColor: color,
          side: BorderSide(color: color),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        onPressed: () {
          // ref.read(flightSearchProvider.notifier).clearRecentSearches();
          ref.read(menuTabProvider.notifier).state = MenuTab.home;
          FirebaseAuth.instance.signOut();
        },
        child: const Text('Logout', style: TextStyle(color: Colors.white)),
      ),
    );
  }
}

class _CurrencyRow extends ConsumerStatefulWidget {
  _CurrencyRow({super.key});
  Currency _currentCurrency = const Currency(
    name: 'Australian Dollar',
    code: 'AUD',
    symbol: 'A\$',
  );
  @override
  ConsumerState<_CurrencyRow> createState() {
    return _CurrencyRowState();
  }
}

class _CurrencyRowState extends ConsumerState<_CurrencyRow> {
  Future<void> _openCurrencyDialog() async {
    final chosen = await showDialog<Currency>(
      context: context,
      barrierDismissible: true,
      builder: (_) => CurrencySelectorSheet(
        currencies: const [
          Currency(name: 'Australian Dollar', code: 'AUD', symbol: 'A\$'),
          Currency(name: 'Brazilian Real', code: 'BRL', symbol: 'R\$'),
          Currency(name: 'Canadian Dollar', code: 'CAD', symbol: 'CA\$'),
          Currency(name: 'Euro', code: 'EUR', symbol: '€'),
          Currency(name: 'Hong Kong Dollar', code: 'HKD', symbol: 'HK\$'),
          Currency(name: 'Indian Rupee', code: 'INR', symbol: '₹'),
          Currency(name: 'Malaysian Ringgit', code: 'MYR', symbol: 'RM'),
          Currency(name: 'Mexican Peso', code: 'MXN', symbol: 'MX\$'),
        ],
        selectedCode: widget._currentCurrency.code,
      ),
    );
    if (chosen != null) {
      setState(() => widget._currentCurrency = chosen);
    }
  }

  @override
  Widget build(BuildContext context) {
    final c = widget._currentCurrency;
    Color color = Theme.of(context).colorScheme.primary;
    return ListTile(
      leading: Icon(Icons.attach_money, color: color),
      title: Text(c.name, style: TextStyle(color: color)),
      subtitle: Text('${c.symbol} (${c.code})', style: TextStyle(color: color)),
      onTap: _openCurrencyDialog, // open by tapping the row
      trailing: IconButton(
        icon: Icon(Icons.edit_outlined, color: color),
        onPressed: _openCurrencyDialog, // or by tapping the edit icon
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      color: Colors.grey.shade100,
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.w800,
          color: Colors.black87,
        ),
      ),
    );
  }
}

class _SimpleItem extends StatelessWidget {
  final String title;
  const _SimpleItem({required this.title});
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      onTap: () {},
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
