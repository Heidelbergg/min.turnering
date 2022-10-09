import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:widget_loading/widget_loading.dart';

import '../main_screens/navigation.dart';
import 'create_edit_event.dart';

class EventDetailsScreen extends StatefulWidget {
  final String eventID;
  const EventDetailsScreen({Key? key, required this.eventID}) : super(key: key);

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool isCompleted = false;
  bool isParticipated = false;
  bool loading = true;
  bool editable = false;

  late String eventName, facilitator, eventType, eventID, eventTime, participantsLength, queue, eventDate, name = "";
  late int maxParticipants = 0;
  late List participants = [];
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
        facilitator = value['facilitator'];
        eventID = value.id;
        maxParticipants = value['maxParticipants'];
        participantsLength = value['participants'].length.toString();
        participants = value['participants'];
        queue = value['queue'].length.toString();
        icon = Icon(icons[value['category']],);

        if (facilitator == FirebaseAuth.instance.currentUser?.uid){
          editable = true;
        }
        if (participants.contains(FirebaseAuth.instance.currentUser?.uid)){
          isParticipated = true;
        }
        DateTime date = DateTime.parse(eventDate);

        if (date.isBefore(DateTime.now())){
          isCompleted = true;
        }

        FirebaseFirestore.instance.collection('users').doc(facilitator).get().then((value) {
          setState((){
            name = value['name'];
            loading = false;
          });
        });
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
            Padding(padding: EdgeInsets.only(top: 10)),
            Row(
              children: [
                Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.only(left: 15),
                    child: Text(eventName,
                      style: TextStyle(color: Colors.black, fontSize: 34, fontWeight: FontWeight.w700),)),
                const Spacer(),
                editable? Container(
                    padding: EdgeInsets.only(right: 10),
                    child: TextButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ManageEventScreen(create: false, eventID: eventID,))).then((value) {
                        setState(() {
                          _getEventDetails();
                        });
                      });
                    }, child: Text('Rediger', style: TextStyle(color: Colors.blue),))) : Container()
              ],
            ),
            Padding(padding: EdgeInsets.only(bottom: 40)),
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
                    }, child: Text("${participantsLength} deltagere (${queue} i kø)", style: TextStyle(color: Colors.blue, fontSize: 14),),))
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
                child: const Divider(thickness: 1, color: Colors.grey, height: 40)),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(right: 10, top: 20, left: 20),
                child: Text("Arrangeret af: ${name}", style: TextStyle(color: Colors.grey, fontSize: 14))),
            Container(
              alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(right: 10, top: 20, left: 20),
                child: Text('${DateFormat.EEEE('da_DK').format(DateTime.parse(eventDate))} ${eventTime}', style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700))),
            editable == true || isParticipated == true? Container() : Container(
              padding: EdgeInsets.only(right: 10, top: 60, left: 10),
              child: ElevatedButton(onPressed: (){
                if (isCompleted == false && isParticipated == false && (participantsLength.length) < maxParticipants){
                  /// save to eventList db
                  FirebaseFirestore.instance.collection('eventList').doc(widget.eventID).update({
                    'participants' : FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid])
                  });
                  /// save to participatedEvents db subcollection
                  var ref = FirebaseFirestore
                      .instance
                      .collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .collection('participatedEvents')
                      .doc();

                  ref.set({
                    'reference': widget.eventID,
                    'id': ref.id.toString()
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Dashboard()));
                  Flushbar(
                      margin: EdgeInsets.all(10),
                      borderRadius: BorderRadius.circular(10),
                      title: 'Deltag',
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 3),
                      message: 'Du er nu deltaget i eventet',
                      flushbarPosition: FlushbarPosition.BOTTOM).show(context);
                } else if (isCompleted == true){
                  /// show snackbar
                  Flushbar(
                      margin: EdgeInsets.all(10),
                      borderRadius: BorderRadius.circular(10),
                      title: 'Event',
                      backgroundColor: Colors.red,
                      duration: Duration(seconds: 3),
                      message: 'Eventet er ikke tilgængeligt',
                      flushbarPosition: FlushbarPosition.BOTTOM).show(context);
                  return;
                } else if ((participantsLength.length) >= maxParticipants) {
                  /// add to queue

                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Dashboard()));
                  Flushbar(
                      margin: EdgeInsets.all(10),
                      borderRadius: BorderRadius.circular(10),
                      title: 'Kø',
                      backgroundColor: Colors.blue,
                      duration: Duration(seconds: 3),
                      message: 'Du er blevet sat i kø til eventet',
                      flushbarPosition: FlushbarPosition.BOTTOM).show(context);
                }
              },
                child: Text("Deltag", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white)),
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(300, 60)),
                    backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF42BEA5)),
                    elevation: MaterialStateProperty.all(3),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                ),),
            ),
            isCompleted? Container(
              padding: EdgeInsets.only(right: 10, top: 60, left: 10),
              child: ElevatedButton(onPressed: (){},
                child: Text("Event udført", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white70)),
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(300, 60)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                    elevation: MaterialStateProperty.all(3),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                ),),
            ) : Container(),
            isParticipated == true && isCompleted == false && editable == false? Container(
              padding: EdgeInsets.only(right: 10, top: 60, left: 10),
              child: ElevatedButton(onPressed: () async {
                if (isCompleted == false && isParticipated == true){
                  /// remove from eventList db
                  FirebaseFirestore.instance.collection('eventList').doc(widget.eventID).update({
                    'participants': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid])
                  });
                  /// remove document from participatedEvents
                  var participatedDocs = await FirebaseFirestore.instance.collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .collection('participatedEvents').get();

                  for (var docs in participatedDocs.docs){
                    if (widget.eventID == docs['reference'] && docs['id'] == docs.id){
                      docs.reference.delete();
                    }
                  }
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Dashboard()));
                  Flushbar(
                      margin: EdgeInsets.all(10),
                      borderRadius: BorderRadius.circular(10),
                      title: 'Afmeldt event',
                      backgroundColor: Colors.green,
                      duration: Duration(seconds: 3),
                      message: 'Du er nu afmeldt af eventet',
                      flushbarPosition: FlushbarPosition.BOTTOM).show(context);
                } else if (isCompleted == true || isParticipated == true){
                  /// show snackbar
                  return;
                }
              },
                child: Text('Afmeld', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white)),
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(300, 60)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                    elevation: MaterialStateProperty.all(3),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                ),),
            ) : Container(),
        ],
        ),
      ),
    );
  }
}
