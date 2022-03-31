/// Flutter code sample for AppBar

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:intl/intl.dart';

import 'Rcptandpymtdetail.dart';
import 'constants.dart';

/// This is the stateless widget that the main application instantiates.
class Payment extends StatefulWidget {
  const Payment({Key? key}) : super(key: key);

  @override
  State<Payment> createState() => _PaymentState();
}

class _PaymentState extends State<Payment> {
  late Response response;
  Dio dio = Dio();
  var apidata;
  bool loading = false;
  late SearchBar searchBar;

  @override
  void initState() {
    getData();
    super.initState();
  }

  Widget today = SimpleDialogOption(
    child: const Text('Today'),
    onPressed: () {
      DateFormat dateFormat =  DateFormat("dd-MM-yyyy");
      final today = dateFormat.format(DateTime.now()) ;
      print(today);
    },
  );
  Widget yesterday = SimpleDialogOption(
    child: const Text('Yesterday'),
    onPressed: () {
      DateFormat dateFormat =  DateFormat("dd-MM-yyyy");
      final today = dateFormat.format(DateTime.now()) ;
      final todaydatetime = dateFormat.parse(today);
      final yesterday = todaydatetime.subtract(Duration(days: 1));
      final yesterdayformat = dateFormat.format(yesterday);
      print(yesterdayformat);
    },
  );
  Widget last7days = SimpleDialogOption(
    child: const Text('Last 7 Days'),
    onPressed: () {
      DateFormat dateFormat =  DateFormat("dd-MM-yyyy");
      final today = dateFormat.format(DateTime.now()) ;
      final todaydatetime = dateFormat.parse(today);
      final yesterday = todaydatetime.subtract(Duration(days: 7));
      final yesterdayformat = dateFormat.format(yesterday);
      print(yesterdayformat);
    },
  );
  Widget last30days = SimpleDialogOption(
    child: const Text('last 30 Days'),
    onPressed: () {
      DateFormat dateFormat =  DateFormat("dd-MM-yyyy");
      final today = dateFormat.format(DateTime.now()) ;
      final todaydatetime = dateFormat.parse(today);
      final yesterday = todaydatetime.subtract(Duration(days: 30));
      final yesterdayformat = dateFormat.format(yesterday);
      print(yesterdayformat);
    },
  );
  Widget last365days = SimpleDialogOption(
    child: const Text('Last 365 Days'),
    onPressed: () {
      DateFormat dateFormat =  DateFormat("dd-MM-yyyy");
      final today = dateFormat.format(DateTime.now()) ;
      final todaydatetime = dateFormat.parse(today);
      final yesterday = todaydatetime.subtract(Duration(days: 365));
      final yesterdayformat = dateFormat.format(yesterday);
      print(yesterdayformat);
    },
  );
  Widget customdate(context){
    return SimpleDialogOption(
      child: const Text('Custom Date'),
      onPressed: () {
        customDateRange(context);
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Payment"),
      actions: <Widget>[
        searchBar.getSearchAction(context),
        IconButton(
            onPressed: () {
              SimpleDialog dialog = SimpleDialog(
                title: const Text('SELECT ONE OPTION:-'),
                children: <Widget>[
                  today,
                  yesterday,
                  last7days,
                  last30days,
                  last365days,
                  customdate(context),
                ],
              );

              // show the dialog
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return dialog;
                },
              );
            },
            icon: const Icon(Icons.calendar_today))
      ],
    );
  }

  void onSubmitted(String value) async {
    apidata = [];
    setState(() {
      loading = true;
    });
    FormData formData = FormData.fromMap({
      "server": "45.35.97.83",
      "username": "SIMPLYSOFT",
      "password": "PK@26~10#\$7860MP676\$",
      "database": "DB_SIMPLYSOFT_MOBILE_AGENCY",
      "search": value.toString()
    });
    response = await dio.post(Constants.PAYMENT_SEARCH, data: formData);
    apidata = json.decode(response.data);
    loading = false;
    setState(() {});
  }

  _PaymentState() {
    searchBar = SearchBar(
        inBar: false,
        setState: setState,
        buildDefaultAppBar: buildAppBar,
        onSubmitted: onSubmitted,
        onCleared: () {
          print("cleared");
        },
        onClosed: () {
          print("closed");
        });
  }

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        TextButton.styleFrom(primary: Theme.of(context).colorScheme.onPrimary);
    return Scaffold(
        appBar: searchBar.build(context),
        body: loading
            ? const CircularProgressIndicator()
            : ListView(
                children: apidata["data"].map<Widget>((result) {
                return InkWell(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text("VCH DATE: " + result['VCHDT']),
                              Text("VCHNO: " + result['VCHNO'])
                            ],
                          ),
                          const SizedBox(
                            height: 8,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text("NARRATION: " + result['NARRATION']),
                              Text(
                                "TOTAL AMT:" + result['TOTAL_AMT'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ReceiptPaymentDetail(
                                "Payment",
                                result['ENTRYID'].toString(),
                                result['TOTAL_AMT'].toString())));
                  },
                );
              }).toList()));
  }

  void getData() async {
    setState(() {
      loading = true; //make loading true to show progressindicator
    });
    FormData formData = FormData.fromMap({
      "server": "45.35.97.83",
      "username": "SIMPLYSOFT",
      "password": "PK@26~10#\$7860MP676\$",
      "database": "DB_SIMPLYSOFT_MOBILE_AGENCY"
    });
    response = await dio.post(Constants.PAYMENT, data: formData);
    apidata = json.decode(response.data);
    print(apidata['data']);
    loading = false;
    setState(() {});
  }
  void customDateRange(context) async{
    DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
        initialDateRange:
        DateTimeRange(start: DateTime.now(), end: DateTime.now()));
    print(picked);
  }
}
