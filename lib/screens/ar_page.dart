import 'package:flutter/material.dart';

class ARPage extends StatelessWidget {
  const ARPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('AR 배치 보기')),
      body: const Center(child: Text('AR 기능 실행 화면 (예시)')),
    );
  }
}