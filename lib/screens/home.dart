import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.blue[800],
        elevation: 0,
        title: const TextField(
          decoration: InputDecoration(
            hintText: '당신은 어디로 가고 싶나요?',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
            prefixIcon: Icon(Icons.search, color: Colors.white),
          ),
          style: TextStyle(color: Colors.white),
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
                  categoryChip("스포트라이트"),
                  categoryChip("서울"),
                  categoryChip("포르토데일"),
                  categoryChip("뉴욕"),
                  categoryChip("울산"),
                ],
              ),
            ),

            // 🟦 Promotion Box
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('소개합니다', style: TextStyle(fontSize: 12)),
                        SizedBox(height: 4),
                        Text('스킵래그드 보장',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                        SizedBox(height: 8),
                        Text('모든 항공권에 추가 비용 없이 자동 보호 제공.',
                            style: TextStyle(fontSize: 12)),
                        SizedBox(height: 8),
                        ElevatedButton(
                          onPressed: null,
                          child: Text('자세히 알아보기'),
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
                '위대한 거래',
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
                    title: '몬트리올에서 보고타로',
                    date: '9월 22일 월',
                    imageUrl: '',
                    originalPrice: '₩325,808',
                    discountPrice: '₩255,101',
                  ),
                  dealCard(
                    title: '마나우스에서 리마로',
                    date: '10월 16일 화',
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
          Text(label,
              style: const TextStyle(fontSize: 12),
              overflow: TextOverflow.ellipsis),
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
                  color: Colors.redAccent,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: const Text('Skiplagging',
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
              Positioned(
                bottom: 8,
                left: 8,
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: Text(
                    '$originalPrice → $discountPrice',
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text(date, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }
}
