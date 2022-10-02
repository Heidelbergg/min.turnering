import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:widget_loading/widget_loading.dart';

import 'create_edit_event.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventID;
  const EventDetailsScreen({Key? key, required this.eventID}) : super(key: key);

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool isCompleted = false;
  bool loading = true;

  late String eventName = "";
  late String eventType = "";
  late String eventTime = "";
  late String eventDate = "";
  late String participants = "";
  late String queue = "";
  late Icon icon = const Icon(null);

  Map icons = {
    'Fodbold': Icons.sports_soccer,
    'Padel': Icons.sports_tennis,
    'Basketbold': Icons.sports_basketball,
    'Andet': Icons.sports_handball
  };

  _getEventDetails(){
    FirebaseFirestore.instance.collection('eventList').doc(widget.eventID).get().then((value){
      setState(() {
        eventName = value['eventName'];
        eventType = value['category'];
        eventTime = value['time'];
        eventDate = value['date'];
        participants = value['participants'].length.toString();
        queue = value['queue'].length.toString();
        icon = Icon(icons[value['category']],);

        if (value['facilitator'] == FirebaseAuth.instance.currentUser?.uid){
          /// navigate to edit event
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ManageEventScreen(create: false, eventID: value.id,)));
        }
        loading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), (){
      _getEventDetails();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading? CircularWidgetLoading(
        dotColor: const Color(0xFF42BEA5),
          child: Container()) : Container(
        height: MediaQuery.of(context).size.height / 1.75,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20.0),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.75),
              blurRadius: 1.0,
              spreadRadius: 0.5,
              offset: Offset(0.0, 1.0), // shadow direction: bottom right
            )
          ],
        ),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 50),
              child: BackButton(color: Colors.grey,)
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 15, bottom: 30, top: 5,),
                child: Text(eventName,
                  style: TextStyle(color: Colors.black, fontSize: 34, fontWeight: FontWeight.w700),)),
            Row(
              children: [
                Container(
                    padding: EdgeInsets.only(left: 20, right: 10),
                    child: Text(eventType, style: TextStyle(color: Colors.grey, fontSize: 14),)),
                icon,
                const Spacer(),
                Container(
                  padding: EdgeInsets.only(right: 10),
                    child: TextButton(onPressed: () {
                      // see participants
                    }, child: Text("${participants} deltagere (${queue}) i kø", style: TextStyle(color: Colors.grey, fontSize: 14),),))
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
                child: const Divider(thickness: 1, color: Colors.grey, height: 40)),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(right: 10, top: 20, left: 20),
                child: Text("Arrangeret af: ${widget.eventID}", style: TextStyle(color: Colors.grey, fontSize: 14))),
            Container(
              alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(right: 10, top: 20, left: 20),
                child: Text('${DateFormat.EEEE('da_DK').format(DateTime.parse(eventDate))} ${eventTime}', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700))),
            Container(
              padding: EdgeInsets.only(right: 10, top: 60, left: 10),
              child: ElevatedButton(onPressed: (){
                //Navigator.push(context, MaterialPageRoute(builder: (context) => const AllEventsScreen()));
              },
                child: Text(isCompleted? "Event udført" : "Deltag", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: isCompleted? Colors.white70 : Colors.white)),
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(300, 60)),
                    backgroundColor: MaterialStateProperty.all<Color>(isCompleted? Colors.grey : const Color(0xFF42BEA5)),
                    elevation: MaterialStateProperty.all(3),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                ),),
            ),
          ],
        ),
      ),
    );
  }
}
