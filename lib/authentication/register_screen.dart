import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:min_turnering/authentication/login_screen.dart';
import 'package:min_turnering/main_screens/navigation.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();
  final nameController = TextEditingController();

  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  final CollectionReference usersRef = FirebaseFirestore.instance.collection('users');


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
        title: Text('Registrer', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),),
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
                 validator: validateName,
                  keyboardType: TextInputType.name,
                  controller: nameController,
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
                  validator: validateEmail,
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
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
                padding: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 40),
                child: TextFormField(
                  validator: validatePassword,
                  keyboardType: TextInputType.name,
                  obscureText: true,
                  controller: passwordController,
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
                      UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(email: emailController.text, password: passwordController.text);
                      usersRef.doc(userCredential.user?.uid).get().then((DocumentSnapshot documentSnapshot) async {
                        if (documentSnapshot.exists) {
                          /// show snackbar
                        } else if (!documentSnapshot.exists) {
                          // get user token
                          var token;
                          await FirebaseMessaging.instance.getToken().then((value) {token = value;});

                          // save user cred to db
                          await usersRef.doc(userCredential.user?.uid).set({
                            'email': emailController.text,
                            'name': nameController.text,
                            'token': token,
                            'created_time': DateTime.now().toString(),
                          });
                          Navigator.pop(context);
                          Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => const Dashboard()));
                        }
                      });
                    } on FirebaseAuthException catch(e){
                      Navigator.pop(context);
                      /// Show snackbar
                    }
                  }
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
                  TextButton(onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                  }
                      , child: Text("Login", style: TextStyle(color: Colors.white),))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
