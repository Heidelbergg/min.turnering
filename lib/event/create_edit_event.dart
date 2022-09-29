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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height / 1.25,
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
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 20, left: 5),
              child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20,),),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20, bottom: 20, top: 10),
                child: Text("Opret event",
                  style: TextStyle(color: Colors.black, fontSize: 34, fontWeight: FontWeight.w700),)),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 20, bottom: 10),
                child: Text("Udfyld nedenstående felter for dit event.",
                  style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),)),
            Container(
                padding: EdgeInsets.only(left: 15, right: 20, top: 20, bottom: 20),
                child: TextFormField(
                    //validator: validateName,
                    keyboardType: TextInputType.text,
                    //controller: surnameController,
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
                      onTap: () {},
                      child: TextFormField(
                          //validator: validateName,
                          keyboardType: TextInputType.text,
                          //controller: surnameController,
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
                          //validator: validateName,
                          keyboardType: TextInputType.text,
                          //controller: surnameController,
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
                      //validator: validateName,
                      keyboardType: TextInputType.number,
                      //controller: surnameController,
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
                Expanded(
                  child: Container(
                    padding: EdgeInsets.only(right: 15, top: 20, bottom: 20),
                    child: ElevatedButton(onPressed: (){
                      //Navigator.push(context, MaterialPageRoute(builder: (context) => const AllEventsScreen()));
                    },
                      child: Text(createEvent? "Opret event" : 'Gem redigering', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white)),
                      style: ButtonStyle(
                          minimumSize: MaterialStateProperty.all(const Size(200, 60)),
                          backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF42BEA5)),
                          elevation: MaterialStateProperty.all(3),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                      ),),
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
