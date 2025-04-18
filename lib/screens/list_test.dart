import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';

class FurnitureListPage extends StatefulWidget {
  const FurnitureListPage({Key? key}) : super(key: key);

  @override
  _FurnitureListPageState createState() => _FurnitureListPageState();
}

class _FurnitureListPageState extends State<FurnitureListPage> {
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
  void initState() {
    super.initState();
    fetchFurniture();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('가구 목록'),
        backgroundColor: const Color(0xFFF4DFB8),
        foregroundColor: Colors.brown,
      ),
      backgroundColor: const Color(0xFFF4F4F4),
      body: furnitureList.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: furnitureList.length,
        itemBuilder: (context, index) {
          var item = furnitureList[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Image.network(
                item['image_url'],
                width: 60,
                height: 60,
                fit: BoxFit.cover,
              ),
              title: Text(
                item['name'],
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                '${item['brand']} / ${item['min_price']}원',
              ),
              onTap: () {
                // 상세 페이지로 이동
              },
            ),
          );
        },
      ),
    );
  }
}