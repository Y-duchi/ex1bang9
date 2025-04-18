
import 'package:flutter/material.dart';
import 'usedT.dart';
import 'community.dart';
import 'shopping.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int currentIndex = 0;

  final List<Widget> pages = [
    const ShoppingPage(),
    const UsedTradePage(),
    const CommunityPage(),
    const Center(child: Text('사용자 페이지')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: const Color(0xFF916636),
        unselectedItemColor: Colors.black,
        type: BottomNavigationBarType.fixed,
        onTap: (index) => setState(() => currentIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.shopping_bag), label: '쇼핑'),
          BottomNavigationBarItem(icon: Icon(Icons.swap_horiz), label: '중고거래'),
          BottomNavigationBarItem(icon: Icon(Icons.groups), label: '커뮤니티'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: '사용자'),
        ],
      ),
    );
  }
}
