import 'package:flutter/material.dart';

class EventCard extends StatelessWidget {
  final String text;
  final String day;
  final String time;
  final Icon icon;
  final bool check, queue;
  final Function() onPressed;

  const EventCard(
      {required this.text,
        required this.day,
        required this.icon,
        required this.time,
        required this.check,
        required this.queue,
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
                      padding: EdgeInsets.only(left: 10, top: 10),
                      child: Text(time,
                          style: const TextStyle(
                            color: Colors.grey,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          )),
                    ),
                    Container(
                        padding: EdgeInsets.only(left: 10, top: 10),
                        child: icon,),
                  ],
                ),
              ],
            ),
            const Spacer(),
           check? Container(
              padding: EdgeInsets.only(right: 20),
                child: Icon(Icons.check_circle, color: Colors.green, size: 28,)) : Container(),
            queue? Container(
              padding: EdgeInsets.only(right: 20),
              child: Icon(Icons.group_add, color: Colors.blue, size: 28,),
            ) : Container()
          ],
        ),
      ),
    );
  }
}

class EventHistoryCard extends StatelessWidget {
  final Function() onPressed;
  final String text;

  const EventHistoryCard(
      {required this.onPressed,
        required this.text,
        Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: 75,
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
                  padding: const EdgeInsets.only(left: 15, top: 20, bottom: 5),
                  child: Text('Event ID:  ${text}',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}