import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:min_turnering/authentication/register_screen.dart';
import 'package:min_turnering/main_screens/navigation.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();


  String? validateEmail(String? email){
    if (email == null || email.isEmpty){
      return "Indsæt e-mail";
    } else if (!email.contains("@") || !email.contains(".")){
      return "Ugyldig e-mail";
    }
  }

  String? validatePassword(String? password){
    if (password == "" || password!.isEmpty){
      return "Password er ugyligt";
    } else if (password.length < 6){
      return "Password skal være mindst 6 cifre langt";
    }
  }

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
      body: Form(
        key: _key,
        child: ListView(
          shrinkWrap: true,
          children: [
            Container(
                padding: EdgeInsets.only(left: 20, right: 20, top: 60),
                child: TextFormField(
                  validator: validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
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
                    validator: validatePassword,
                    keyboardType: TextInputType.name,
                    obscureText: true,
                    controller: passwordController,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(onPressed: () async {
                  if (_key.currentState!.validate()){
                    showDialog(barrierDismissible: false, context: context, builder: (BuildContext context){
                      return const AlertDialog(
                        elevation: 0,
                        backgroundColor: Colors.transparent,
                        content: CircularProgressIndicator.adaptive(backgroundColor: Colors.grey,)
                      );
                    });
                    try{
                      await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailController.text, password: passwordController.text);
                      User? user = FirebaseAuth.instance.currentUser;
                      FirebaseMessaging.instance.getToken().then((value) {FirebaseFirestore.instance.collection('users').doc(user!.uid).update({'token': value});});
                      Navigator.pop(context);
                      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Dashboard()));
                    } on FirebaseAuthException catch(e){
                      if(e.code == "user-not-found"){
                        Navigator.pop(context);
                      } else {
                        Navigator.pop(context);
                      }
                    }
                  }
                },
                  child: Text("Login", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Colors.white)),
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
      ),
    );
  }
}