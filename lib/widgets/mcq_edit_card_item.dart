import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:convert' show utf8;

//Pages
//import '../pages/vehicle_detail_page.dart';
//import '../pages/vehicle_description_page.dart';

//Provider
import '../providers/mcq_paper_provider.dart';

class MCQEditCardItem extends StatelessWidget {
  var encoded = utf8.encode('Lorem ipsum dolor sit amet, consetetur...');

  @override
  Widget build(BuildContext context) {
    return Consumer<MCQPaperProvider>(
      builder: (context, mcq, child) => GestureDetector(
        onTap: () {
          /*
          Navigator.of(context).pushNamed(
            VehicleDetailPage.routeName,
            arguments: vehicle.vehicleId,
          );
          */
        },
        child: Card(
          elevation: 10,
          child: Container(
            //height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              children: <Widget>[
                Container(
                  child: Image.network(
                    'https://cdn.maikoapp.com/3d4b/4quqa/150.jpg',
                    fit: BoxFit.cover,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      '(i)	ix>gl uQ,øjHhl TlaislrK wxlh Y+kH jk m%fNao^h &',
                      style: Theme.of(context).textTheme.bodyText2,
                      textAlign: TextAlign.center,
                    ),
                    Consumer<MCQPaperProvider>(
                      builder: (ctx, wishlist, child) => IconButton(
                        icon: Icon(Icons.shopping_cart),
                        color: Colors.pink,
                        onPressed: () {
                          Scaffold.of(context).hideCurrentSnackBar();
                          //reach out for the nearest scaffold widget.
                          Scaffold.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Vehicle is added'),
                              duration: Duration(seconds: 2),
                              action: SnackBarAction(
                                label: 'UNDO',
                                onPressed: () {
                                  //wishlist.removeLatestItem(vehicle.vehicleId);
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
