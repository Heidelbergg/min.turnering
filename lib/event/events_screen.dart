import 'package:flutter/material.dart';

import '../assets/bezier_clipper.dart';

class AllEventsScreen extends StatefulWidget {
  const AllEventsScreen({Key? key}) : super(key: key);

  @override
  State<AllEventsScreen> createState() => _AllEventsScreenState();
}

class _AllEventsScreenState extends State<AllEventsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF42BEA5),
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text('Events', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),),
        toolbarHeight: 100,
      ),
      floatingActionButton: FloatingActionButton(onPressed: () {}, backgroundColor: const Color(0xFF42BEA5), child: Icon(Icons.add)),
      body: Column(
        children: [
          ClipPath(
            clipper: EventHeaderCustomClipPath(),
            child: Container(
              height: MediaQuery.of(context).size.height / 12,
              color: const Color(0xFF42BEA5),
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20, top: 20),
              child: Text("Kommende events",
                style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),)),

        ],
      ),
    );
  }
}