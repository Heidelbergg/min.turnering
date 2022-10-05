import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:min_turnering/assets/event_card.dart';
import '../assets/bezier_clipper.dart';
import 'event_details.dart';

class CompletedEventsScreen extends StatefulWidget {
  const CompletedEventsScreen({Key? key}) : super(key: key);

  @override
  State<CompletedEventsScreen> createState() => _CompletedEventsScreenState();
}

class _CompletedEventsScreenState extends State<CompletedEventsScreen> {
  get createdEvents => FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('createdEvents');

  get participatedEvents => FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser?.uid)
      .collection('participatedEvents');

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
          StreamBuilder(
              stream: createdEvents.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data!.docs.map((event){
                      return EventHistoryCard(text: event['reference'], onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailsScreen(eventID: event['reference'])));
                      });
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Icon(Icons.error_outline);
                } else {
                  return CircularProgressIndicator.adaptive();
                }
              }),
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 20, top: 20, bottom: 20),
              child: Text("Events du har deltaget i",
                style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),)),
          StreamBuilder(
              stream: participatedEvents.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data!.docs.map((event){
                      return EventHistoryCard(text: event['reference'], onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailsScreen(eventID: event['reference'])));
                      });
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Icon(Icons.error_outline);
                } else {
                  return CircularProgressIndicator.adaptive();
                }
              }),
        ],
      ),
    );
  }
}
