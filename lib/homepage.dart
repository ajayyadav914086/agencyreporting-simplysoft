import 'dart:convert';
import 'package:agencyreporting/dispatch.dart';
import 'package:agencyreporting/loginpage.dart';
import 'package:agencyreporting/payable.dart';
import 'package:agencyreporting/payment.dart';
import 'package:agencyreporting/receipt.dart';
import 'package:agencyreporting/receivable.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Response response,cmpResponse;
  Dio dio = Dio();
  var apidata;
  var apicmpdata;
  bool loading = true;
  late SharedPreferences pref;
  late List<String> _cmp = [];
  late String selected;

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // style
    // ignore: unused_local_variable
    var cardTextStyle = const TextStyle(
        fontFamily: "Montserrat Regular",
        fontSize: 14,
        color: Color.fromRGBO(63, 63, 63, 1));
    return Scaffold(
      backgroundColor: Colors.green[100],
      body: Stack(
        children: <Widget>[
          Container(
            height: size.height * .5,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  alignment: Alignment.topCenter,
                  image: AssetImage('assets/top_header.png')),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child:Column(
                children: <Widget>[
                  Container(
                    height: 64,
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                // ignore: prefer_const_literals_to_create_immutables
                                children: <Widget>[
                                  loading
                                  ? CircularProgressIndicator()
                                  : DropdownButton<String>(
                                    hint: Text('Company Name'),
                                    items: _cmp.map((String value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                    value: selected,
                                    onChanged: (newvalue) {
                                      setState((){
                                        selected = newvalue!;
                                        changeLogin(newvalue);
                                        print(selected);
                                      });
                                    },
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        pref.remove("userid");
                                        pref.remove("ip");
                                        pref.remove("database");
                                        pref.remove("username");
                                        pref.remove("password");
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginPage()),
                                            (route) => false);
                                      },
                                      child: Text("SIGNOUT"))
                                ],
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    child: GridView.count(
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      primary: false,
                      crossAxisCount: 2,
                      children: <Widget>[
                        InkWell(
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "assets/growth.png",
                                  height: 70,
                                  width: 70,
                                ),
                                const Text(
                                  'Dispatch',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                loading
                                    ? const CircularProgressIndicator()
                                    : apidata['data']['total_dispatch'] == null
                                        ? Text(
                                            'Total RS ',
                                            style: cardTextStyle,
                                          )
                                        : Text(
                                            'Total RS ' +
                                                apidata['data']
                                                    ['total_dispatch'],
                                            style: cardTextStyle,
                                          )
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Dispatch()));
                          },
                        ),
                        InkWell(
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "assets/receipt.png",
                                  height: 70,
                                  width: 70,
                                ),
                                const Text(
                                  'Receipt',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                loading
                                    ? const CircularProgressIndicator()
                                    : apidata['data']['total_receipt'] == null
                                        ? Text(
                                            'Total RS ',
                                            style: cardTextStyle,
                                          )
                                        : Text(
                                            'Total RS ' +
                                                apidata['data']['total_recipt'],
                                            style: cardTextStyle,
                                          )
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Receipt()));
                          },
                        ),
                        InkWell(
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "assets/credit-card.png",
                                  height: 70,
                                  width: 70,
                                ),
                                const Text(
                                  'Payment',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                loading
                                    ? const CircularProgressIndicator()
                                    : apidata['data']['total_payment'] == null
                                        ? Text(
                                            'Total RS ',
                                            style: cardTextStyle,
                                          )
                                        : Text(
                                            'Total RS ' +
                                                apidata['data']
                                                    ['total_payment'],
                                            style: cardTextStyle,
                                          )
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Payment()));
                          },
                        ),
                        InkWell(
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "assets/save-money.png",
                                  height: 70,
                                  width: 70,
                                ),
                                const Text(
                                  'Receivable',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                loading
                                    ? const CircularProgressIndicator()
                                    : apidata['data']['total_receivable'] ==
                                            null
                                        ? Text(
                                            'Total RS ',
                                            style: cardTextStyle,
                                          )
                                        : Text(
                                            'Total RS ' +
                                                apidata['data']
                                                    ['total_receivable'],
                                            style: cardTextStyle,
                                          )
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Receivable()));
                          },
                        ),
                        InkWell(
                          child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            elevation: 4,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Image.asset(
                                  "assets/payment.png",
                                  height: 70,
                                  width: 70,
                                ),
                                const Text(
                                  'Payable',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                const SizedBox(
                                  height: 6,
                                ),
                                loading
                                    ? const CircularProgressIndicator()
                                    : Text(
                                        'Total RS ' +
                                            apidata['data']['total_payable'],
                                        style: cardTextStyle,
                                      )
                              ],
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Payable()));
                          },
                        ),
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          elevation: 4,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Image.asset(
                                "assets/rent.png",
                                height: 70,
                                width: 70,
                              ),
                              const Text(
                                'Interest',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              const SizedBox(
                                height: 3,
                              ),
                              const Text(
                                'Report ',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void getData() async {
    setState(() {
      loading = true;
    });
    pref = await SharedPreferences.getInstance();
    FormData formData = FormData.fromMap({
      "server": pref.get("ip"),
      "username": pref.get("username"),
      "password": pref.get("password"),
      "database": pref.get("database")
    });
    response = await dio.post(Constants.TOTAL, data: formData);
    apidata = json.decode(response.data);
    print(apidata);
    FormData cmpData = FormData.fromMap({
      "regid": pref.get("userid")
    });
    cmpResponse = await dio.post(Constants.GET_COMPANY,data: cmpData);
    apicmpdata = jsonDecode(cmpResponse.data);
    for(var i=0;i<apicmpdata['cmp'].length;i++){
      _cmp.add(apicmpdata['cmp'][i]['cmp_name']);
    }
    print("CMP LENGTH ${_cmp.first}");

    loading = false;
    setState(() {
      selected = _cmp.first;
    });
  }

  void changeLogin(value)async{
    _cmp.clear();
    setState((){
      loading = true;
    });
    FormData ipData = FormData.fromMap({
      "cmp_name": value,
    });
    var ipresponse = await dio.post(Constants.GET_COMPANY_IP,data: ipData);
    var ipdata = jsonDecode(ipresponse.data);
    pref.setString("ip", ipdata['cmp']['ip_address']);
    pref.setString("cmp", ipdata['cmp']['cmp_name']);
    pref.setString("database", ipdata['cmp']['database_name']);
    pref.setString("username", ipdata['cmp']['database_username']);
    pref.setString("password", ipdata['cmp']['database_password']);
    print(ipdata['cmp']['ip_address']);
    getData();
  }
}
