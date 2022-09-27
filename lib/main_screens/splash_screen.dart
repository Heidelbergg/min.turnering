import 'package:flutter/material.dart';
import 'package:min_turnering/authentication/login_screen.dart';
import 'package:min_turnering/authentication/register_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF134E5E),
              Color(0xFF71B280)
            ],
          )
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            SizedBox(
                height: MediaQuery.of(context).size.height / 1.75,
                child: Image.asset('assets/logo_transparent_full.png', fit: BoxFit.contain,)),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
            },
              child: Text("Registrer", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(200, 50)),
                backgroundColor: MaterialStateProperty.all<Color>(const Color(0xFF42BEA5)),
                elevation: MaterialStateProperty.all(3),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
              ),),
            Padding(padding: EdgeInsets.only(top: 20)),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
            },
              child: Text("Login", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: const Color(0xFF42BEA5))),
              style: ButtonStyle(
                minimumSize: MaterialStateProperty.all(const Size(200, 50)),
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                elevation: MaterialStateProperty.all(3),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
              ),),
          ],
        ),
      ),
    );
  }
}
