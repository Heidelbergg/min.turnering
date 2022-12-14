import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  late String eventName, facilitator, eventType, eventID, eventTime, eventDate, name = "";
  late bool isInQueue = false;
  late int maxParticipants, participantsLength = 0;
  late List participants, queue, participantsNames, queueNames = [];
  late Icon icon = const Icon(null);

  Map icons = {
    'Fodbold': Icons.sports_soccer,
    'Padel': Icons.sports_tennis,
    'Basketbold': Icons.sports_basketball,
    'Andet': Icons.people
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
        participantsLength = int.parse(value['participants'].length.toString());
        participants = value['participants'];
        queue = value['queue'];
        value['queue'].contains(FirebaseAuth.instance.currentUser?.uid) ? isInQueue = true : null;
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
          });
        });
      });
    });

  }

  _getParticipants() async {
    var userRef = await FirebaseFirestore.instance.collection('users').get();
    participantsNames = [];
    for (var participant in participants){
      for (var users in userRef.docs){
        if (users.id == participant){
          participantsNames.add(users['name']);
        }
      }
    }
    setState(() {
      loading = false;
    });
  }

  _getqueue() async {
    var userRef = await FirebaseFirestore.instance.collection('users').get();
    queueNames = [];
      for (var inQueue in queue){
        for (var users in userRef.docs){
          if (users.id == inQueue){
            queueNames.add(users['name']);
          }
        }
      }
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), (){
      _getEventDetails();
    });
    Future.delayed(const Duration(seconds: 2), (){
      _getqueue();
      _getParticipants();
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
        height: 600,
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
                      /// see participants
                      showDialog(context: context, builder: (context) {
                        return AlertDialog(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          title: Text("Deltagere"),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text("Deltagere i event", style: TextStyle(fontWeight: FontWeight.w700),),
                              Padding(padding: EdgeInsets.only(top: 5)),
                              Text(participantsNames.toString().replaceAll("[", "").replaceAll("]", ""), style: TextStyle(color: Colors.black.withOpacity(0.5)),),
                              Padding(padding: EdgeInsets.only(top: 25)),
                              Text("Deltagere i k??", style: TextStyle(fontWeight: FontWeight.w700),),
                              Padding(padding: EdgeInsets.only(top: 5)),
                              Text(queueNames.toString().replaceAll("[", "").replaceAll("]", ""), style: TextStyle(color: Colors.black.withOpacity(0.5)),),
                            ],
                          ),
                          actions: [
                            TextButton(onPressed: (){Navigator.of(context).pop();}, child: Text("OK"))
                          ],
                        );
                      });
                    }, child: Text("${participantsLength} deltagere (${queue.length.toString()} i k??)", style: TextStyle(color: Colors.blue, fontSize: 14),),))
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
            editable == true || isParticipated == true || isInQueue? Container() : Container(
              padding: EdgeInsets.only(right: 10, top: 60, left: 10),
              child: ElevatedButton(onPressed: (){
                if (isCompleted == false && isParticipated == false && participantsLength < maxParticipants){
                  /// participate the user and save to eventList db
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
                      message: 'Eventet er ikke tilg??ngeligt',
                      flushbarPosition: FlushbarPosition.BOTTOM).show(context);
                  return;
                } else if ((participantsLength) >= maxParticipants) {
                  /// add to queue
                  FirebaseFirestore.instance.collection('eventList').doc(widget.eventID).update({
                    'queue': FieldValue.arrayUnion([FirebaseAuth.instance.currentUser?.uid])
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const Dashboard()));
                  Flushbar(
                      margin: EdgeInsets.all(10),
                      borderRadius: BorderRadius.circular(10),
                      title: 'K??',
                      backgroundColor: Colors.blue,
                      duration: Duration(seconds: 3),
                      message: 'Du er blevet sat i k?? til eventet, da eventet er fuldt booket',
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
                child: Text("Event udf??rt", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white70)),
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(300, 60)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.grey),
                    elevation: MaterialStateProperty.all(3),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                ),),
            ) : Container(),
            (isParticipated == true || isInQueue) && isCompleted == false && editable == false? Container(
              padding: EdgeInsets.only(right: 10, top: 60, left: 10),
              child: ElevatedButton(onPressed: () async {
                if (isCompleted == false && isParticipated == true || isInQueue){
                  /// remove from eventList db
                  if (!isInQueue){
                    FirebaseFirestore.instance.collection('eventList').doc(widget.eventID).update({
                      'participants': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid])
                    });
                    /// check whether queue contains any UIDS
                    /// adds the last item to the participated list (moves user from queue to participation)
                    String queueItemUID;
                    FirebaseFirestore.instance.collection('eventList').doc(widget.eventID).get().then((value) {
                      if (value['participants'].length < value['maxParticipants'] && value['queue'].isNotEmpty){
                        queueItemUID = value['queue'].first;

                        FirebaseFirestore.instance.collection('eventList').doc(widget.eventID).update({
                          'participants': FieldValue.arrayUnion([queueItemUID]),
                        });

                        /// remove the UID after it has been updated in the participants List
                        FirebaseFirestore.instance.collection('eventList').doc(widget.eventID).update({
                          'queue': FieldValue.arrayRemove([queueItemUID])
                        });

                      }
                    });
                  }

                  /// remove document from participatedEvents
                  var participatedDocs = await FirebaseFirestore.instance.collection('users')
                      .doc(FirebaseAuth.instance.currentUser?.uid)
                      .collection('participatedEvents').get();

                  for (var docs in participatedDocs.docs){
                    if (widget.eventID == docs['reference'] && docs['id'] == docs.id){
                      docs.reference.delete();
                    }
                  }
                  if (isInQueue){
                    /// remove user from queue
                    FirebaseFirestore.instance.collection('eventList').doc(widget.eventID).update({
                      'queue': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid])
                    });
                  }
                  if (!mounted) return;
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
