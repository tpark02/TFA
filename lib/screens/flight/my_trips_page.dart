import 'package:TFA/models/booking_out.dart';
import 'package:TFA/providers/flight/flight_search_controller.dart';
import 'package:TFA/providers/route_observer.dart';
import 'package:TFA/widgets/flight/booking_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyTripsPage extends ConsumerStatefulWidget {
  const MyTripsPage({super.key, this.onSearchTap});
  final VoidCallback? onSearchTap;

  @override
  ConsumerState<MyTripsPage> createState() => _MyTrpPageState();
}

class _MyTrpPageState extends ConsumerState<MyTripsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    final onPrimary = Theme.of(context).colorScheme.onPrimary;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        appBar: AppBar(
          backgroundColor: primary,
          elevation: 0,
          centerTitle: true,
          title: Text(
            'Trips',
            style: TextStyle(color: onPrimary, fontWeight: FontWeight.w600),
          ),
          bottom: TabBar(
            indicatorColor: onPrimary,
            indicatorWeight: 3,
            labelColor: onPrimary,
            unselectedLabelColor: onPrimary.withOpacity(0.6),
            tabs: const [
              Tab(text: 'Favorites'),
              Tab(text: 'Bookings'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_FavoritesPlaceholder(), _BookingsEmpty()],
        ),
      ),
    );
  }
}

/// Replace with your real Favorites content.
class _FavoritesPlaceholder extends StatelessWidget {
  const _FavoritesPlaceholder();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('No favorites yet.', style: TextStyle(color: Colors.black54)),
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
    // subscribe to route changes
    appRouteObserver.subscribe(this, ModalRoute.of(context)!);
    // initial fetch (first time page is shown)
    _refetch();
  }

  void _refetch() {
    _future = ref
        .read(flightSearchProvider.notifier)
        .fetchBooking(type: 'flight');
    setState(() {}); // rebuild FutureBuilder with new future
  }

  // Called when a new route above is popped and we become visible again
  @override
  void didPopNext() => _refetch();

  // Optional: also fetch when we’re pushed the first time
  @override
  void didPush() => _refetch();

  @override
  void dispose() {
    appRouteObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<BookingOut>?>(
      future: _future,
      builder: (BuildContext context, AsyncSnapshot<List<BookingOut>?> snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('Failed: ${snap.error}'));
        }
        final bookings = snap.data ?? const <BookingOut>[];
        if (bookings.isEmpty) {
          return _EmptyState(); // your empty UI
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

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final primary = Theme.of(context).colorScheme.primary;
    final btnColor = const Color(0xFF1E9BFF);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Simple placeholder illustration
            const Icon(Icons.image_outlined, size: 96, color: Colors.black12),
            const SizedBox(height: 24),
            const Text(
              "You don't have any past bookings.\nLet's get you flying!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                height: 1.35,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: width * 0.8,
              height: 48,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: btnColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
                onPressed: () {
                  // plug this into your navigator or callback
                  // Navigator.of(context).pushNamed('/flight_search');
                  final parent = context
                      .findAncestorWidgetOfExactType<MyTripsPage>();
                  if (parent is MyTripsPage && parent.onSearchTap != null) {
                    parent.onSearchTap!();
                  }
                },
                child: const Text(
                  'Search for a flight',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
// class _BookingEmptyState extends ConsumerState<_BookingsEmpty> {
//   late FlightSearchController controller;
//   bool _loaded = false;
//   Future<List<BookingOut>?>? _future;

//   @override
//   void initState() {
//     super.initState();
//     controller = ref.read(flightSearchProvider.notifier);
//   }

//   @override
//   void didChangeDependencies() {
//     super.didChangeDependencies();
//     if (_loaded) return; // ✅ run once
//     _loaded = true;

//     _future = ref.read(flightSearchProvider.notifier)
//         .fetchBooking(type: 'flight');

//     setState(() {}); // rebuild to attach FutureBuilder
//   }
//   @override
//   Widget build(BuildContext context) {
//     final width = MediaQuery.of(context).size.width;
//     final primary = Theme.of(context).colorScheme.primary;
//     final btnColor = const Color(0xFF1E9BFF); // bright blue like screenshot

//     return Center(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 24),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             controller.fetchBooking(type: 'flight');
//             // Simple placeholder illustration
//             const Icon(Icons.image_outlined, size: 96, color: Colors.black12),
//             const SizedBox(height: 24),
//             const Text(
//               "You don't have any past bookings.\nLet's get you flying!",
//               textAlign: TextAlign.center,
//               style: TextStyle(
//                 fontSize: 18,
//                 height: 1.35,
//                 fontWeight: FontWeight.w600,
//                 color: Colors.black87,
//               ),
//             ),
//             const SizedBox(height: 24),
//             SizedBox(
//               width: width * 0.8,
//               height: 48,
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: btnColor,
//                   foregroundColor: Colors.white,
//                   elevation: 0,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(6),
//                   ),
//                 ),
//                 onPressed: () {
//                   // plug this into your navigator or callback
//                   // Navigator.of(context).pushNamed('/flight_search');
//                   final parent = context
//                       .findAncestorWidgetOfExactType<MyTripsPage>();
//                   if (parent is MyTripsPage && parent.onSearchTap != null) {
//                     parent.onSearchTap!();
//                   }
//                 },
//                 child: const Text(
//                   'Search for a flight',
//                   style: TextStyle(fontWeight: FontWeight.w700),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
