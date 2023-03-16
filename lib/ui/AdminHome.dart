import 'package:flutter/material.dart';

class AdminHome extends StatefulWidget {
  const AdminHome({Key? key}) : super(key: key);

  @override
  State<AdminHome> createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Flexible(
                  child: ListView(
                    children: <Widget>[
                      ListTile(title: Text("Menu A")),
                      ListTile(title: Text("Menu B")),
                      ListTile(title: Text("Menu C")),
                      ListTile(title: Text("Menu D")),
                      ListTile(title: Text("Menu E")),
                      ListTile(title: Text("Menu F")),
                      ListTile(title: Text("Menu G")),
                      ListTile(title: Text("Menu H")),
                      ListTile(title: Text("Menu I")),
                      ListTile(title: Text("Menu J")),
                      ListTile(title: Text("Menu K")),
                      ListTile(title: Text("Menu L")),
                      ListTile(title: Text("Menu M")),
                    ],
                  ),
                ),
                Expanded(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text("qweqwe"),
                        Text("qweqwe"),
                        Text("qweqwe"),
                        Text("qweqwe"),
                        Text("qweqwe"),
                      ],
                    ),
                    color: Colors.black26,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
