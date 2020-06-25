import 'package:flutter/material.dart';

//import 'package:flutter_icons/flutter_icons.dart';

//Pages
import '../pages/search_page.dart';
//import '../pages/order_page.dart';
//import '../pages/user_vehicle_page.dart';
import '../pages/host_page.dart';
import '../pages/profile_page.dart';

class BottomNavBar extends StatefulWidget {
  final int foo;

  const BottomNavBar({Key key, this.foo}) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int selectedIndex = 0;

  @override
  void initState() {
    print('Foo is : ' + widget.foo.toString());
    selectedIndex = widget.foo;
    super.initState();
  }

  void _selectedPage(int index) {
    print('At switch $index');
    switch (selectedIndex) {
      case 0:
        {
          Navigator.of(context)
              .pushReplacementNamed(SearchPage.routeName);
        }
        break;
      case 1:
        {
          Navigator.of(context).pushReplacementNamed(HostPage.routeName);
        }
        break;
      case 2:
        {
          Navigator.of(context).pushReplacementNamed(ProfilePage.routeName);
        }
        break;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        //Search
        const BottomNavigationBarItem(
          backgroundColor: Colors.yellow,
          icon: Icon(Icons.search),
          title: Text('Search'),
        ),
        //Host
        const BottomNavigationBarItem(
          backgroundColor: Colors.red,
          icon: Icon(Icons.subway),
          title: Text('Host'),
        ),
        //Profile
        const BottomNavigationBarItem(
          backgroundColor: Colors.green,
          icon: Icon(Icons.supervised_user_circle),
          title: Text('Profile'),
        ),
      ],
      currentIndex: selectedIndex,
      onTap: (int i) {
        print('At start $i');
        setState(() {
          selectedIndex = i;
        });
        _selectedPage(i);
        print('At end $i');
      },
      type: BottomNavigationBarType.fixed,
      //fixedColor: Colors.orange,
      selectedItemColor: Colors.orange,
    );
  }
}
