import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Pages
import '../pages/vehicle_detail_page.dart';
//import '../pages/vehicle_description_page.dart';

//Provider
import '../models/vehicle.dart';
import '../providers/wishlist.dart';

class VehicleItem extends StatelessWidget {
  //final String id;
  //final String title;
  //final String imageUrl;

  //VehicleItem({this.id, this.imageUrl, this.title});

  @override
  Widget build(BuildContext context) {
    //this way whole widget build when data changes
    //final vehicle = Provider.of<Vehicle>(context, listen: false);
    //final vehicle = Provider.of<Vehicle>(context, listen: false);
    //only needed subpart builds when data changes

    return Consumer<Vehicle>(
      builder: (context, vehicle, child) => GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            VehicleDetailPage.routeName,
            arguments: vehicle.vehicleId,
          );
        },
        child: Card(
          elevation: 10,
          child: Container(
              //height: MediaQuery.of(context).size.height * 0.7,
              child: Column(
            children: <Widget>[
              Container(
                child: Image.network(
                  vehicle.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Consumer<Vehicle>(
                    builder: (ctx, vehicle, child) => IconButton(
                      color: Colors.red,
                      icon: Icon(
                        vehicle.isFavourite
                            ? Icons.favorite
                            : Icons.favorite_border,
                      ),
                      onPressed: () {
                        vehicle.toggleFavouriteStatus();
                      },
                    ),
                  ),
                  Text(
                    vehicle.vehicleTitle,
                    textAlign: TextAlign.center,
                  ),
                  Consumer<Wishlist>(
                    builder: (ctx, wishlist, child) => IconButton(
                      icon: Icon(Icons.shopping_cart),
                      color: Colors.pink,
                      onPressed: () {
                        wishlist.addItem(
                          vehicle.vehicleId,
                          vehicle.pricePerDay,
                          vehicle.vehicleTitle,
                        );
                        Scaffold.of(context).hideCurrentSnackBar();
                        //reach out for the nearest scaffold widget.
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Vehicle is added'),
                          duration: Duration(seconds: 2),
                          action: SnackBarAction(
                            label: 'UNDO',
                            onPressed: () {
                              wishlist.removeLatestItem(vehicle.vehicleId);
                            },
                          ),
                        ));
                      },
                    ),
                  ),
                ],
              )
            ],
          )),
        ),
      ),
    );

    /*
    return Consumer<Vehicle>(
      builder: (ctx, vehicle, child) => GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(
              VehicleDetailPage.routeName,
              arguments: vehicle.vehicleId,
            );
          },
          child: Image.network(
            vehicle.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          backgroundColor: Colors.black38,
          leading: Consumer<Vehicle>(
            builder: (ctx, vehicle, child) => IconButton(
              color: Colors.red,
              icon: Icon(
                vehicle.isFavourite ? Icons.favorite : Icons.favorite_border,
              ),
              onPressed: () {
                vehicle.toggleFavouriteStatus();
              },
            ),
          ),
          trailing: Consumer<Wishlist>(
            builder: (ctx, wishlist, child) => IconButton(
              icon: Icon(Icons.shopping_cart),
              color: Colors.pink,
              onPressed: () {
                wishlist.addItem(
                  vehicle.vehicleId,
                  vehicle.pricePerDay,
                  vehicle.vehicleTitle,
                );
                Scaffold.of(context).hideCurrentSnackBar();
                //reach out for the nearest scaffold widget.
                Scaffold.of(context).showSnackBar(SnackBar(
                  content: Text('Vehicle is added'),
                  duration: Duration(seconds: 2),
                  action: SnackBarAction(
                    label: 'UNDO',
                    onPressed: () {
                      wishlist.removeLatestItem(vehicle.vehicleId);
                    },
                  ),
                ));
              },
            ),
          ),
          title: Text(
            vehicle.vehicleTitle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
    */
  }
}
