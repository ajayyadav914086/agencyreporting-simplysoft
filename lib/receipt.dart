import 'dart:convert';
import 'dart:io';
import 'package:agencyreporting/Rcptandpymtdetail.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_search_bar/flutter_search_bar.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share/share.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'constants.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class Receipt extends StatefulWidget {
  const Receipt({Key? key}) : super(key: key);

  @override
  State<Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<Receipt> {
  late Response response;
  Dio dio = Dio();
  var apidata;
  bool loading = false;
  bool isDataEmpty = false;
  late ScrollController _controller;
  late SearchBar searchBar;
  late var startdate;
  late var enddate;
  DateFormat dateFormat = DateFormat("yyyy/MM/dd");
  late SharedPreferences pref;

  @override
  void initState() {
    startdate = dateFormat.format(DateTime.now().subtract(Duration(days: 30)));
    enddate = dateFormat.format(DateTime.now());
    getData(startdate, enddate);
    _controller = ScrollController();
    _controller.addListener(_scrollListener);
    super.initState();
  }

  Widget today(context) {
    return SimpleDialogOption(
      child: const Text('Today'),
      onPressed: () {
        final today = dateFormat.format(DateTime.now());
        getData(today, today);
        Navigator.pop(context);
      },
    );
  }

  Widget yesterday(context) {
    return SimpleDialogOption(
      child: const Text('Yesterday'),
      onPressed: () {
        final today = dateFormat.format(DateTime.now());
        final todaydatetime = dateFormat.parse(today);
        final yesterday = todaydatetime.subtract(Duration(days: 1));
        final yesterdayformat = dateFormat.format(yesterday);
        getData(yesterdayformat, yesterdayformat);
        Navigator.pop(context);
      },
    );
  }

  Widget last7days(context) {
    return SimpleDialogOption(
      child: const Text('Last 7 Days'),
      onPressed: () {
        final today = dateFormat.format(DateTime.now());
        final todaydatetime = dateFormat.parse(today);
        final week = todaydatetime.subtract(Duration(days: 7));
        final weekformat = dateFormat.format(week);
        getData(weekformat, today);
        Navigator.pop(context);
      },
    );
  }

  Widget last30days(context) {
    return SimpleDialogOption(
      child: const Text('last 30 Days'),
      onPressed: () {
        final today = dateFormat.format(DateTime.now());
        final todaydatetime = dateFormat.parse(today);
        final month = todaydatetime.subtract(Duration(days: 30));
        final monthformat = dateFormat.format(month);
        getData(monthformat, today);
        Navigator.pop(context);
      },
    );
  }

  Widget last365days(context) {
    return SimpleDialogOption(
      child: const Text('Last 365 Days'),
      onPressed: () {
        final today = dateFormat.format(DateTime.now());
        final todaydatetime = dateFormat.parse(today);
        final year = todaydatetime.subtract(Duration(days: 365));
        final yearformat = dateFormat.format(year);
        getData(yearformat, today);
        Navigator.pop(context);
      },
    );
  }

  Widget customdate(context) {
    return SimpleDialogOption(
      child: const Text('Custom Date'),
      onPressed: () {
        Navigator.pop(context);
        customDateRange(context);
      },
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text("Receipt"),
      actions: <Widget>[
        searchBar.getSearchAction(context),
        IconButton(
            onPressed: () {
              SimpleDialog dialog = SimpleDialog(
                title: const Text('SELECT ONE OPTION:-'),
                children: <Widget>[
                  today(context),
                  yesterday(context),
                  last7days(context),
                  last30days(context),
                  last365days(context),
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
            icon: const Icon(Icons.calendar_today)),
        IconButton(
            onPressed: () async {
              final pdf = pw.Document();
              pdf.addPage(pw.MultiPage(
                  pageFormat: PdfPageFormat.a4,
                  build: (pw.Context context) {
                    return <pw.Widget>[
                      pw.Center(
                        child: pw.Text("Receipt"),
                      ),
                      pw.SizedBox(
                        height: 24,
                      ),
                      pw.Column(
                          children: apidata["data"].map<pw.Column>((result) {
                        return pw.Column(
                          children: [
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: pw.CrossAxisAlignment.end,
                              children: [
                                pw.Text("VCH DATE: " + result['VCHDT']),
                                pw.Text("VCHNO: " + result['VCHNO'])
                              ],
                            ),
                            pw.SizedBox(
                              height: 8,
                            ),
                            pw.Row(
                              mainAxisAlignment:
                                  pw.MainAxisAlignment.spaceBetween,
                              children: [
                                pw.Text("NARRATION: " + result['NARRATION']),
                                pw.Text(
                                  "TOTAL AMT:" + result['TOTAL_AMT'],
                                  style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold,
                                      color: PdfColors.red),
                                )
                              ],
                            ),
                            pw.SizedBox(
                              height: 16,
                            ),
                            pw.Divider(color: PdfColors.black)
                          ],
                        );
                      }).toList())
                    ];
                  }));
              Directory appDocDir = await getApplicationDocumentsDirectory();
              String appDocPath = appDocDir.path;
              final file = File(appDocPath + '/example.pdf');
              await file.writeAsBytes(await pdf.save());
              Share.shareFiles([appDocPath + '/example.pdf'],
                  text: 'Great picture');
            },
            icon: Icon(Icons.share))
      ],
    );
  }

  void onSubmitted(String value) async {
    apidata = [];
    setState(() {
      loading = true;
    });
    FormData formData = FormData.fromMap({
      "server": pref.get("ip"),
      "username": pref.get("username"),
      "password": pref.get("password"),
      "database": pref.get("database"),
      "search": value.toString()
    });
    response = await dio.post(Constants.RECEIPT_SEARCH, data: formData);
    apidata = json.decode(response.data);
    loading = false;
    setState(() {});
  }

  _ReceiptState() {
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
            : isDataEmpty
                ? const Center(child: Text("No Data"))
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
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
                                      "Receipt",
                                      result['ENTRYID'].toString(),
                                      result['TOTAL_AMT'].toString())));
                        },
                      );
                    }).toList()));
  }

  void getData(startdate, enddate) async {
    setState(() {
      loading = true;
      isDataEmpty = false;
    });
    pref = await SharedPreferences.getInstance();
    FormData formData = FormData.fromMap({
      "server": pref.get("ip"),
      "username": pref.get("username"),
      "password": pref.get("password"),
      "database": pref.get("database"),
      "startdate": startdate,
      "enddate": enddate,
    });
    response = await dio.post(Constants.RECEIPT, data: formData);
    apidata = json.decode(response.data);
    if (apidata['response'] == 404) {
      setState(() {
        isDataEmpty = true;
      });
    }
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

  void customDateRange(context) async {
    DateTimeRange? picked = await showDateRangePicker(
        context: context,
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime(DateTime.now().year + 5),
        initialDateRange:
            DateTimeRange(start: DateTime.now(), end: DateTime.now()));
    print(picked);
    var startdate = picked?.start;
    var formattedstartdate = dateFormat.format(startdate!);
    var enddate = picked?.end;
    var formattedenddate = dateFormat.format(enddate!);
    getData(formattedstartdate, formattedenddate);
  }
}
