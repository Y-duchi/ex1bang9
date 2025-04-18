
import 'package:flutter/material.dart';

class CommunityPage extends StatefulWidget {
  const CommunityPage({super.key});

  @override
  State<CommunityPage> createState() => _CommunityPageState();
}

class _CommunityPageState extends State<CommunityPage> {
  final List<String> tabs = ['게시글', '인기글', '내 게시물'];
  String selectedTab = '게시글';
  List<bool> liked = List.filled(10, false);
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF916636);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: Image.asset(
          'assets/images/logo.png',
          height: 50,
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
          IconButton(icon: const Icon(Icons.mail_outline), onPressed: () {}),
          IconButton(icon: const Icon(Icons.shopping_cart_outlined), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          // 검색창
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: SizedBox(
              height: 50,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: '검색어를 입력하세요',
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // 탭 메뉴
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: tabs.map((tab) {
                final isSelected = tab == selectedTab;
                return GestureDetector(
                  onTap: () => setState(() => selectedTab = tab),
                  child: Container(
                    margin: const EdgeInsets.only(right: 20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          tab,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: isSelected ? activeColor : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          width: 40,
                          height: 2,
                          color: isSelected ? activeColor : Colors.transparent,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          const Divider(height: 1),
          const SizedBox(height: 8),

          // 게시글 목록
          Expanded(
            child: ListView.separated(
              itemCount: 10,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) => _buildPostItem(index),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostItem(int index) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 제목 + 이미지
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 텍스트 부분
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('제목', style: TextStyle(fontWeight: FontWeight.bold)),
                  SizedBox(height: 4),
                  Text('내용 미리보기'),
                  SizedBox(height: 4),
                  Text('2025.01.28'),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // 이미지
            Container(
              width: 80,
              height: 80,
              color: Colors.grey[300],
              child: const Icon(Icons.image, size: 40),
            ),
          ],
        ),

        const SizedBox(height: 4),

        // 몇 분 전 / 조회수 + 아이콘 줄
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('몇 분 전 / 조회수', style: TextStyle(color: Colors.grey, fontSize: 12)),
            Row(
              children: [
                const Icon(Icons.comment, size: 16),
                const SizedBox(width: 4),
                const Text('0', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      liked[index] = !liked[index];
                    });
                  },
                  child: Icon(
                    liked[index] ? Icons.favorite : Icons.favorite_border,
                    size: 16,
                    color: liked[index] ? Colors.red : Colors.black,
                  ),
                ),
                const SizedBox(width: 4),
                const Text('0', style: TextStyle(fontSize: 12)),
                const SizedBox(width: 8),
                const Icon(Icons.report_gmailerrorred_outlined, size: 16),
              ],
            ),
          ],
        ),

        const SizedBox(height: 12),
        const Divider(height: 1),
      ],
    );
  }
}
