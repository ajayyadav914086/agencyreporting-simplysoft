/// Flutter code sample for AppBar

import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:intl/intl.dart';

import 'constants.dart';
import 'dispatchdetail.dart';

/// This is the stateless widget that the main application instantiates.
class Dispatch extends StatefulWidget {
  const Dispatch({Key? key}) : super(key: key);

  @override
  State<Dispatch> createState() => _DispatchState();
}

class _DispatchState extends State<Dispatch> {
  late Response response;
  Dio dio = Dio();
  var apidata;
  bool loading = false;
  late ScrollController _controller;
  late SearchBar searchBar;

  @override
  void initState() {
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
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

  AppBar buildAppBar(BuildContext context){
    return AppBar(
      title: const Text("Dispatch"),
      actions: <Widget>[
        searchBar.getSearchAction(context),
        IconButton(onPressed: () {
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
        }, icon: const Icon(Icons.calendar_today))
      ],
    );
  }
  void onSubmitted(String value) async{
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
    response = await dio.post(Constants.DISPATCH_SEARCH, data: formData);
    apidata = json.decode(response.data);
    loading = false;
    setState(() {});
  }

  _DispatchState(){
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
    return Scaffold(
        appBar: searchBar.build(context),
        body: loading
            ? const CircularProgressIndicator()
            : ListView(
                controller: _controller,
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
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  "CUSTOMER: " + result['CUSTOMER'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.indigo),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text("SUPPLIER: " + result['SUPPLIER']),
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("BILL DATE: " + result['BILLDT']),
                                Text("BILL NO: " + result['BILLNO'])
                              ],
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("QTY: " + result['QTY']),
                                Text(
                                  "BILL AMT:" + result['BILL_AMT'],
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
                              builder: (context) => DispatchDetail(
                                  result['ENTRYID'].toString())));
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
    response = await dio.post(Constants.DISPATCH, data: formData);
    apidata = json.decode(response.data);
    print(apidata['data']);
    loading = false;
    setState(() {});
  }

  _scrollListener() {
    if (_controller.offset >= _controller.position.maxScrollExtent &&
        !_controller.position.outOfRange) {
      print("Scroll to bottom");
    }
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
