import 'package:flutter/material.dart';
import 'package:min_turnering/authentication/register_screen.dart';
import 'package:min_turnering/main_screens/navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        backgroundColor: const Color(0xFF42BEA5),
        title: Text('Login', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),),
        toolbarHeight: 75,
        leading: BackButton(),
      ),
      backgroundColor: const Color(0xFF42BEA5),
      body: Column(
        children: [
          Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 60),
              child: TextFormField(
                //validator: validateName,
                keyboardType: TextInputType.emailAddress,
                //controller: surnameController,
                decoration: InputDecoration(prefixIcon: Icon(Icons.email), fillColor: Color(0xFF359F8A), filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                  enabledBorder:
                  OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent),
                      borderRadius: BorderRadius.circular(15)), labelText: 'Email', labelStyle: TextStyle(color: Colors.black),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black,),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: "Indtast email...", hintStyle: TextStyle(color: Colors.black),),)),
          Container(
              padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
              child: Focus(
                child: TextFormField(
                  //validator: validateName,
                  keyboardType: TextInputType.name,
                  obscureText: true,
                  //controller: surnameController,
                  decoration: InputDecoration(prefixIcon: Icon(Icons.lock), fillColor: Color(0xFF359F8A), filled: true, border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                    enabledBorder:
                    OutlineInputBorder(borderSide: BorderSide(color: Colors.transparent),
                        borderRadius: BorderRadius.circular(15)), labelText: 'Adgangskode', labelStyle: TextStyle(color: Colors.black),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black,),
                        borderRadius: BorderRadius.circular(15)
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    hintText: "Indtast adgangskode...", hintStyle: TextStyle(color: Colors.black),),),
              )),
          ElevatedButton(onPressed: (){
            Navigator.push(context, MaterialPageRoute(builder: (context) => const Dashboard()));
          },
            child: Text("Login", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white)),
            style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(200, 50)),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
                elevation: MaterialStateProperty.all(3),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
            ),),
          Padding(padding: EdgeInsets.only(top: 30)),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Har du ikke en konto?"),
                TextButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                }
                    , child: Text("Opret her.", style: TextStyle(color: Colors.white),))
              ],
            ),
          )
        ],
      ),
    );
  }
}