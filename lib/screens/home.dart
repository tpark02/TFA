import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const TextField(
          decoration: InputDecoration(
            hintText: 'Where do you want to go?',
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 🟦 Horizontal destination categories
            SizedBox(
              height: 90,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  categoryChip("Spotlight"),
                  categoryChip("Seoul"),
                  categoryChip("Porto Dale"),
                  categoryChip("New York"),
                  categoryChip("Ulsan"),
                ],
              ),
            ),

            // 🟦 Promotion Box
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Introducing', style: TextStyle(fontSize: 12)),
                        SizedBox(height: 4),
                        Text(
                          'Skiplagged Guarantee',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Automatic protection included with every ticket at no extra cost.',
                          style: TextStyle(fontSize: 12),
                        ),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: null,
                          child: Text('Learn More'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      'assets/images/chat.png',
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
            ),

            // 🟦 Deals Section
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                'Great Deals',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 250,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 16),
                children: [
                  dealCard(
                    title: 'From Montreal to Bogota',
                    date: 'Mon, Sep 22',
                    imageUrl: '',
                    originalPrice: '₩325,808',
                    discountPrice: '₩255,101',
                  ),
                  dealCard(
                    title: 'From Manaus to Lima',
                    date: 'Tue, Oct 16',
                    imageUrl: '',
                    originalPrice: '₩412,000',
                    discountPrice: '₩322,800',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget categoryChip(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 72,
      child: Column(
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundImage: AssetImage('assets/images/chat.png'),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(fontSize: 12),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget dealCard({
    required String title,
    required String date,
    required String imageUrl,
    required String originalPrice,
    required String discountPrice,
  }) {
    return Container(
      width: 200,
      margin: const EdgeInsets.only(right: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  'assets/images/chat.png',
                  width: double.infinity,
                  height: 120,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  child: const Text('Skiplagging'),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  child: Text(
                    '$originalPrice → $discountPrice',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
