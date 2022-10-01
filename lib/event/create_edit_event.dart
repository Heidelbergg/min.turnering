import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ManageEventScreen extends StatefulWidget {
  const ManageEventScreen({Key? key}) : super(key: key);

  @override
  State<ManageEventScreen> createState() => _CreateEventScreenState();
}

class _CreateEventScreenState extends State<ManageEventScreen> {
  late bool createEvent = true;
  List<String> dropdownItems = ['Fodbold', 'Padel', 'Basketbold', 'Andet'];
  String? selectedItem = 'Fodbold';

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final eventNameController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  final amountController = TextEditingController();

  String? validateName(String? name){
    if (name == null || name.isEmpty || name == ""){
      return "Indsæt gyldigt navn";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: const Color(0xFF42BEA5),
        title: Text(createEvent? 'Opret Event' : 'Rediger Event', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),),
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
                      onTap: () {
                        showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(Duration(days: 90)));
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
                            hintText: DateFormat('dd/MM/yyyy').format(DateTime.now()), hintStyle: TextStyle(color: Colors.grey),),),
                    ),
                    ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                    padding: EdgeInsets.only(left: 15, right: 20, top: 20, bottom: 20),
                    child: InkWell(
                      onTap: () {},
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
                            hintText: "09:00", hintStyle: TextStyle(color: Colors.grey),),),
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
                        hintText: '2', hintStyle: TextStyle(color: Colors.grey),),),
                ),
                
                Container(
                  padding: EdgeInsets.only(right: 15, top: 20, bottom: 20),
                  child: ElevatedButton(onPressed: (){
                    if (createEvent){
                      /// create db record in EventList
                      FirebaseFirestore.instance.collection('EventList')
                          .doc('${FirebaseAuth.instance.currentUser?.uid}_${DateTime.now().toString()}')
                          .set({});
                      /// create db record in user subcollection 'createdEvents'
                      FirebaseFirestore.instance.collection('users')
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .collection('createdEvents')
                          .doc('${FirebaseAuth.instance.currentUser?.uid}_${DateTime.now().toString()}')
                          .set({});
                      Navigator.pop(context);
                    } else if (createEvent == false){
                      /// update db reconrd in EventList
                      FirebaseFirestore.instance.collection('EventList')
                          .doc('${FirebaseAuth.instance.currentUser?.uid}_${DateTime.now().toString()}')
                          .update({});
                      /// update db record in user subcollection 'createdEvents'
                      FirebaseFirestore.instance.collection('users')
                          .doc(FirebaseAuth.instance.currentUser?.uid)
                          .collection('createdEvents')
                          .doc('${FirebaseAuth.instance.currentUser?.uid}_${DateTime.now().toString()}')
                          .update({});
                      Navigator.pop(context);
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
