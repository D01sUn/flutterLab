import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:week3/config/config.dart';
import 'package:week3/config/internal_config.dart';
import 'package:week3/models/request/customersLoginReq.dart';
import 'package:week3/models/response/customersLoginDes.dart';
import 'package:week3/pages/register.dart';
import 'package:week3/pages/showtrip.dart';

class LoginPage extends StatefulWidget {
  LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String text = '';
  int number = 0;
  String phoneNumber = '';
  TextEditingController phoneNOCtl = TextEditingController();
  TextEditingController passwordCtl = TextEditingController();
  String url = '';

  final phone = "1";
  final password = "1";

  @override
  void initState() {
    super.initState();
    Configuration.getConfig().then(
      (config) {
        url = config['apiEndpoint'];
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                  onDoubleTap: () {
                    log("onDoubleTap is fired");
                  },
                  child: Image.asset('assets/images/logo.png')),
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 40), // Increase horizontal padding
                child: Text(
                  'หมายเลขโทรศัพท์',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40), // Increase horizontal padding
                child: TextField(
                    controller: phoneNOCtl,
                    // onChanged: (value) {
                    //   phoneNumber = value;
                    // },
                    keyboardType: TextInputType.phone,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1)))),
              ),
            ]),
            const SizedBox(height: 20),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Padding(
                padding: EdgeInsets.symmetric(
                    horizontal: 40), // Increase horizontal padding
                child: Text(
                  'รหัสผ่าน',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40), // Increase horizontal padding
                child: TextField(
                    controller: passwordCtl,
                    obscureText: true,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(
                            borderSide: BorderSide(width: 1)))),
              ),
            ]),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () => register(),
                      child: const Text('ลงทะเบียนใหม่')),
                  FilledButton(
                      onPressed: () => login(),
                      child: const Text('เข้าสู่ระบบ')),
                ],
              ),
            ),
            Text(
              text,
              style: const TextStyle(
                fontSize: 10,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> login() async {
    // log(phoneNumber);
    // log(phoneNOCtl.text);
    // log(passwordCtl.text);

    // if (phoneNOCtl.text == phone && passwordCtl.text == password) {
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(builder: (context) => const ShowTripPage()),
    //   );
    // } else {
    //   setState(() {
    //     text = "Invalid username or password. Please try again.";
    //   });
    // }

    // http.get(Uri.parse("http://172.20.10.7:3000/customers")).then(
    //   (value) {
    //     log(value.body);
    //   },
    // ).catchError((error) {
    //   log('Error $error');
    // });

    // var data = {"phone": "0817399999", "password": "1111"};
    // var data = CustomersLoginPostRequest(phone: "0817399999", password: "1111");
    // http
    //     .post(Uri.parse("http://172.20.10.7:3000/customers/login"),
    //         headers: {"Content-Type": "application/json; charset=utf-8"},
    //         body: customersLoginPostRequestToJson(data))
    //     .then(
    //   (value) {
    //     CustomersLoginPostResponse customer =
    //         customersLoginPostResponseFromJson(value.body);
    //     log(customer.customer.email);
    //     // var jsonRes = jsonDecode(value.body);
    //     // log(jsonRes['customer']['email']);
    //   },
    // ).catchError((error) {
    //   log('Error $error');
    // });

    var data = {"phone": "0817399999", "password": "1111"};
    CustomersLoginPostRequest req = CustomersLoginPostRequest(
        phone: phoneNOCtl.text, password: passwordCtl.text);
    // http
    //     .post(Uri.parse("http://172.20.10.7:3000/customers/login"),
    //         headers: {"Content-Type": "application/json; charset=utf-8"},
    //         body: customersLoginPostRequestToJson(req))
    //     .then(
    //   (value) {
    //     log(value.body);
    //     CustomersLoginPostResponse customerLoginPostResponse =
    //         customersLoginPostResponseFromJson(value.body);
    //     log(customerLoginPostResponse.customer.fullname);
    //     log(customerLoginPostResponse.customer.email);

    //     Navigator.push(
    //       context,
    //       MaterialPageRoute(builder: (context) => const ShowTripPage()),
    //     );
    //   },
    // ).catchError((error) {
    //   log('Error $error');
    //   setState(() {
    //     text = "Invalid username or password. Please try again.";
    //   });
    // });

    try {
      var data = {"phone": "0817399999", "password": "1111"};
      CustomersLoginPostRequest req = CustomersLoginPostRequest(
          phone: phoneNOCtl.text, password: passwordCtl.text);

      final response = await http.post(
        Uri.parse("$API_ENDPOINT/customers/login"),
        headers: {"Content-Type": "application/json; charset=utf-8"},
        body: customersLoginPostRequestToJson(req),
      );

      log(response.body);
      CustomersLoginPostResponse customerLoginPostResponse =
          customersLoginPostResponseFromJson(response.body);
      log(customerLoginPostResponse.customer.fullname);
      log(customerLoginPostResponse.customer.email);

      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ShowTripPage(
              cid: customerLoginPostResponse.customer.idx,
            ),
          ));
    } catch (error) {
      log('Error $error');
      setState(() {
        text = "Invalid username or password. Please try again.";
      });
    }
  }

  void register() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterPage()),
    );
  }
}
