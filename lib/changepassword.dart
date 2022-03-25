import 'package:agencyreporting/theme.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'constants.dart';
import 'loginpage.dart';

class ChangePassword extends StatefulWidget {
  String number;
  ChangePassword(this.number);

  @override
  _ChangePassword createState() => _ChangePassword(number);
}

class _ChangePassword extends State<ChangePassword> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late AuthCredential credential;
  TextEditingController passwordController = TextEditingController();
  TextEditingController passwordCnfController = TextEditingController();
  String number;
  _ChangePassword(this.number);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(24.0, 40.0, 24.0, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Enter New Password',
                    style: heading2.copyWith(color: textBlack),
                  ),
                  const SizedBox(
                    height: 20,
                  )
                ],
              ),
              const SizedBox(
                height: 48,
              ),
              Form(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          hintStyle: heading6.copyWith(color: textGrey),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 34,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: textWhiteGrey,
                        borderRadius: BorderRadius.circular(14.0),
                      ),
                      child: TextFormField(
                        controller: passwordCnfController,
                        decoration: InputDecoration(
                          hintText: 'Confirm Password',
                          hintStyle: heading6.copyWith(color: textGrey),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 34,
              ),
              Material(
                borderRadius: BorderRadius.circular(14.0),
                elevation: 0,
                child: Container(
                  height: 40,
                  decoration: BoxDecoration(
                    color: primaryBlue,
                    borderRadius: BorderRadius.circular(14.0),
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: (){
                        change();
                      },
                      borderRadius: BorderRadius.circular(14.0),
                      child: Center(
                        child: Text(
                          'Change Password',
                          style: heading5.copyWith(color:Colors.white),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  void initState(){
    super.initState();
    auth.signOut();
  }

  void change() async{
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
                    Text("Please Wait...")
                  ],
                ),
              ));
        });
    var params = {
      "username":number,
      "password":passwordController.text
    };
    Response response = await Dio().post(
        Constants.forgot_password,
        data: params
    );
    print(response.data);
    if(response.data == "success"){
      Navigator.pop(context);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => LoginPage()));
    }
  }

  showErrorDialog() {
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Verification Failed"),
          content: const Text("OTP verification Failed"),
          actions: [
            ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text("OKAY")),
          ],
        ));
    return;
  }
}