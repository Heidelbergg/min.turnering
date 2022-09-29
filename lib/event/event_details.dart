import 'package:flutter/material.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({Key? key}) : super(key: key);

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool isCompleted = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: MediaQuery.of(context).size.height / 1.75,
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
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(top: 50, left: 5, bottom: 5),
              child: IconButton(onPressed: (){Navigator.pop(context);}, icon: Icon(Icons.arrow_back_ios, color: Colors.grey, size: 20,),),
            ),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(left: 15, bottom: 30, top: 5,),
                child: Text("Eventnavn",
                  style: TextStyle(color: Colors.black, fontSize: 34, fontWeight: FontWeight.w700),)),
            Row(
              children: [
                Container(
                    padding: EdgeInsets.only(left: 20, right: 10),
                    child: Text("Eventtype", style: TextStyle(color: Colors.grey, fontSize: 14),)),
                Icon(Icons.sports_baseball, color: Colors.grey,),
                const Spacer(),
                Container(
                  padding: EdgeInsets.only(right: 10),
                    child: TextButton(onPressed: () {
                      // see participants
                    }, child: Text("6 deltagere (2 i kø)", style: TextStyle(color: Colors.grey, fontSize: 14),),))
              ],
            ),
            Container(
              padding: EdgeInsets.only(left: 10, right: 10),
                child: const Divider(thickness: 1, color: Colors.grey, height: 40)),
            Container(
                alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(right: 10, top: 20, left: 20),
                child: Text("Arrangeret af: Ammar", style: TextStyle(color: Colors.grey, fontSize: 14))),
            Container(
              alignment: Alignment.centerLeft,
                padding: EdgeInsets.only(right: 10, top: 20, left: 20),
                child: Text("Torsdag 16:30", style: TextStyle(color: Colors.black, fontSize: 24, fontWeight: FontWeight.w700))),
            Container(
              padding: EdgeInsets.only(right: 10, top: 60, left: 10),
              child: ElevatedButton(onPressed: (){
                //Navigator.push(context, MaterialPageRoute(builder: (context) => const AllEventsScreen()));
              },
                child: Text(isCompleted? "Event udført" : "Deltag", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: isCompleted? Colors.white70 : Colors.white)),
                style: ButtonStyle(
                    minimumSize: MaterialStateProperty.all(const Size(300, 60)),
                    backgroundColor: MaterialStateProperty.all<Color>(isCompleted? Colors.grey : const Color(0xFF42BEA5)),
                    elevation: MaterialStateProperty.all(3),
                    shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)))
                ),),
            ),
          ],
        ),
      ),
    );
  }
}
