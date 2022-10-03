import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:min_turnering/event/events_screen.dart';

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
  late TimeOfDay time = const TimeOfDay(hour: 9, minute: 0);
  late DateTime selectedDate = DateTime.now();
  late String amount = '2';

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final eventNameController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    amountController.text = '2';
  }

  @override
  void dispose() {
    super.dispose();
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
        title: Text(createEvent? 'Opret event' : 'Rediger event', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),),
        toolbarHeight: 75,
        leading: BackButton(),
      ),
      body: Form(
        key: _key,
        child: Column(
          children: [
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20, top: 40, bottom: 20),
                child: Text("Udfyld nedenstående felter for dit event.",
                  style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),)),
            Container(
                padding: EdgeInsets.only(left: 15, right: 20, top: 20, bottom: 20),
                child: TextFormField(
                    validator: validateName,
                    keyboardType: TextInputType.text,
                    controller: eventNameController,
                    decoration: InputDecoration(fillColor: Colors.grey.withOpacity(0.25), filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                      enabledBorder:
                      OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent),
                          borderRadius: BorderRadius.circular(15)), labelText: 'Eventnavn', labelStyle: TextStyle(color: Colors.black),
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black,),
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
                    padding: EdgeInsets.only(left: 15, right: 20, top: 20, bottom: 20),
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
                
                Container(
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
                        FirebaseFirestore.instance.collection('users')
                            .doc(FirebaseAuth.instance.currentUser?.uid)
                            .collection('createdEvents')
                            .doc()
                            .set({'reference': FirebaseFirestore.instance.collection('eventList').doc(ref.id)});
                        Navigator.pop(context);
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
                        Navigator.pop(context);
                      }
                    }
                  },
                    child: Text(createEvent? "Opret event" : 'Gem redigering', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white)),
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(const Size(200, 60)),
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF42BEA5)),
                        elevation: MaterialStateProperty.all(3),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                    ),),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
