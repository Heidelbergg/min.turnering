import 'package:another_flushbar/flushbar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:min_turnering/main_screens/navigation.dart';
import 'package:widget_loading/widget_loading.dart';

class ManageEventScreen extends StatefulWidget {
  final bool create;
  final String? eventID;
  const ManageEventScreen({Key? key, required this.create, this.eventID}) : super(key: key);

  @override
  State<ManageEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<ManageEventScreen> {
  late bool createEvent = widget.create;

  List<String> dropdownItems = ['Fodbold', 'Padel', 'Basketbold', 'Andet'];
  String? selectedItem = 'Fodbold';
  bool loading = true;
  late TimeOfDay time = const TimeOfDay(hour: 09, minute: 00);
  late DateTime selectedDate = DateTime.now();
  late int amount = 2;
  late List participantNames = [];
  late List participants = [];

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final eventNameController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    createEvent? loading = false : Future.delayed(const Duration(seconds: 1), (){
      _loadDataFromDB();
      _getParticipants();
    });
  }

  @override
  void dispose() {
    super.dispose();
  }
  
  _loadDataFromDB() {
    FirebaseFirestore.instance.collection('eventList').doc(widget.eventID).get().then((value) {
      eventNameController.text = value['eventName'];
      dateController.text =  DateFormat('dd/MM/yyyy').format(DateTime.parse(value['date']));
      timeController.text = value['time'];
      amountController.text = value['maxParticipants'].toString();
      amount = value['maxParticipants'];
      participants = value['participants'];

      time = TimeOfDay(hour: int.parse(timeController.text.substring(0,2)), minute: int.parse(timeController.text.substring(3)));
      amount = int.parse(amountController.text);
    });
  }

  _getParticipants() async {
    var userRef = await FirebaseFirestore.instance.collection('users').get();
    participantNames = [];
    for (var participant in participants){
      for (var users in userRef.docs){
        if (users.id == participant){
          participantNames.add(users['name']);
        }
      }
    }
    setState(() {
      loading = false;
    });
  }

  String? validateName(String? name){
    if (name == null || name.isEmpty || name == ""){
      return "Indsæt gyldigt navn";
    }
  }

  String? validateAmount(String? num){
    if (num == null || int.parse(num) < 2 || int.parse(num).isNegative || num.isEmpty){
      return 'Ugyldigt nummer';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: const Color(0xFF42BEA5),
        title: Text(createEvent? 'Opret event' : 'Rediger event', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),),
        actions: [createEvent? Container() : IconButton(onPressed: (){
          /// show alertBox before deletion
          Dialogs.bottomMaterialDialog(
              msg: 'Er du sikker? Du kan ikke fortryde denne handling',
              title: 'Slet event',
              context: context,
              actions: [
                IconsOutlineButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  text: 'Anuller',
                  iconData: Icons.cancel_outlined,
                  textStyle: TextStyle(color: Colors.grey),
                  iconColor: Colors.grey,
                ),
                IconsButton(
                  onPressed: () async {
                    var createdDocs = await FirebaseFirestore.instance.collection('users')
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .collection('createdEvents').get();
                    var participated = await FirebaseFirestore.instance.collection('users')
                        .doc(FirebaseAuth.instance.currentUser?.uid)
                        .collection('participatedEvents').get();

                    FirebaseFirestore.instance.collection('eventList').doc(widget.eventID).delete();

                    for (var docs in createdDocs.docs){
                      if (widget.eventID == docs['reference'] && docs['id'] == docs.id){
                        docs.reference.delete();
                      }
                    }
                    for (var docs in participated.docs){
                      if (widget.eventID == docs['reference'] && docs['id'] == docs.id){
                        docs.reference.delete();
                      }
                    }
                    if(!mounted)return;
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const Dashboard()));
                    Flushbar(
                        margin: EdgeInsets.all(10),
                        borderRadius: BorderRadius.circular(10),
                        title: 'Dit event',
                        backgroundColor: Colors.green,
                        duration: Duration(seconds: 3),
                        message: 'Eventet er blevet fjernet succesfuldt',
                        flushbarPosition: FlushbarPosition.BOTTOM).show(context);
                  },
                  text: 'Slet',
                  iconData: Icons.delete,
                  color: Colors.red,
                  textStyle: TextStyle(color: Colors.white),
                  iconColor: Colors.white,
                ),
              ]);
        }, icon: const Icon(Icons.delete_outline, color: Colors.red, size: 28,))],
        toolbarHeight: 75,
        leading: const BackButton(),
      ),
      body: loading? CircularWidgetLoading(
          dotColor: const Color(0xFF42BEA5),
          child: Container()) : Form(
        key: _key,
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(left: 20, top: 40, bottom: 20),
                child: const Text("Udfyld nedenstående felter for dit event.",
                  style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),)),
            Container(
                padding: EdgeInsets.only(left: 15, right: 20, top: 20, bottom: 20),
                child: TextFormField(
                    validator: validateName,
                    keyboardType: TextInputType.text,
                    controller: eventNameController,
                    decoration: InputDecoration(fillColor: Colors.grey.withOpacity(0.25), filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      enabledBorder:
                      OutlineInputBorder(borderSide: const BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(15)), labelText: 'Eventnavn', labelStyle: const TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.black,),
                          borderRadius: BorderRadius.circular(15)
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      hintText: "Indtast eventnavn...", hintStyle: TextStyle(color: Colors.grey),),),
                ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                    padding: const EdgeInsets.only(left: 15, right: 20, top: 20, bottom: 20),
                    child: InkWell(
                      onTap: () async {
                        selectedDate = (await showDatePicker(
                                builder: (context, child) {
                                  return Theme(data: Theme.of(context).copyWith(
                                      colorScheme: const ColorScheme.light(
                                        primary: Color(0xFF42BEA5), // header background color
                                        onPrimary: Colors.white, // header text color
                                        onSurface: Colors.black,
                                      )
                                  ),
                                      child: child!);
                                },
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime.now(),
                                lastDate: DateTime.now().add(Duration(days: 90)))
                        )!;
                        setState(() {
                          selectedDate;
                          dateController.text = DateFormat('dd/MM/yyyy').format(selectedDate);
                        });
                      },
                      child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: dateController,
                        enabled: false,
                          decoration: InputDecoration(fillColor: Colors.grey.withOpacity(0.25), filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                            enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(15)), labelText: 'Dato', labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black,),
                                borderRadius: BorderRadius.circular(15)
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: DateFormat('dd/MM/yyyy').format(selectedDate), hintStyle: TextStyle(color: Colors.black),),),
                    ),
                    ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                    padding: EdgeInsets.only(left: 15, right: 20, top: 20, bottom: 20),
                    child: InkWell(
                      onTap: () async {
                      time = (await showTimePicker(context: context,
                              builder: (context, child) {
                                return Theme(data: Theme.of(context).copyWith(
                                    colorScheme: const ColorScheme.light(
                                      primary: const Color(0xFF42BEA5), // header background color
                                      onPrimary: Colors.white, // header text color
                                      onSurface: Colors.black,
                                    )
                                ),
                                    child: child!);
                              },
                              initialTime: TimeOfDay(hour: 09, minute: 00)))!;
                      setState(() {
                        time;
                        timeController.text = time.format(context);
                      });
                      },
                      child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: timeController,
                        enabled: false,
                          decoration: InputDecoration(fillColor: Colors.grey.withOpacity(0.25), filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                            enabledBorder:
                            OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent),
                                borderRadius: BorderRadius.circular(15)), labelText: 'Tid', labelStyle: TextStyle(color: Colors.black),
                            focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black,),
                                borderRadius: BorderRadius.circular(15)
                            ),
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            hintText: time.format(context).toString(), hintStyle: TextStyle(color: Colors.black),),),
                    ),
                    ),
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 15, right: 15, top: 20, bottom: 20),
              child: DropdownButtonFormField<String>(
                decoration: InputDecoration(fillColor: Colors.grey.withOpacity(0.25), filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  enabledBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(15)), labelText: 'Kategori', labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black,),
                      borderRadius: BorderRadius.circular(15)
                  ), floatingLabelBehavior: FloatingLabelBehavior.always),
                value: selectedItem ,
                items: dropdownItems.map((item) =>
                    DropdownMenuItem<String>(value: item, child: Text(item))).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedItem = value;
                  });
                },),
            ),
            createEvent? Container() : Container(
              padding: EdgeInsets.only(left: 15, right: 20, top: 20, bottom: 20),
              child: InkWell(
                onTap: () {
                  /// TODO show alertdialog with textButton for the names - click on them prompts for removal of user
                  showDialog(context: context, builder: (context) {
                    return AlertDialog(
                      title: Text("Deltagere"),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: participants.map((e) {
                          return TextButton(onPressed: () async {
                            Dialogs.bottomMaterialDialog(
                                msg: 'Er du sikker? Du kan ikke fortryde denne handling',
                                title: 'Fjern deltager',
                                context: context,
                                actions: [
                                  IconsOutlineButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    text: 'Anuller',
                                    iconData: Icons.cancel_outlined,
                                    textStyle: TextStyle(color: Colors.grey),
                                    iconColor: Colors.grey,
                                  ),
                                  IconsButton(
                                    onPressed: () async {
                                      /// Remove user remove from eventList db
                                      if (e == FirebaseAuth.instance.currentUser?.uid){
                                        Flushbar(
                                            margin: EdgeInsets.all(10),
                                            borderRadius: BorderRadius.circular(10),
                                            title: 'Fjern fra event',
                                            backgroundColor: Colors.red,
                                            duration: Duration(seconds: 3),
                                            message: 'Du kan ikke fjerne dig selv fra eventet',
                                            flushbarPosition: FlushbarPosition.BOTTOM).show(context);
                                        return;
                                      } else {
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


                                        /// remove document from participatedEvents
                                        var participatedDocs = await FirebaseFirestore.instance.collection('users')
                                            .doc(FirebaseAuth.instance.currentUser?.uid)
                                            .collection('participatedEvents').get();

                                        for (var docs in participatedDocs.docs){
                                          if (widget.eventID == docs['reference'] && docs['id'] == docs.id){
                                            docs.reference.delete();
                                          }
                                        }
                                        /// remove user from queue
                                        FirebaseFirestore.instance.collection('eventList').doc(widget.eventID).update({
                                          'queue': FieldValue.arrayRemove([FirebaseAuth.instance.currentUser?.uid])
                                        });
                                        if (!mounted) return;
                                        Navigator.push(context, MaterialPageRoute(builder: (context) => const Dashboard()));
                                        Flushbar(
                                            margin: EdgeInsets.all(10),
                                            borderRadius: BorderRadius.circular(10),
                                            title: 'Fjern fra event',
                                            backgroundColor: Colors.green,
                                            duration: Duration(seconds: 3),
                                            message: '${participantNames[participants.indexOf(e)].toString()} er nu fjernet',
                                            flushbarPosition: FlushbarPosition.BOTTOM).show(context);
                                      }
                                    },
                                    text: 'Fjern deltager',
                                    iconData: Icons.delete,
                                    color: Colors.red,
                                    textStyle: TextStyle(color: Colors.white),
                                    iconColor: Colors.white,
                                  ),
                                ]);
                          }, child: Text(participantNames[participants.indexOf(e)].toString(), style: TextStyle(color: Colors.blue),));
                        }).toList()
                      ),
                      actions: [
                        TextButton(onPressed: (){Navigator.pop(context);}, child: Text("OK"))
                      ],
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    );
                  });
                },
                child: TextFormField(
                  enabled: false,
                  decoration: InputDecoration(fillColor: Colors.grey.withOpacity(0.25), filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    enabledBorder:
                    OutlineInputBorder(borderSide: const BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(15)), labelText: 'Deltagere', labelStyle: const TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black,),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: participantNames.toString().replaceAll("[", "").replaceAll("]", ""), hintStyle: TextStyle(color: Colors.grey),),),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  padding: EdgeInsets.only(left: 15, right: 20, top: 20, bottom: 20),
                  child: TextFormField(
                    validator: validateAmount,
                      keyboardType: TextInputType.number,
                      controller: amountController,
                      decoration: InputDecoration(fillColor: Colors.grey.withOpacity(0.25), filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                        enabledBorder:
                        OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent),
                            borderRadius: BorderRadius.circular(15)), labelText: 'Maks deltagere', labelStyle: TextStyle(color: Colors.black),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black,),
                            borderRadius: BorderRadius.circular(15)
                        ),
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                        hintText: amount.toString(), hintStyle: TextStyle(color: Colors.grey),),),
                ),
                
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 15, top: 20, bottom: 20),
                    child: ElevatedButton(onPressed: (){
                      var ref = FirebaseFirestore.instance.collection('eventList').doc();
                      if (_key.currentState!.validate()){
                        if (createEvent){
                          /// create db record in EventList
                          ref.set({
                            'eventName': eventNameController.text.trim(),
                            'facilitator': FirebaseAuth.instance.currentUser?.uid,
                            'date': selectedDate.toString(),
                            'time': time.format(context).toString(),
                            'category': selectedItem.toString(),
                            'maxParticipants': int.parse(amountController.text.trim()),
                            'queue': [],
                            'participants': [FirebaseAuth.instance.currentUser?.uid]
                          });
                          /// create db reference in user subcollection 'createdEvents'
                          var createdRef = FirebaseFirestore
                              .instance
                              .collection('users')
                              .doc(FirebaseAuth.instance.currentUser?.uid)
                              .collection('createdEvents')
                              .doc();

                          createdRef.set({
                            'id': createdRef.id.toString(),
                            'reference': ref.id.toString()
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Dashboard()));
                          Flushbar(
                              margin: EdgeInsets.all(10),
                              borderRadius: BorderRadius.circular(10),
                              title: 'Nyt event',
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 3),
                              message: 'Eventet er blevet oprettet succesfuldt',
                              flushbarPosition: FlushbarPosition.BOTTOM).show(context);
                        } else if (createEvent == false){
                          /// update db record in EventList
                          FirebaseFirestore.instance.collection('eventList')
                              .doc(widget.eventID)
                              .update({
                            'eventName': eventNameController.text.trim(),
                            'date': selectedDate.toString(),
                            'time': time.format(context).toString(),
                            'category': selectedItem.toString(),
                            'maxParticipants': int.parse(amountController.text.trim()),
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Dashboard()));
                          Flushbar(
                              margin: EdgeInsets.all(10),
                              borderRadius: BorderRadius.circular(10),
                              title: 'Dit event',
                              backgroundColor: Colors.green,
                              duration: Duration(seconds: 3),
                              message: 'Eventet er blevet opdateret succesfuldt',
                              flushbarPosition: FlushbarPosition.BOTTOM).show(context);
                        }
                      }
                    },
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(const Size(200, 60)),
                          backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF42BEA5)),
                          elevation: MaterialStateProperty.all(3),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                      ),
                      child: Text(createEvent? "Opret event" : 'Gem redigering', style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white)),),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
