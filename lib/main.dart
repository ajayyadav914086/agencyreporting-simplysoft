import 'package:agencyreporting/homepage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'loginpage.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  late String id;

  Future checkSession() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    id = preferences.getString("userid") ?? "null";
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: "Order Form Management",
        theme: ThemeData(primaryColor: const Color(0xFF21899C)),
        home: checkType());
  }

  Widget checkType() {
    return FutureBuilder(
        future: checkSession(),
        // ignore: missing_return
        builder: (context, snapshot) {
          late Widget root;
          if (snapshot.connectionState == ConnectionState.done) {
            root = redirect(id);
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            root = Container();
          }
          return root;
        });
  }

  Widget redirect(String value) {
    if (value == "null") {
      return const LoginPage();
    } else {
      return const HomePage();
    }
  }
}
