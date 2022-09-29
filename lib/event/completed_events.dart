import 'package:flutter/material.dart';
import 'package:min_turnering/assets/event_card.dart';
import 'package:min_turnering/event/event_details.dart';

import '../assets/bezier_clipper.dart';

class CompletedEventsScreen extends StatefulWidget {
  const CompletedEventsScreen({Key? key}) : super(key: key);

  @override
  State<CompletedEventsScreen> createState() => _CompletedEventsScreenState();
}

class _CompletedEventsScreenState extends State<CompletedEventsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF42BEA5),
        automaticallyImplyLeading: false,
        centerTitle: false,
        title: Text('Dine events', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),),
        toolbarHeight: 100,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          ClipPath(
            clipper: EventHeaderCustomClipPath(),
            child: ClipRRect(
              child: Container(
                height: MediaQuery.of(context).size.height / 12,
                color: const Color(0xFF42BEA5),
              ),
            ),
          ),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20, top: 10, bottom: 20),
              child: Text("Events du har oprettet",
                style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),)),
          EventCard(text: 'Amerikansk Fodbold', day: '17/09/2022', icon: Icon(Icons.sports_football, color: Colors.grey,), time: '17:00', onPressed:(){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const EventDetailsScreen()));
          }),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
              child: Text("Events du tidligere har deltaget i",
                style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),)),
          EventCard(text: 'Fodbold', day: '25/09/2022', icon: Icon(Icons.sports_soccer, color: Colors.grey,), time: '15:00', onPressed:(){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const EventDetailsScreen()));
          }),

        ],
      ),
    );
  }
}
