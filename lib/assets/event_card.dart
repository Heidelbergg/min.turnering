import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String text;
  final String day;
  final String time;
  final Icon icon;
  final Function() onPressed;

  const EventCard(
      {required this.text,
        required this.day,
        required this.icon,
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
        margin: const EdgeInsets.only(bottom: 10, right: 20, left: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(17.5),
          boxShadow: [
            BoxShadow(
                offset: const Offset(5, 5),
                blurRadius: 15,
                color: Colors.grey.withOpacity(.5)),
          ],
        ),
        child: Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.only(left: 15, top: 15, bottom: 5),
                  child: Text(text,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                      )),
                ),
                Row(
                  children: [
                    Container(
                      padding: EdgeInsets.only(left: 15, top: 10),
                      child: Text(day,
                          style: const TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 15, top: 10),
                      child: Text(time,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 15, top: 10),
                        child: icon,),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}