/// Flutter code sample for AppBar

import 'package:flutter/material.dart';

/// This is the stateless widget that the main application instantiates.
class Dispatch extends StatefulWidget {
  const Dispatch({Key? key}) : super(key: key);

  @override
  State<Dispatch> createState() => _DispatchState();
}

class _DispatchState extends State<Dispatch> {

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
    TextButton.styleFrom(primary: Theme
        .of(context)
        .colorScheme
        .onPrimary);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Dispatch"),
          actions: <Widget>[
            IconButton(onPressed: (){}, icon: const Icon(Icons.search)),
            IconButton(onPressed: (){}, icon: const Icon(Icons.calendar_today))
          ],
        ),
        body: ListView(
          children: [
            Card(
              child: Padding(padding: EdgeInsets.all(10),
                child:Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text("VCH NO;-"),
                        Text("DATE:-")
                      ],
                    ),
                    const SizedBox(height: 8,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text("NAME:-"),
                      ],
                    ),
                    const SizedBox(height: 8,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("QTY:-"),
                        Text("AMT:-")
                      ],
                    ),
                  ],
                ),),
            ),
            Card(
              child: Padding(padding: EdgeInsets.all(10),
                child:Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text("VCH NO;-"),
                        Text("DATE:-")
                      ],
                    ),
                    const SizedBox(height: 8,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text("NAME:-"),
                      ],
                    ),
                    const SizedBox(height: 8,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("QTY:-"),
                        Text("AMT:-")
                      ],
                    ),
                  ],
                ),),
            ),
            Card(
              child: Padding(padding: EdgeInsets.all(10),
                child:Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text("VCH NO;-"),
                        Text("DATE:-")
                      ],
                    ),
                    const SizedBox(height: 8,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text("NAME:-"),
                      ],
                    ),
                    const SizedBox(height: 8,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("QTY:-"),
                        Text("AMT:-")
                      ],
                    ),
                  ],
                ),),
            ),
            Card(
              child: Padding(padding: EdgeInsets.all(10),
                child:Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text("VCH NO;-"),
                        Text("DATE:-")
                      ],
                    ),
                    const SizedBox(height: 8,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: const [
                        Text("NAME:-"),
                      ],
                    ),
                    const SizedBox(height: 8,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const [
                        Text("QTY:-"),
                        Text("AMT:-")
                      ],
                    ),
                  ],
                ),),
            )
          ],
        )
    );
  }
}
