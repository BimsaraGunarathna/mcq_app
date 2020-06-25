import 'package:flutter/material.dart';
//import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

//Navigation.
//import '../widgets/bottom_nav_bar.dart';

class VehicleItemPage extends StatefulWidget {
  static final String routeName = "lib/src/pages/hotel/details.dart";

  @override
  VehicleItemPageState createState() => new VehicleItemPageState();
}

class VehicleItemPageState extends State<VehicleItemPage> {
  final String image = "assets/img/test.png";

  @override
  Widget build(BuildContext context) {
    //final double _appBarHeight = MediaQuery.of(context).size.height / 2.5;

    return Scaffold(
      appBar: AppBar(
        title: Text('Vehicle'),
      ),
      //bottomNavigationBar: BottomNavBar(),
      body: CarouselSlider(
        height: 400.0,
        items: [1, 2, 3, 4, 5].map((i) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: BoxDecoration(color: Colors.amber),
                  child: Text(
                    'text $i',
                    style: TextStyle(fontSize: 16.0),
                  ));
            },
          );
        }).toList(),
      ),
    );
  }
}
