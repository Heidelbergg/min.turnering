import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String text;
  final String day;
  final String time;
  final Icon icon;
  final Icon icon2;
  final Function() onPressed;

  const EventCard(
      {required this.text,
        required this.day,
        required this.icon,
        required this.icon2,
        required this.time,
        required this.onPressed,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 120,
        padding: const EdgeInsets.only(top: 5, bottom: 5),
        margin: const EdgeInsets.only(bottom: 10, right: 5, left: 5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
                offset: const Offset(5, 5),
                blurRadius: 15,
                color: Colors.grey.withOpacity(.5)),
          ],
        ),
        child: Row(
          children: [
            Container(
              child: Column(
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15, top: 15),
                    child: Text(day,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15, top: 10),
                    child: Text(text,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        )),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 15, top: 10),
                    child: Text(time,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        )),
                  ),
                ],
              ),
            ),
            const Spacer(),
            Container(
                padding: EdgeInsets.only(left: 5),
                child: icon),
            Container(
                padding: EdgeInsets.only(left: 5, right: 10),
                child: icon2),
          ],
        ),
      ),
    );
  }
}