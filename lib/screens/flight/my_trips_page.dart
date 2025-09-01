import 'package:TFA/l10n/app_localizations.dart';
import 'package:TFA/models/booking_out.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/providers/menu_tab_provider.dart';
import 'package:TFA/providers/route_observer.dart';
import 'package:TFA/screens/flight/booking_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyTripsPage extends ConsumerStatefulWidget {
  const MyTripsPage({super.key});

  @override
  ConsumerState<MyTripsPage> createState() => _MyTrpPageState();
}

class _MyTrpPageState extends ConsumerState<MyTripsPage> {
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    final text = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: cs.primary,
        elevation: 0,
        centerTitle: true,
        title: Text(
          text.my_trip,
          style: TextStyle(color: cs.onPrimary, fontWeight: FontWeight.w600),
        ),
      ),
      body: _BookingsEmpty(),
    );
  }
}

class _BookingsEmpty extends ConsumerStatefulWidget {
  const _BookingsEmpty({super.key});
  @override
  ConsumerState<_BookingsEmpty> createState() => _BookingEmptyState();
}

class _BookingEmptyState extends ConsumerState<_BookingsEmpty> with RouteAware {
  Future<List<BookingOut>?>? _future;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    appRouteObserver.subscribe(this, ModalRoute.of(context)!);
    _refetch();
  }

  void _refetch() {
    _future = ref
        .read(flightSearchProvider.notifier)
        .fetchBooking(type: 'flight');
    setState(() {}); // rebuild FutureBuilder with new future
  }

  @override
  void didPopNext() => _refetch();
  @override
  void didPush() => _refetch();

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return FutureBuilder<List<BookingOut>?>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<List<BookingOut>?> snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator(color: cs.primary));
        }
        if (snap.hasError) {
          return Center(
            child: Text(
              'Failed: ${snap.error}',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: cs.error),
            ),
          );
        }
        final bookings = snap.data ?? const <BookingOut>[];
        if (bookings.isEmpty) {
          return const _EmptyState();
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: bookings.length,
          separatorBuilder: (_, __) => const SizedBox(height: 12),
          itemBuilder: (_, i) => BookingCard(booking: bookings[i]),
        );
      },
    );
  }
}

class _EmptyState extends ConsumerWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.of(context).size.width;
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.image_outlined, size: 96, color: cs.outlineVariant),
            const SizedBox(height: 24),
            Text(
              "You don't have any past bookings.\nLet's get you flying!",
              textAlign: TextAlign.center,
              style: tt.titleMedium?.copyWith(
                height: 1.35,
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: width * 0.8,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: cs.primary,
                  foregroundColor: cs.onPrimary,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    ref.read(menuTabProvider.notifier).state = MenuTab.search;
                  });
                },
                child: Text(
                  'Search for a flight',
                  style: tt.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
