import 'package:flutter/material.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({Key? key}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Profilindstillinger', style: TextStyle(fontSize: 22, color: Colors.black, fontWeight: FontWeight.w700),),
        toolbarHeight: 75,
        centerTitle: false,
        leading: BackButton(color: Colors.black,),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height / 2.5,
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
                padding: EdgeInsets.only(left: 15, top: 20, bottom: 20),
                child: Text("Opdater dine oplysninger",
                  style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),)),
            Container(
                padding: EdgeInsets.only(left: 15, right: 20, top: 20),
                child: TextFormField(
                  //validator: validateName,
                  keyboardType: TextInputType.emailAddress,
                  //controller: surnameController,
                  decoration: InputDecoration(prefixIcon: Icon(Icons.person, color: Colors.grey.withOpacity(0.75),), fillColor: Colors.grey.withOpacity(0.25), filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    enabledBorder:
                    OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(15)), labelText: 'Navn', labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black,),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Indtast nyt navn...", hintStyle: TextStyle(color: Colors.grey),),)),
            Container(
                padding: EdgeInsets.only(left: 15, right: 20, top: 20),
                child: TextFormField(
                  //validator: validateName,
                  keyboardType: TextInputType.emailAddress,
                  //controller: surnameController,
                  decoration: InputDecoration(prefixIcon: Icon(Icons.email, color: Colors.grey.withOpacity(0.75),), fillColor: Colors.grey.withOpacity(0.25), filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    enabledBorder:
                    OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(15)), labelText: 'Email', labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black,),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Indtast ny email...", hintStyle: TextStyle(color: Colors.grey),),)),
            Container(
              padding: EdgeInsets.only(right: 10, top: 40, left: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(onPressed: (){
                    //Navigator.push(context, MaterialPageRoute(builder: (context) => const AllEventsScreen()));
                  },
                    child: Text("Gem ændringer", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Colors.white)),
                    style: ButtonStyle(
                        minimumSize: MaterialStateProperty.all(const Size(230, 50)),
                        backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF42BEA5)),
                        elevation: MaterialStateProperty.all(3),
                        shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                    ),),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
