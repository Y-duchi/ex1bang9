import 'package:flutter/material.dart';

class UsedTradePage extends StatefulWidget {
  const UsedTradePage({Key? key}) : super(key: key);

  @override
  State<UsedTradePage> createState() => _UsedTradePageState();
}

class _UsedTradePageState extends State<UsedTradePage> {
  final categories = [
    '조명', '소파', '책상', '의자', '침대',
    '옷장', '선반', '식탁', '화장대', '잡화',
  ];

  final categoryIcons = [
    Icons.light_mode,
    Icons.weekend,
    Icons.table_bar,
    Icons.chair_alt,
    Icons.bed,
    Icons.checkroom,
    Icons.view_module,
    Icons.dining,
    Icons.bathroom,
    Icons.dashboard_customize,
  ];

  int? selectedCategoryIndex;
  String selectedTab = '중고거래';
  List<bool> liked = List.filled(10, false);

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
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          // 검색창
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              height: 50,
              child: TextField(
                decoration: InputDecoration(
                  hintText: '검색어를 입력하세요',
                  prefixIcon: const Icon(Icons.search),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 12),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ),
          ),

          // 탭 메뉴
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => selectedTab = '중고거래'),
                  child: Column(
                    children: [
                      Text(
                        '중고거래',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedTab == '중고거래' ? activeColor : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 2,
                        width: 60,
                        color: selectedTab == '중고거래' ? activeColor : Colors.transparent,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => setState(() => selectedTab = '나눔페이지'),
                  child: Column(
                    children: [
                      Text(
                        '나눔페이지',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedTab == '나눔페이지' ? activeColor : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 2,
                        width: 60,
                        color: selectedTab == '나눔페이지' ? activeColor : Colors.transparent,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // 카테고리 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 5,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
              ),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final isSelected = selectedCategoryIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedCategoryIndex = index;
                    });
                  },
                  child: FittedBox(
                    child: Column(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFEBD19C) : Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.brown.shade300),
                          ),
                          child: Center(
                            child: Icon(
                              categoryIcons[index],
                              size: 28,
                              color: Colors.brown.shade700,
                            ),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          categories[index],
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // 필터 버튼
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4),
            child: Row(
              children: [
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.filter_list),
                  label: const Text("필터링"),
                ),
                const SizedBox(width: 25),
                TextButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.terrain),
                  label: const Text("지역 필터링"),
                ),
              ],
            ),
          ),

          // 상품/나눔 리스트
          ListView.builder(
            itemCount: 10,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80,
                          height: 80,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image, size: 40),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('이름${selectedTab == '나눔페이지' ? '1' : ''}',
                                  style: const TextStyle(fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              if (selectedTab == '중고거래') ...[
                                const Text('가격'),
                                const SizedBox(height: 8),
                              ],
                              const Text('몇 분 전'),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.report),
                                  color: Colors.brown,
                                  onPressed: () {},
                                  iconSize: 24,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  icon: Icon(
                                    liked[index] ? Icons.favorite : Icons.favorite_border,
                                    color: liked[index] ? Colors.red : Colors.black,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      liked[index] = !liked[index];
                                    });
                                  },
                                  iconSize: 24,
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                ),
                              ],
                            ),
                            const SizedBox(height: 36),
                            const Text(
                              '조회수 좋아요수',
                              style: TextStyle(color: Colors.grey, fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}