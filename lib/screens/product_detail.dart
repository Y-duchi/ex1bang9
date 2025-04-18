
import 'package:flutter/material.dart';
import 'ar_page.dart';

class ProductDetailPage extends StatefulWidget {
  final String productName;

  const ProductDetailPage({super.key, required this.productName});

  @override
  State<ProductDetailPage> createState() => _ProductDetailPageState();
}

class _ProductDetailPageState extends State<ProductDetailPage> {
  final PageController _pageController = PageController();
  final ScrollController _scrollController = ScrollController();

  final GlobalKey _reviewKey = GlobalKey();
  final GlobalKey _inquiryKey = GlobalKey();

  int currentPage = 0;
  String selectedTab = '상품 정보';

  void _scrollToSection(GlobalKey key) {
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.notifications_none), onPressed: () {}),
          IconButton(icon: const Icon(Icons.mail_outline), onPressed: () {}),
          IconButton(icon: const Icon(Icons.shopping_cart_outlined), onPressed: () {}),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // 이미지 슬라이더 + AR 버튼
                Stack(
                  children: [
                    SizedBox(
                      height: 300,
                      child: PageView.builder(
                        controller: _pageController,
                        itemCount: 5,
                        onPageChanged: (index) => setState(() => currentPage = index),
                        itemBuilder: (context, index) => Container(
                          margin: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Center(
                            child: Icon(Icons.image, size: 100, color: Colors.grey),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: List.generate(
                          5,
                              (index) => Container(
                            margin: const EdgeInsets.symmetric(horizontal: 2),
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: currentPage == index ? Colors.black : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 12,
                      right: 12,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const ARPage()),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            boxShadow: [BoxShadow(blurRadius: 4, color: Colors.black12)],
                          ),
                          child: const Icon(Icons.view_in_ar, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),

                // 상품 정보
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('브랜드', style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 4),
                            Text(widget.productName, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                            const SizedBox(height: 4),
                            const Text('가격', style: TextStyle(fontSize: 14)),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 8),
                          const Text('0.0', style: TextStyle(fontSize: 14)),
                          const SizedBox(height: 4),
                          Row(
                            children: List.generate(
                              5,
                                  (index) => const Icon(Icons.star_border, size: 16),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),

                const Divider(height: 1),

                // 탭
                SizedBox(
                  height: 48,
                  child: Row(
                    children: [
                      _buildTab('상품 정보'),
                      _buildTab('리뷰'),
                      _buildTab('문의'),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // 상세 이미지
                Image.asset(
                  'assets/images/testlong.png',
                  fit: BoxFit.cover,
                ),

                // 리뷰
                Padding(
                  key: _reviewKey,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('리뷰', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 8),
                      Text('리뷰가 아직 없습니다.', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),

                // 문의
                Padding(
                  key: _inquiryKey,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('문의', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      SizedBox(height: 8),
                      Text('문의 내역이 없습니다.', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ),

                const SizedBox(height: 100),
              ],
            ),
          ),

          // 제일 위로 버튼 (하단바 위에 뜨도록 조정)
          Positioned(
            bottom: 10,
            right: 16,
            child: FloatingActionButton(
              mini: true,
              backgroundColor: Colors.white,
              onPressed: () {
                _scrollController.animateTo(
                  0,
                  duration: const Duration(milliseconds: 400),
                  curve: Curves.easeOut,
                );
              },
              child: const Icon(Icons.arrow_upward),
            ),
          ),
        ],
      ),

      // 구매 하단 바
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 36),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.black12)),
          color: Colors.white,
        ),
        child: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.favorite_border),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
            Expanded(
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFF2DFC2),
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('구매하기'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTab(String label) {
    final isSelected = selectedTab == label;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() => selectedTab = label);
          if (label == '리뷰') {
            _scrollToSection(_reviewKey);
          } else if (label == '문의') {
            _scrollToSection(_inquiryKey);
          }
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: isSelected ? Colors.black : Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
