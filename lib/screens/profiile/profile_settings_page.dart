import 'package:TFA/l10n/app_localizations.dart';
import 'package:TFA/providers/menu_tab_provider.dart';
import 'package:TFA/providers/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ProfileSettingsPage extends ConsumerWidget {
  const ProfileSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final mode = ref.watch(themeModeProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.primary,
        foregroundColor: cs.onPrimary, // title & icons color
        title: Text(
          text.account,
          style: TextStyle(color: cs.onPrimary, fontWeight: FontWeight.w600),
        ),
        elevation: 0,
      ),
      body: ListView(
        children: <Widget>[
          _SectionHeader(text.profile),
          const _Login(),
          Divider(height: 0, color: cs.outlineVariant),

          _SectionHeader(text.mode),
          RadioListTile<ThemeMode>(
            title: const Text('Light'),
            value: ThemeMode.light,
            groupValue: mode,
            onChanged: (v) => ref.read(themeModeProvider.notifier).set(v!),
            activeColor: cs.primary,
          ),
          RadioListTile<ThemeMode>(
            title: const Text('Dark'),
            value: ThemeMode.dark,
            groupValue: mode,
            onChanged: (v) => ref.read(themeModeProvider.notifier).set(v!),
            activeColor: cs.primary,
          ),
          RadioListTile<ThemeMode>(
            title: const Text('System'),
            value: ThemeMode.system,
            groupValue: mode,
            onChanged: (v) => ref.read(themeModeProvider.notifier).set(v!),
            activeColor: cs.primary,
          ),
          Divider(height: 0, color: cs.outlineVariant),

          const SizedBox(height: 24),
        ],
      ),
      backgroundColor: cs.surface,
    );
  }
}

class _Login extends ConsumerStatefulWidget {
  const _Login({super.key});

  @override
  ConsumerState<_Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<_Login> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final text = AppLocalizations.of(context)!;
    final user = FirebaseAuth.instance.currentUser;
    final email = user?.email ?? 'N/A';

    return ListTile(
      leading: Icon(Icons.person, color: cs.primary),
      title: Text(
        email,
        style: tt.titleMedium?.copyWith(
          color: cs.onSurface,
          fontWeight: FontWeight.w700,
        ),
        overflow: TextOverflow.ellipsis,
      ),
      trailing: FilledButton(
        style: FilledButton.styleFrom(
          backgroundColor: cs.primary,
          foregroundColor: cs.onPrimary,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
        ),
        onPressed: () async {
          ref.read(menuTabProvider.notifier).state = MenuTab.home;
          await FirebaseAuth.instance.signOut();
        },
        child: Text(text.log_out),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      color: cs.surfaceContainerHighest, // adapts in dark/light
      child: Text(
        title,
        style: tt.titleSmall?.copyWith(
          fontWeight: FontWeight.w800,
          color: cs.onSurfaceVariant,
          letterSpacing: .2,
        ),
      ),
    );
  }
}
