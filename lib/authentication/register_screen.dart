import 'package:flutter/material.dart';
import 'package:min_turnering/authentication/login_screen.dart';
import 'package:min_turnering/main_screens/navigation.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: const Color(0xFF42BEA5),
        title: Text('Registrer', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),),
        toolbarHeight: 75,
        leading: BackButton(),
      ),
      backgroundColor: const Color(0xFF42BEA5),
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 60),
              child: TextFormField(
               //validator: validateName,
                keyboardType: TextInputType.name,
                //controller: surnameController,
                decoration: InputDecoration(fillColor: Color(0xFF359F8A), filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(15)), labelText: 'Navn', labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black,),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: "Indtast dit navn...", hintStyle: TextStyle(color: Colors.black),),)),
          Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: TextFormField(
                //validator: validateName,
                keyboardType: TextInputType.emailAddress,
                //controller: surnameController,
                decoration: InputDecoration(fillColor: Color(0xFF359F8A), filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  enabledBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(15)), labelText: 'Email', labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black,),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: "Indtast din email...", hintStyle: TextStyle(color: Colors.black),),)),
          Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20),
              child: TextFormField(
                //validator: validateName,
                keyboardType: TextInputType.name,
                obscureText: true,
                //controller: surnameController,
                decoration: InputDecoration(fillColor: Color(0xFF359F8A), filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  enabledBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(15)), labelText: 'Adgangskode', labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black,),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: "Indtast en adgangskode...", hintStyle: TextStyle(color: Colors.black),),)),
          Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
              child: TextFormField(
                //validator: validateName,
                keyboardType: TextInputType.name,
                obscureText: true,
                //controller: surnameController,
                decoration: InputDecoration(fillColor: Color(0xFF359F8A), filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  enabledBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(15)), labelText: 'Gentag adgangskode', labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black,),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: "Indtast adgangskode igen...", hintStyle: TextStyle(color: Colors.black),),)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const Dashboard()));
              },
                child: Text("Opret konto", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white)),
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(200, 50)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                    elevation: MaterialStateProperty.all(3),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                ),),
            ],
          ),
          Padding(padding: EdgeInsets.only(top: 30)),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Har du allerede en konto?"),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                }
                    , child: Text("Login", style: TextStyle(color: Colors.white),))
              ],
            ),
          )
        ],
      ),
    );
  }
}
