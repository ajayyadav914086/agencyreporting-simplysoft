import 'package:agencyreporting/theme.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'changepassword.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPassword createState() => _ForgotPassword();
}

class _ForgotPassword extends State<ForgotPassword> {
  FirebaseAuth auth = FirebaseAuth.instance;
  late AuthCredential credential;
  late String vId;
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();

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
                    'Forgot Password',
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
                child: Container(
                    decoration: BoxDecoration(
                      color: textWhiteGrey,
                      borderRadius: BorderRadius.circular(14.0),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 10,
                          child: TextFormField(
                            controller: phoneController,
                            decoration: InputDecoration(
                              hintText: 'Phone Number',
                              hintStyle: heading6.copyWith(color: textGrey),
                              border: const OutlineInputBorder(
                                borderSide: BorderSide.none,
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: FlatButton(
                            color: Colors.lightBlue,
                            textColor: Colors.white,
                            onPressed: () {
                              final snackBar = SnackBar(
                                content: const Text('OTP has been sent, please wait'),
                              );

                              // Find the ScaffoldMessenger in the widget tree
                              // and use it to show a SnackBar.
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              verifyPhone();
                            },
                            child: const Text("SEND OTP"),
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        )
                      ],
                    )),
              ),
              const SizedBox(
                height: 34,
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
                        controller: otpController,
                        decoration: InputDecoration(
                          hintText: 'Enter OTP',
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
                      onTap: () {
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
                                        Text("Verifying.....")
                                      ],
                                    ),
                                  ));
                            });
                        credential = PhoneAuthProvider.credential(
                            verificationId: vId, smsCode: otpController.text);
                        auth
                            .signInWithCredential(credential)
                            .then((value) => {
                          Navigator.pop(context),
                          Navigator.push(
                              context, MaterialPageRoute(builder: (context) => ChangePassword(phoneController.text)))
                        })
                            .onError((error, stackTrace) => showErrorDialog());
                      },
                      borderRadius: BorderRadius.circular(14.0),
                      child: Center(
                        child: Text(
                          'VERIFY OTP',
                          style: heading5.copyWith(color: Colors.white),
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
  void initState() {
    super.initState();
    auth.signOut();
  }

  void verifyPhone() async {
    await auth.verifyPhoneNumber(
        phoneNumber: "+91"+phoneController.text,
        timeout: const Duration(seconds: 50),
        verificationCompleted: (AuthCredential credential) async {
          this.credential = credential;
          print("VERIFICATION COMPLETE:" + credential.token.toString());
        },
        verificationFailed: (FirebaseAuthException e) {
          print("VERIFICATION FAILED:" + e.message.toString());
        },
        codeSent: (String verificationId, [int? resendToken]) {
          vId = verificationId;
          print(verificationId);
        },
        codeAutoRetrievalTimeout: (String verificationId) {});
  }

  showErrorDialog() {
    Navigator.pop(context);
    showDialog(
        context: context,
        builder: (context) =>
            AlertDialog(
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
