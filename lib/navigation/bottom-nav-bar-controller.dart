import 'package:flutter/material.dart';

//Page
//import '../pages/user_vehicle_host_page.dart';
import '../pages/search_page.dart';
import '../pages/profile_page.dart';
import '../pages/teacher_page.dart';
import '../pages/trip_page.dart';

//icons
import 'package:flutter_icons/flutter_icons.dart';

class BottomNavigationBarController extends StatefulWidget {
  static const routeName = '/bottom-nav-bar-controller';
  @override
  _BottomNavigationBarControllerState createState() =>
      _BottomNavigationBarControllerState();
}

class _BottomNavigationBarControllerState
    extends State<BottomNavigationBarController> {
  final List<Widget> pages = [
    SearchPage(
      key: PageStorageKey('Page1'),
    ),
    TripPage(
      key: PageStorageKey('Page2'),
    ),
    TeacherPage(
      key: PageStorageKey('Page3'),
    ),
    ProfilePage(
      key: PageStorageKey('Page5'),
    ),
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  int _selectedIndex = 0;

  Widget bottomNavigationBar(int selectedIndex) => BottomNavigationBar(
        onTap: (int index) => setState(() => _selectedIndex = index),
        currentIndex: selectedIndex,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Feather.home),
            title: Text('Home'),
          ),
          BottomNavigationBarItem(
            icon: Icon(MaterialIcons.directions_bike),
            title: Text('Leaderboard'),
          ),
          BottomNavigationBarItem(
            icon: Icon(AntDesign.car),
            title: Text('Teacher'),
          ),
          BottomNavigationBarItem(
            icon: Icon(AntDesign.user),
            title: Text('Profile'),
          ),
        ],
        type: BottomNavigationBarType.fixed,
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNavigationBar(_selectedIndex),
      body: PageStorage(
        child: pages[_selectedIndex],
        bucket: bucket,
      ),
    );
  }
}
