import 'dart:convert';

import 'package:agencyreporting/homepage.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'forgotpassword.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late SharedPreferences pref;
  FirebaseAuth mAuth = FirebaseAuth.instance;
  bool passwordVisible = false;
  TextEditingController phone = TextEditingController();
  TextEditingController password = TextEditingController();
  String radioItem = '';
  String URL = '';
  final _form = GlobalKey<FormState>(); //for storing form state.

  void togglePassword() {
    setState(() {
      passwordVisible = !passwordVisible;
    });
  }

  @override
  void initState() {
    initial();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xFF21899C),
      body: SafeArea(
        child: Column(
          children: [
            //to give space from top
            const Expanded(
              flex: 1,
              child: Center(),
            ),
            //page content here
            Expanded(
              flex: 9,
              child: buildCard(size),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(Size size) {
    return Container(
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(40), topRight: Radius.circular(40)),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            //logo section
            logo(size.height / 8, size.height / 8),
            SizedBox(
              height: size.height * 0.03,
            ),
            richText(24),
            SizedBox(
              height: size.height * 0.05,
            ),
            //email & password section
            emailTextField(size),
            SizedBox(
              height: size.height * 0.02,
            ),
            passwordTextField(size),
            SizedBox(
              height: size.height * 0.03,
            ),

            ForgetPasswordText(),
            SizedBox(
              height: size.height * 0.03,
            ),

            //sign in button
            signInButton(size),
          ],
        ),
      ),
    );
  }

  Widget logo(double height_, double width_) {
    return Image.asset(
      'assets/simplyicon.png',
      height: height_,
      width: width_,
    );
  }

  Widget richText(double fontSize) {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: fontSize,
          color: const Color(0xFF21899C),
          letterSpacing: 2.000000061035156,
        ),
        children: const [
          TextSpan(
            text: 'USER LOGIN',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          TextSpan(
            text: ' PAGE',
            style: TextStyle(
              color: Color(0xFFFE9879),
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget emailTextField(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 11,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 1.0,
          color: const Color(0xFFEFEFEF),
        ),
      ),
      child: TextField(
        controller: phone,
        style: GoogleFonts.inter(
          fontSize: 16.0,
          color: const Color(0xFF15224F),
        ),
        maxLines: 1,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
            labelText: 'Phone number',
            labelStyle: GoogleFonts.inter(
              fontSize: 12.0,
              color: const Color(0xFF969AA8),
            ),
            border: InputBorder.none),
      ),
    );
  }

  Widget passwordTextField(Size size) {
    return Container(
      alignment: Alignment.center,
      height: size.height / 11,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.0),
        border: Border.all(
          width: 1.0,
          color: const Color(0xFFEFEFEF),
        ),
      ),
      child: TextField(
        controller: password,
        style: GoogleFonts.inter(
          fontSize: 16.0,
          color: const Color(0xFF15224F),
        ),
        maxLines: 1,
        obscureText: true,
        keyboardType: TextInputType.visiblePassword,
        cursorColor: const Color(0xFF15224F),
        decoration: InputDecoration(
            labelText: 'Password',
            labelStyle: GoogleFonts.inter(
              fontSize: 12.0,
              color: const Color(0xFF969AA8),
            ),
            border: InputBorder.none),
      ),
    );
  }

  Widget signInButton(Size size) {
    return InkWell(
      onTap: () {
        login();
      },
      child: Container(
        alignment: Alignment.center,
        height: size.height / 11,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50.0),
          color: const Color(0xFF21899C),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF4C2E84).withOpacity(0.2),
              offset: const Offset(0, 15.0),
              blurRadius: 60.0,
            ),
          ],
        ),
        child: Text(
          'Sign in',
          style: GoogleFonts.inter(
            fontSize: 16.0,
            color: Colors.white,
            fontWeight: FontWeight.w600,
            height: 1.5,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  Widget ForgetPasswordText() {
    return Text.rich(
      TextSpan(
        style: GoogleFonts.inter(
          fontSize: 12.0,
          color: const Color(0xFF3B4C68),
        ),
        children: [
          const TextSpan(
            text: 'Trouble signing in',
          ),
          const TextSpan(
            text: ' ',
            style: TextStyle(
              color: Color(0xFFFF5844),
            ),
          ),
          TextSpan(
            text: 'Forgot password',
            recognizer: TapGestureRecognizer()
              ..onTap = () => {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ForgotPassword()))
              },
            style: const TextStyle(
              color: Color(0xFFFF5844),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  void login() async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    CircularProgressIndicator(),
                    SizedBox(
                      width: 16,
                    ),
                    Text("login.....")
                  ],
                ),
              ));
        });
    var params = {"username": phone.text, "password": password.text};
    URL = Constants.user_login;
    Response response = await Dio().post(URL, data: params);
    var data = jsonDecode(response.toString());
    print(data);
    if (data['response'] == 200) {
      Navigator.pop(context);
      pref.setString("userid", data['data']['regId'].toString());
      pref.setString("ip", data['data']['ip_address']);
      pref.setString("database", data['data']['database_name']);
      pref.setString("username", data['data']['database_username']);
      pref.setString("password", data['data']['database_password']);
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => const HomePage()),(route)=>false);
    } else {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text("Login Failed"),
            content: const Text("Username or password is incorrect"),
            actions: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text("OKAY")),
            ],
          ));
    }
  }

  void initial() async {
    pref = await SharedPreferences.getInstance();
  }
}
