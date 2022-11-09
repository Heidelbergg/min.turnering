import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:min_turnering/assets/event_card.dart';
import 'package:min_turnering/event/create_edit_event.dart';
import 'package:intl/intl.dart';
import 'package:min_turnering/event/event_details.dart';
import '../assets/bezier_clipper.dart';

class AllEventsScreen extends StatefulWidget {
  const AllEventsScreen({Key? key}) : super(key: key);

  @override
  State<AllEventsScreen> createState() => _AllEventsScreenState();
}

class _AllEventsScreenState extends State<AllEventsScreen> {
  get events => FirebaseFirestore.instance.collection('eventList');

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Map icon = {
    'Fodbold': Icons.sports_soccer,
    'Padel': Icons.sports_tennis,
    'Basketbold': Icons.sports_basketball,
    'Andet': Icons.people
  };

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
      floatingActionButton: FloatingActionButton(onPressed: () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => const ManageEventScreen(create: true)));
      }, backgroundColor: const Color(0xFF42BEA5), child: Icon(Icons.add)),
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
              child: Text("Kommende events",
                style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),)),
          StreamBuilder(
              stream: events.snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: snapshot.data!.docs.map((event){
                      if (DateTime.parse(event['date']).isAfter(DateTime.now())){
                        return EventCard(
                            text: event['eventName'],
                            day: DateFormat('dd/MM/yyyy').format(DateTime.parse(event['date'])),
                            icon: Icon(icon[event['category']]),
                            time: event['time'],
                            check: event['participants'].contains(FirebaseAuth.instance.currentUser?.uid) ? true : false,
                            queue: event['queue'].contains(FirebaseAuth.instance.currentUser?.uid) ? true : false,
                            onPressed: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => EventDetailsScreen(eventID: event.id)));
                            });
                      } else {
                        return Container();
                      }
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Icon(Icons.error_outline);
                } else {
                  return CircularProgressIndicator.adaptive();
                }
              })
        ],
      ),
    );
  }
}