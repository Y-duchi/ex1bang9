
import 'package:flutter/material.dart';
import 'product_detail.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';

class ShoppingPage extends StatefulWidget {
  const ShoppingPage({super.key});

  @override
  State<ShoppingPage> createState() => _ShoppingPageState();
}

class _ShoppingPageState extends State<ShoppingPage> {
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

  final List<String> filters = ['전체', '러블리', '모던', '우디', '레트로'];
  String selectedFilter = '전체';
  int? selectedCategoryIndex;
  List<bool> liked = List.filled(30, false);
  String selectedTab = '쇼핑';

  @override
  void initState() {
    super.initState();
    fetchFurniture();
  }

  // 가구 목록 API
  List furnitureList = [];
  Future<void> fetchFurniture() async {
    var url = Uri.parse('$baseUrl/furniture_list/');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      print(response.body); // 응답 데이터 출력
      setState(() {
        furnitureList = data['furniture'];
      });
    } else {
      print('가져오기 실패: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    const activeColor = Color(0xFF916636);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0.5,
        title: Image.asset('assets/images/logo.png', height: 50),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
          IconButton(icon: const Icon(Icons.mail_outline), onPressed: () {}),
          IconButton(icon: const Icon(Icons.shopping_cart_outlined), onPressed: () {}),
        ],
      ),
      body: ListView(
        children: [
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => selectedTab = '쇼핑'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        '쇼핑',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedTab == '쇼핑' ? activeColor : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 2,
                        width: 30,
                        color: selectedTab == '쇼핑' ? activeColor : Colors.transparent,
                      )
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => setState(() => selectedTab = '이달의 가구'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 4),
                      Text(
                        '이달의 가구',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selectedTab == '이달의 가구' ? activeColor : Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        height: 2,
                        width: 60,
                        color: selectedTab == '이달의 가구' ? activeColor : Colors.transparent,
                      )
                    ],
                  ),
                ),
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.auto_awesome, size: 16),
                  label: const Text('AI 예산 추천', style: TextStyle(fontSize: 11)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: activeColor,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    minimumSize: const Size(0, 32),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                )
              ],
            ),
          ),

          selectedTab == '이달의 가구'
              ? const SizedBox(height: 0)
              : const SizedBox(height: 6),

          if (selectedTab == '쇼핑') ...[
            _buildCategoryIcons(),
            const SizedBox(height: 16),
            _buildStyleFilters(),
            const SizedBox(height: 16),
            _buildProductGrid()
          ] else ...[
            _buildMonthlySection("인기 가구", 0),
            _buildMonthlySection("유행 가구", 6),
            _buildMonthlySection("세일 가구", 12),
            _buildMonthlySection("최신 가구", 18),
            const SizedBox(height: 10),
          ]
        ],
      ),
    );
  }

  Widget _buildCategoryIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 2),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.75,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final isSelected = selectedCategoryIndex == index;
          return GestureDetector(
            onTap: () => setState(() => selectedCategoryIndex = index),
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
                    child: Icon(categoryIcons[index], size: 28, color: Colors.brown.shade700),
                  ),
                ),
                const SizedBox(height: 6),
                Text(categories[index], style: const TextStyle(fontSize: 12)),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildStyleFilters() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: filters.map((filter) {
            final isSelected = selectedFilter == filter;
            return Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: GestureDetector(
                onTap: () => setState(() => selectedFilter = filter),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF916636) : const Color(0xFFF2F2F2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    filter,
                    style: TextStyle(
                      color: isSelected ? Colors.white : Colors.black,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }


  Widget _buildProductGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: furnitureList.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.75,
        ),
        itemBuilder: (context, index) {
          var item = furnitureList[index];

          return GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailPage(productName: item['name']),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.topRight,
                  children: [
                    // 이미지 부분
                    Container(
                      height: 140,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        image: DecorationImage(
                          image: NetworkImage(item['image_url'] ?? 'https://via.placeholder.com/150'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        liked[index] ? Icons.favorite : Icons.favorite_border,
                        color: liked[index] ? Colors.red : Colors.grey,
                      ),
                      onPressed: () {
                        setState(() => liked[index] = !liked[index]);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(item['brand'], style: const TextStyle(fontSize: 12, color: Colors.grey)),
                const SizedBox(height: 4),
                Text(item['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 2),
                Text('${item['min_price']}원'),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMonthlySection(String title, int offset) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16.0,
        top: title == "인기 가구" ? 8 : 16,
        right: 16,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
              const Spacer(),
              TextButton(
                onPressed: () {
                  print('$title 더보기 클릭됨');
                },
                style: TextButton.styleFrom(padding: EdgeInsets.zero),
                child: const Text("더보기", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            height: 200,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 5,
              separatorBuilder: (_, __) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final realIndex = offset + index;
                return GestureDetector(
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ProductDetailPage(productName: "상품이름"),
                    ),
                  ),
                  child: SizedBox(
                    width: 120,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              height: 120,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            IconButton(
                              icon: Icon(
                                liked[realIndex] ? Icons.favorite : Icons.favorite_border,
                                color: liked[realIndex] ? Colors.red : Colors.grey,
                              ),
                              onPressed: () {
                                setState(() => liked[realIndex] = !liked[realIndex]);
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text('브랜드명', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        const SizedBox(height: 4),
                        const Text('이름', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 2),
                        const Text('가격'),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
