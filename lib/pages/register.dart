import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:week3/models/request/CustomersRegisterPostReq.dart'; // Ensure this path is correct
import 'package:week3/pages/login.dart';
import 'package:week3/pages/showtrip.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  TextEditingController nameCtl = TextEditingController();
  TextEditingController emailCtl = TextEditingController();
  TextEditingController phoneNOCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();
  TextEditingController passwordCtlCheck = TextEditingController();
  String text = "";
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("ลงทะเบียนสมาชิกใหม่"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              _buildTextField("ชื่อ-นามสกุล", nameCtl),
              const SizedBox(height: 20),
              _buildTextField("หมายเลขโทรศัพท์", phoneNOCtl,
                  keyboardType: TextInputType.phone),
              const SizedBox(height: 20),
              _buildTextField("อีเมล์", emailCtl,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 20),
              _buildTextField("รหัสผ่าน", passwordCtl, obscureText: true),
              const SizedBox(height: 20),
              _buildTextField("ยืนยันรหัสผ่าน", passwordCtlCheck,
                  obscureText: true),
              const SizedBox(height: 20),
              isLoading
                  ? CircularProgressIndicator()
                  : SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _register,
                        child: const Text('สมัครสมาชิก'),
                      ),
                    ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                    onPressed: _navigateToLogin,
                    child: const Text(
                      'หากมีชื่ออยู่แล้ว?',
                      style: TextStyle(
                        color: Color.fromARGB(255, 120, 120, 120),
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: _navigateToLogin,
                    child: const Text('เข้าสู่ระบบ'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Text(
                text,
                style: TextStyle(color: Colors.red),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false,
      TextInputType keyboardType = TextInputType.text}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: const InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(width: 1),
            ),
          ),
        ),
      ],
    );
  }

  void _register() {
    setState(() {
      text = "";
      isLoading = true;
    });

    if (nameCtl.text.isEmpty ||
        emailCtl.text.isEmpty ||
        phoneNOCtl.text.isEmpty ||
        passwordCtl.text.isEmpty ||
        passwordCtlCheck.text.isEmpty) {
      setState(() {
        text = "กรุณากรอกข้อมูลให้ครบถ้วน";
        isLoading = false;
      });
      return;
    }

    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(emailCtl.text)) {
      setState(() {
        text = "รูปแบบอีเมล์ไม่ถูกต้อง";
        isLoading = false;
      });
      return;
    }

    if (passwordCtl.text != passwordCtlCheck.text) {
      setState(() {
        text = "รหัสผ่านไม่ตรงกัน กรุณาลองใหม่อีกครั้ง";
        isLoading = false;
      });
      return;
    }

    CustomersRegisterPostRequest req = CustomersRegisterPostRequest(
      fullname: nameCtl.text,
      email: emailCtl.text,
      phone: phoneNOCtl.text,
      password: passwordCtl.text,
      image:
          'http://202.28.34.197:8888/contents/4a00cead-afb3-45db-a37a-c8bebe08fe0d.png',
    );

    http
        .post(
      Uri.parse("http://172.20.10.7:3000/customers"),
      headers: {"Content-Type": "application/json; charset=utf-8"},
      body: jsonEncode(req.toJson()),
    )
        .then((value) {
      log(value.body);
      setState(() {
        isLoading = false;
      });

      if (value.statusCode == 200) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => LoginPage()),
        );
        setState(() {
          text = "การลงทะเบียนเสร็จสิ้น";
        });
      } else {
        setState(() {
          text = "การลงทะเบียนล้มเหลว โปรดลองใหม่";
        });
      }
    }).catchError((error) {
      log('Error $error');
      setState(() {
        text = "เกิดข้อผิดพลาด: $error";
        isLoading = false;
      });
    });
  }

  void _navigateToLogin() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
