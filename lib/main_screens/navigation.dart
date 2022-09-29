import 'package:flutter/material.dart';
import 'package:min_turnering/event/completed_events.dart';
import 'package:min_turnering/event/events_screen.dart';
import 'package:min_turnering/profile/profile_page.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _currentIndex = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
      _pageController.animateToPage(index,
          duration: const Duration(milliseconds: 250), curve: Curves.easeOutCirc);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        //extendBodyBehindAppBar: true,
        body: SizedBox.expand(
          child: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: const <Widget>[
              AllEventsScreen(),
              CompletedEventsScreen(),
              ProfilePageScreen()
            ],
          ),
        ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            /*borderRadius: BorderRadius.only(
                topRight: Radius.circular(30), topLeft: Radius.circular(30)),*/
            boxShadow: <BoxShadow>[
              BoxShadow(
                color: Colors.black,
                blurRadius: 0.1,
              ),
            ],
          ),
          child: ClipRRect(
            /*borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),*/
            child: BottomNavigationBar(
              enableFeedback: false,
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              selectedItemColor: const Color(0xFF42BEA5),
              unselectedItemColor: Colors.grey,
              onTap: _onItemTapped,
              items: const [
                BottomNavigationBarItem(
                    label: 'Alle events',
                    icon: Icon(Icons.event)
                ),
                BottomNavigationBarItem(
                    label: 'Dine events',
                    icon: Icon(Icons.access_time)
                ),
                BottomNavigationBarItem(
                    label: 'Profil',
                    icon: Icon(Icons.person_outline)
                ),
              ],
            ),
          ),
        ),
    );
  }
}
