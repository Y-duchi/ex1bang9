import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final userIdController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final usernameController = TextEditingController();
  final nicknameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final emailCodeController = TextEditingController();

  bool isEmailVerified = false;  // 이메일 인증 성공 여부

  // 아이디 중복 확인 API
  Future<void> checkDuplicateId() async {
    var url = Uri.parse('$baseUrl/check_user_id/');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'user_id': userIdController.text}),
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    showDialog(
      context: context,
      builder: (context) => AlertDialog(content: Text(data['message'])),
    );
  }

  // 회원가입 API
  Future<void> register() async {
    var url = Uri.parse('$baseUrl/register/');

    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        'user_id': userIdController.text,
        'password_hash': passwordController.text,
        'password_confirm': confirmPasswordController.text,
        'username': usernameController.text,
        'nickname': nicknameController.text,
        'phone': phoneController.text,
        'email': emailController.text,
      }),
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    if (data['success']) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'])));
      Navigator.pop(context); // 가입 후 뒤로가기
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(data['message'].toString())));
    }
  }

  // 이메일 인증번호 전송 API
  void sendEmailCode() async {
    var url = Uri.parse('$baseUrl/send_email_verification/');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': emailController.text}),
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(content: Text(data['message'])),
    );
  }

  // 이메일 인증번호 확인 API
  void verifyEmailCode() async {
    var url = Uri.parse('$baseUrl/verify_email_code/');
    var response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': emailController.text,
        'code': emailCodeController.text,
      }),
    );

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    if (data['success']) {
      setState(() {
        isEmailVerified = true; // ✅ 인증 성공 상태 저장
      });
      showDialog(
        context: context,
        builder: (context) => AlertDialog(content: Text(data['message'])),
      );
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(content: Text(data['message'])),
      );
    }
  }

  Widget _buildTextField(String label, String hint, TextEditingController controller, {Widget? suffix, bool obscure = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 12)),
          const SizedBox(height: 4),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  obscureText: obscure,
                  decoration: InputDecoration(
                    hintText: hint,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                ),
              ),
              if (suffix != null) ...[
                const SizedBox(width: 10),
                suffix,
              ]
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAgreement(String label) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 4.0),
      child: Row(
        children: [
          Container(
            width: 15,
            height: 15,
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFD9D9D9)),
              shape: BoxShape.rectangle,
            ),
          ),
          const SizedBox(width: 10),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  Widget _customButton(String label, {VoidCallback? onPressed}) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 75,
        height: 40,
        decoration: BoxDecoration(
          color: const Color(0xFFF4DFB8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(
          child: Text(
            label,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 12,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFF4DFB8),
          foregroundColor: const Color(0xFF714322),
          minimumSize: const Size.fromHeight(50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: () {
          if (!isEmailVerified) {
            showDialog(
              context: context,
              builder: (context) => const AlertDialog(
                content: Text('이메일 인증을 완료해주세요.'),
              ),
            );
            return;
          }
          // 이메일 인증 시 회원가입
          register();
        },
        child: const Text('가입하기', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF4F4F4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.only(bottom: 30),
        children: [
          const Center(
            child: Text('회원가입', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ),
          const SizedBox(height: 20),
          _buildTextField('아이디', '아이디를 입력해주세요.', userIdController,
              suffix: _customButton('중복확인', onPressed: checkDuplicateId)),
          _buildTextField('비밀번호', '비밀번호를 입력해주세요.', passwordController, obscure: true),
          _buildTextField('비밀번호 확인', '비밀번호를 다시 입력해주세요.', confirmPasswordController, obscure: true),
          _buildTextField('이름', '이름을 입력해주세요.', usernameController),
          _buildTextField('닉네임', '닉네임을 입력해주세요.', nicknameController),
          _buildTextField('전화번호', '전화번호를 입력해주세요.', phoneController),
          _buildTextField('이메일', '이메일을 입력해주세요.', emailController, suffix: _customButton('인증번호 전송', onPressed: sendEmailCode)),
          _buildTextField('인증번호', '인증번호를 입력해주세요.', emailCodeController, suffix: _customButton('확인', onPressed: verifyEmailCode)),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
            child: Text('약관 동의', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          _buildAgreement('전체 동의'),
          _buildAgreement('이용약관 동의 (필수)'),
          _buildAgreement('개인정보 동의 (필수)'),
          _buildAgreement('푸시 알림 동의 (선택)'),

          _buildSubmitButton(),
        ],
      ),
    );
  }
}