// lib/screens/hotel/hotel_filter_page.dart
import 'package:TFA/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:TFA/widgets/silvers/section_header.dart';

class HotelFilterResult {
  HotelFilterResult({
    required this.sort,
    required this.pricePerNight,
    required this.userRating,
    required this.star5,
    required this.star4plus,
    required this.hotelName,
    required this.amenities,
  });

  final String sort; // 'price' | 'discount' | 'ranking'
  final RangeValues pricePerNight; // KRW
  final RangeValues userRating; // 0..10
  final bool star5;
  final bool star4plus;
  final String hotelName;
  final Map<String, bool> amenities;
}

class HotelFilterPage extends StatefulWidget {
  const HotelFilterPage({
    super.key,
    required this.scrollController,
    this.initial,
  });

  final ScrollController scrollController;
  final HotelFilterResult? initial;

  @override
  State<HotelFilterPage> createState() => _HotelFilterPageState();
}

class _HotelFilterPageState extends State<HotelFilterPage> {
  // ---- State ----
  late String _sort;
  late RangeValues _price;
  late RangeValues _rating;
  late bool _star5;
  late bool _star4plus;
  late String _hotelName;
  late Map<String, bool> _amenities;

  static const int _visibleAmenities = 9;
  bool _showAllAmenities = false;

  static const List<String> _amenityList = <String>[
    'Airport shuttle',
    'Babysitting',
    'Business center',
    'Children’s activities',
    'Fitness center',
    'Free internet',
    'Free parking',
    'Handicap accessible',
    'Hot tub',
    'Kitchen(ette)',
    'Laundry services',
    'Pets allowed',
    'Pool',
    'Room service',
    'Safe',
  ];

  @override
  void initState() {
    super.initState();
    final HotelFilterResult? init = widget.initial;
    _sort = init?.sort ?? 'discount';
    _price = init?.pricePerNight ?? const RangeValues(34751, 597721);
    _rating = init?.userRating ?? const RangeValues(5, 10);
    _star5 = init?.star5 ?? false;
    _star4plus = init?.star4plus ?? false;
    _hotelName = init?.hotelName ?? '';
    _amenities = <String, bool>{
      for (String e in _amenityList) e: init?.amenities[e] ?? false,
    };
  }

  // ---- Helpers ----
  Widget _padded(Widget child) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: child,
  );

  String _krw(num v) {
    final String s = v.round().toString();
    final StringBuffer buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      buf.write(s[i]);
      final int left = s.length - i - 1;
      if (left > 0 && left % 3 == 0) buf.write(',');
    }
    return '₩${buf.toString()}';
  }

  Widget _radio(String value, String label) {
    return Container(
      color: Colors.white,
      child: RadioListTile<String>(
        value: value,
        groupValue: _sort,
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        onChanged: (String? v) => setState(() => _sort = v!),
        title: Text(label),
      ),
    );
  }

  Widget _rangeTile({
    required String left,
    required String right,
    required RangeValues values,
    required double min,
    required double max,
    required int? divisions,
    required ValueChanged<RangeValues> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        _padded(
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(left, style: const TextStyle(color: Colors.grey)),
              Text(right, style: const TextStyle(color: Colors.grey)),
            ],
          ),
        ),
        RangeSlider(
          min: min,
          max: max,
          divisions: divisions,
          values: values,
          onChanged: (RangeValues v) => onChanged(
            RangeValues(v.start.clamp(min, max), v.end.clamp(min, max)),
          ),
        ),
      ],
    );
  }

  Widget _starRow({
    required String label,
    required int stars,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      color: Colors.white,
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: Checkbox(
          value: value,
          onChanged: (bool? v) => onChanged(v ?? false),
        ),
        title: Text(label),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(
            stars,
            (_) => const Icon(Icons.star, size: 16, color: Colors.orange),
          ),
        ),
        onTap: () => onChanged(!value),
      ),
    );
  }

  Widget _amenityTile(String name) {
    final bool checked = _amenities[name] ?? false;
    return Container(
      color: Colors.white,
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 8),
        leading: Checkbox(
          value: checked,
          onChanged: (bool? v) => setState(() => _amenities[name] = v ?? false),
        ),
        title: Text(name),
        trailing: TextButton(
          onPressed: () {
            setState(() {
              for (final String k in _amenities.keys) {
                _amenities[k] = (k == name);
              }
            });
          },
          child: const Text('only', style: TextStyle(color: Colors.lightBlue)),
        ),
        onTap: () => setState(() => _amenities[name] = !checked),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SliverToBoxAdapter divider = SliverToBoxAdapter(
      child: Container(height: 1, color: const Color(0xFFEAEAEA)),
    );
    final text = AppLocalizations.of(context)!;

    return Scaffold(
      body: CustomScrollView(
        controller: widget.scrollController,
        slivers: <Widget>[
          const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Text(
                'Filters',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          // ---- Sort
          SliverPersistentHeader(
            pinned: true,
            delegate: SectionHeader(text.sort),
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              _padded(_radio('price', 'Price')),
              _padded(_radio('discount', 'Discount')),
              _padded(_radio('ranking', 'Ranking')),
            ]),
          ),
          divider,

          // ---- Price / Night
          SliverPersistentHeader(
            pinned: true,
            delegate: SectionHeader('Price / Night'),
          ),
          SliverToBoxAdapter(
            child: _rangeTile(
              left: _krw(_price.start),
              right: '${_krw(_price.end)}+',
              values: _price,
              min: 0,
              max: 800000,
              divisions: 80,
              onChanged: (RangeValues v) => setState(() => _price = v),
            ),
          ),
          divider,

          // ---- User Rating
          SliverPersistentHeader(
            pinned: true,
            delegate: SectionHeader('User Rating'),
          ),
          SliverToBoxAdapter(
            child: _rangeTile(
              left: '${_rating.start.toInt()}',
              right: '${_rating.end.toInt()}/10',
              values: _rating,
              min: 0,
              max: 10,
              divisions: 10,
              onChanged: (RangeValues v) => setState(() => _rating = v),
            ),
          ),
          divider,

          // ---- Stars
          SliverPersistentHeader(
            pinned: true,
            delegate: SectionHeader('Stars'),
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              _padded(
                _starRow(
                  label: '5 stars',
                  stars: 5,
                  value: _star5,
                  onChanged: (bool v) => setState(() => _star5 = v),
                ),
              ),
              _padded(
                _starRow(
                  label: '4+ stars',
                  stars: 4,
                  value: _star4plus,
                  onChanged: (bool v) => setState(() => _star4plus = v),
                ),
              ),
            ]),
          ),
          divider,

          // ---- Hotel Name
          SliverPersistentHeader(
            pinned: true,
            delegate: SectionHeader('Hotel Name'),
          ),
          SliverToBoxAdapter(
            child: _padded(
              TextField(
                controller: TextEditingController(text: _hotelName)
                  ..selection = TextSelection.collapsed(
                    offset: _hotelName.length,
                  ),
                onChanged: (String v) => _hotelName = v,
                decoration: InputDecoration(
                  hintText: 'Search by name',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          divider,

          // ---- Amenities
          SliverPersistentHeader(
            pinned: true,
            delegate: SectionHeader('Amenities'),
          ),
          SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              ...((_showAllAmenities
                      ? _amenityList
                      : _amenityList.take(_visibleAmenities)))
                  .map((String e) => _padded(_amenityTile(e))),
              if (_amenityList.length > _visibleAmenities)
                Center(
                  child: TextButton(
                    onPressed: () =>
                        setState(() => _showAllAmenities = !_showAllAmenities),
                    child: Text(_showAllAmenities ? 'Show Less' : 'Show More'),
                  ),
                ),
            ]),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 24)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1EA7FD),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                  ),
                  onPressed: () {
                    final Map<String, List<String>> map =
                        <String, List<String>>{
                          'sort': <String>[_sort],
                          'priceStart': <String>[
                            _price.start.toInt().toString(),
                          ],
                          'priceEnd': <String>[_price.end.toInt().toString()],
                          'ratingStart': <String>[_rating.start.toString()],
                          'ratingEnd': <String>[_rating.end.toString()],
                          'star5': <String>[_star5.toString()],
                          'star4plus': <String>[_star4plus.toString()],
                          'hotelName': <String>[_hotelName],
                          'amenities': _amenities.entries
                              .where((MapEntry<String, bool> e) => e.value)
                              .map((MapEntry<String, bool> e) => e.key)
                              .toList(),
                        };

                    Navigator.pop(context, map);
                  },
                  child: const Text(
                    'Done',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
