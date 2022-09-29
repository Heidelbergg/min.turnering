import 'package:flutter/material.dart';
import 'package:min_turnering/main_screens/splash_screen.dart';
import 'package:min_turnering/profile/change_password.dart';
import 'package:min_turnering/profile/edit_profile.dart';

class ProfilePageScreen extends StatefulWidget {
  const ProfilePageScreen({Key? key}) : super(key: key);

  @override
  State<ProfilePageScreen> createState() => _ProfilePageScreenState();
}

class _ProfilePageScreenState extends State<ProfilePageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        centerTitle: false,
        backgroundColor: const Color(0xFF42BEA5),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Velkommen', style: TextStyle(fontSize: 34, fontWeight: FontWeight.w700),),
            Padding(padding: EdgeInsets.only(top: 10)),
            Text('[user_name]', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),
          ],
        ),
        toolbarHeight: 125,
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(left: 15, top: 20, bottom: 20),
              child: Text("Kontoinformationer",
                style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),)),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfileScreen()));
            },
            child: Container(
              padding: EdgeInsets.only(top: 30),
              decoration: BoxDecoration(
              ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            padding: EdgeInsets.only(left: 15),
                            child: Text("Ændre profil")),
                        const Spacer(),
                        Container(
                          padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.arrow_forward_ios, size: 20,))
                      ],
                    ),
                    const Divider(thickness: 2, height: 50,),
                  ],
                ),
            ),
          ),
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ChangePasswordScreen()));
            },
            child: Container(
              padding: EdgeInsets.only(top: 10),
              decoration: BoxDecoration(
              ),
              child:  Column(
                children: [
                  Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                            padding: EdgeInsets.only(left: 15),
                            child: Text("Ændre adgangskode")),
                        const Spacer(),
                        Container(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(Icons.arrow_forward_ios, size: 20,))
                      ],
                    ),
                  const Divider(thickness: 2, height: 50,),
                ],
              ),
              ),
          ),
          Padding(padding: EdgeInsets.only(top: 40)),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const SplashScreen()));
              },
                child: Text("Log ud", style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, color: Colors.black)),
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(130, 50)),
                    backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                    elevation: MaterialStateProperty.all(3),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                ),),
            ],
          ),
          Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Text("Appversion: 1.0.0",
                style: TextStyle(color: Colors.grey, fontSize: 14, fontWeight: FontWeight.w400),)),
        ],
      ),
    );
  }
}
