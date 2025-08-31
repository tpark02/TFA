// lib/screens/hotel/hotel_detail_page.dart
import 'package:flutter/material.dart';

class HotelDetailPage extends StatefulWidget {
  const HotelDetailPage({super.key});

  @override
  State<HotelDetailPage> createState() => _HotelDetailPageState();
}

class _HotelDetailPageState extends State<HotelDetailPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _anim;
  bool _descExpanded = false;
  bool _reviewsExpanded = false;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    )..forward();
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    const title = 'Lotte City Hotel Mapo';

    return Scaffold(
      appBar: AppBar(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              'Sep 10 - Sep 11',
              style: theme.textTheme.bodySmall?.copyWith(
                color: cs.onSurfaceVariant,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.ios_share)),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Hero image with rating badge
                Stack(
                  children: [
                    AspectRatio(
                      aspectRatio: 16 / 9,
                      child: Image.asset(
                        'assets/images/room_1.jpg',
                        fit: BoxFit.cover,
                      ),
                    ),
                    const Positioned(
                      left: 16,
                      bottom: 16,
                      child: _ScoreBadge(
                        score: '8.6/10',
                        label: 'Good',
                        sub: '(1,109 reviews)',
                      ),
                    ),
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: FloatingActionButton.small(
                        heroTag: 'gallery',
                        onPressed: () {},
                        child: const Icon(Icons.photo_library_outlined),
                      ),
                    ),
                  ],
                ),

                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  title,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: cs.onSurface,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '467, Gongduk-Dong, Seoul, Republic Of Korea',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: cs.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(Icons.star, size: 0), // spacer
                        ],
                      ),
                      const SizedBox(height: 16),
                      const _AmenitiesRow(),
                      const SizedBox(height: 16),
                      _ExpandableText(
                        text:
                            'Experience an abundance of unparalleled facilities and features at Lotte City Hotel Mapo. Maintain seamless communication using the complimentary Wi-Fi at hotel. For visitors traveling by automobile, complimentary parking is available. During your stay at the property, you can enjoy …',
                        expanded: _descExpanded,
                        onToggle: () =>
                            setState(() => _descExpanded = !_descExpanded),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Rooms
                const _SectionHeader('Rooms'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ScaleTransition(
                    scale: CurvedAnimation(
                      parent: _anim,
                      curve: Curves.easeOutBack,
                    ),
                    child: const _RoomCard(),
                  ),
                ),
                const SizedBox(height: 24),

                // Pricing/Reserve
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.bed_outlined, color: cs.onSurfaceVariant),
                          const SizedBox(width: 8),
                          Text(
                            '1 Double Bed',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurface,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Icon(
                            Icons.info_outline,
                            size: 20,
                            color: cs.onSurfaceVariant,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Fully Refundable until Sep 7, 04:00 am',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: cs.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: cs.surface,
                          border: Border.all(
                            color: cs.primary.withValues(alpha: .35),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          children: [
                            Icon(Icons.info, color: cs.primary),
                            const SizedBox(width: 8),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: cs.onSurface,
                                  ),
                                  children: [
                                    const TextSpan(text: 'You will earn '),
                                    TextSpan(
                                      text: '₩4,897.57',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: cs.tertiary,
                                      ),
                                    ),
                                    const TextSpan(text: ' in rewards! '),
                                    TextSpan(
                                      text: 'More Info',
                                      style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: cs.primary,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '₩150,052',
                                  style: theme.textTheme.headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: cs.onSurface,
                                      ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  '₩174,721',
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: cs.onSurfaceVariant,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '₩199,126 total',
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    decoration: TextDecoration.lineThrough,
                                    color: cs.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 48,
                            child: FilledButton(
                              onPressed: () {},
                              child: const Text('Reserve'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      OutlinedButton(
                        onPressed: () {},
                        child: const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Center(child: Text('Show More Rooms')),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                const _SectionHeader('Guests Reviews'),
                const _ReviewHistogram(),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: _ReviewPreview(
                    expanded: _reviewsExpanded,
                    onToggle: () =>
                        setState(() => _reviewsExpanded = !_reviewsExpanded),
                  ),
                ),
                const SizedBox(height: 24),
                const _SectionHeader('Amenities'),
                const _AmenitiesList(),

                const SizedBox(height: 24),
                const _SectionHeader('Map'),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: AspectRatio(
                      aspectRatio: 16 / 11,
                      child: Image.asset(
                        'assets/images/room_1.jpg',
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: cs.surfaceContainerHigh,
                          alignment: Alignment.center,
                          child: Text(
                            'Map Preview',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: InkWell(
                    onTap: () {},
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        '467, Gongduk-Dong, Seoul',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.w600,
                          color: cs.primary,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpandableText extends StatelessWidget {
  final String text;
  final bool expanded;
  final VoidCallback onToggle;
  const _ExpandableText({
    required this.text,
    required this.expanded,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;
    final style = t.textTheme.bodyMedium?.copyWith(color: cs.onSurface);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedSize(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          child: Text(
            text,
            style: style,
            maxLines: expanded ? null : 3,
            overflow: expanded ? TextOverflow.visible : TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: onToggle,
          child: Text(expanded ? 'Read Less' : 'Read More'),
        ),
      ],
    );
  }
}

class _ScoreBadge extends StatelessWidget {
  final String score;
  final String label;
  final String sub;
  const _ScoreBadge({
    required this.score,
    required this.label,
    required this.sub,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(blurRadius: 10, color: Colors.black.withValues(alpha: .25)),
        ],
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              score,
              style: TextStyle(
                color: cs.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
              Text(
                sub,
                style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AmenitiesRow extends StatelessWidget {
  const _AmenitiesRow();
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Widget item(IconData i, String t) => Column(
      children: [
        Icon(i, size: 28, color: cs.onSurfaceVariant),
        const SizedBox(height: 6),
        Text(t, style: TextStyle(fontSize: 12, color: cs.onSurface)),
      ],
    );
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        item(Icons.wifi, 'Free internet'),
        item(Icons.local_parking, 'Free parking'),
        item(Icons.accessible, 'Handicap accessible'),
        item(Icons.kitchen, 'Kitchen(ette)'),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader(this.title);
  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final cs = t.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
      child: Text(
        title,
        style: t.textTheme.titleLarge?.copyWith(
          fontWeight: FontWeight.w800,
          color: cs.onSurface,
        ),
      ),
    );
  }
}

class _RoomsGuestsBar extends StatelessWidget {
  const _RoomsGuestsBar();
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: cs.outlineVariant),
        ),
        child: Row(
          children: [
            Icon(Icons.search, color: cs.onSurfaceVariant),
            const SizedBox(width: 10),
            Text(
              '1 Room, 2 Guests',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DateBox extends StatelessWidget {
  final String label;
  final String value;
  const _DateBox({required this.label, required this.value});
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(Icons.event_note_outlined, color: cs.onSurfaceVariant),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
              ),
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard();
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;
    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 2,
      color: cs.surface,
      surfaceTintColor: cs.surfaceTint,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.asset(
                  'assets/images/room_1.jpg',
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                left: 16,
                top: 16,
                child: Container(
                  width: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 10,
                        color: Colors.black.withValues(alpha: .25),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 6,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: cs.secondary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                          ),
                        ),
                        child: Text(
                          '14% off',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            color: cs.onSecondary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 10,
                        ),
                        decoration: BoxDecoration(
                          color: cs.error,
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: Text(
                          'Skiplagged Rate',
                          style: TextStyle(
                            color: cs.onError,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 16,
                bottom: 12,
                child: Text(
                  'ACTUAL ROOM MAY VARY',
                  style: tt.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    letterSpacing: .3,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'STANDARD, DOUBLE BED Room Only',
                  style: tt.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: cs.onSurface,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Skiplagged Rate — this rate isn't available anywhere else. The room will be assigned by the hotel at check-in.",
                  style: tt.bodyMedium?.copyWith(color: cs.onSurface),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.bed_outlined, color: cs.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Text(
                      '1 Double Bed',
                      style: tt.bodyMedium?.copyWith(color: cs.onSurface),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: cs.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Fully Refundable until Sep 7, 04:00 am',
                        style: tt.bodyMedium?.copyWith(color: cs.onSurface),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewHistogram extends StatelessWidget {
  const _ReviewHistogram();
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget bar(String label, double value, int right) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: [
            SizedBox(
              width: 86,
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: cs.onSurface,
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  minHeight: 12,
                  value: value,
                  color: cs.primary,
                  backgroundColor: cs.surfaceVariant,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text('$right', style: TextStyle(color: cs.onSurface)),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              _ScoreTile(
                score: '8.6/10',
                label: 'Good',
                sub: '(1,109 reviews)',
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        bar('Exceptional', .78, 5),
        bar('Wonderful', .92, 7),
        bar('Very Good', .55, 3),
        bar('Good', .12, 1),
        bar('Pleasant', .28, 2),
        bar('Fair', .32, 2),
      ],
    );
  }
}

class _ScoreTile extends StatelessWidget {
  final String score;
  final String label;
  final String sub;
  const _ScoreTile({
    required this.score,
    required this.label,
    required this.sub,
  });
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border.all(color: cs.primary.withValues(alpha: .4)),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              color: cs.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              score,
              style: TextStyle(
                color: cs.onPrimary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: cs.onSurface,
                ),
              ),
              Text(
                sub,
                style: TextStyle(fontSize: 12, color: cs.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

Widget _bullet(String text, bool good) {
  return Builder(
    builder: (context) {
      final cs = Theme.of(context).colorScheme;
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Icon(
              good ? Icons.check_circle : Icons.cancel,
              color: good ? cs.tertiary : cs.error,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(text, style: TextStyle(color: cs.onSurface)),
            ),
          ],
        ),
      );
    },
  );
}

class _ReviewPreview extends StatelessWidget {
  final bool expanded;
  final VoidCallback onToggle;
  const _ReviewPreview({required this.expanded, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),

        // Always show first few highlights
        ...[
          'Great location',
          'Good value for money',
          'Friendly staff',
          'Room was well equipped',
          'Spacious rooms',
        ].map((t) => _bullet(t, true)),
        const SizedBox(height: 8),
        ...[
          'Rooms look a bit outdated',
          'Have to pay to use the swimming pool',
        ].map((t) => _bullet(t, false)),

        const SizedBox(height: 16),

        OutlinedButton(
          onPressed: onToggle,
          child: Text(expanded ? 'Hide Reviews' : 'Show More Reviews'),
        ),

        if (expanded) ...[
          const SizedBox(height: 8),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (_, __) => const Divider(height: 24),
            itemBuilder: (_, i) => _SingleReview(index: i + 1),
          ),
          const SizedBox(height: 12),
        ],
      ],
    );
  }
}

class _SingleReview extends StatelessWidget {
  final int index;
  const _SingleReview({required this.index});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reviewer #$index',
            style: TextStyle(fontWeight: FontWeight.bold, color: cs.onSurface),
          ),
          const SizedBox(height: 4),
          Text(
            'This is a detailed review comment explaining their experience at the hotel.',
            style: TextStyle(color: cs.onSurface),
          ),
        ],
      ),
    );
  }
}

class _AmenitiesList extends StatelessWidget {
  const _AmenitiesList();
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    Widget row(IconData i, String t) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(i, size: 28, color: cs.onSurfaceVariant),
          const SizedBox(width: 16),
          Text(t, style: TextStyle(fontSize: 16, color: cs.onSurface)),
        ],
      ),
    );
    return Column(
      children: [
        row(Icons.wifi, 'Free internet'),
        row(Icons.local_parking, 'Free parking'),
        row(Icons.accessible, 'Handicap accessible'),
        row(Icons.kitchen, 'Kitchen(ette)'),
        row(Icons.lock, 'Safe'),
      ],
    );
  }
}

class _BottomBar extends StatelessWidget {
  final ThemeData theme;
  const _BottomBar({required this.theme});
  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_outlined), label: 'Home'),
        NavigationDestination(icon: Icon(Icons.search), label: 'Search'),
        NavigationDestination(
          icon: Icon(Icons.card_travel_outlined),
          label: 'Trips',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          label: 'Account',
        ),
      ],
      selectedIndex: 1,
    );
  }
}
