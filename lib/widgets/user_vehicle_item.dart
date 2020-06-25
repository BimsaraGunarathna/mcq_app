import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Pages
import '../pages/edit_vehicle_page.dart';

//Providers
import '../providers/vehicles.dart';

class UserVehicleItem extends StatelessWidget {

  final String id;
  final String title;
  final String imageUrl;

  UserVehicleItem({
    @required this.id,
    @required this.title,
    //@required this.imageUrl,
    this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(imageUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () {
                Navigator.of(context).pushNamed(
                  EditVehiclePage.routeName,
                  arguments: id,
                );
              },
              color: Theme.of(context).primaryColorDark,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                try {
                  await Provider.of<Vehicles>(context, listen: true)
                      .deleteVehicle(id);
                } catch (e) {
                  //can't use Scaffold.of(context) because this function return a future in which context is changed.
                  scaffold.showSnackBar(
                    SnackBar(
                      content: Text('Deleting failed! $e'),
                    ),
                  );
                }
              },
              color: Theme.of(context).errorColor,
            ),
          ],
        ),
      ),
    );
  }
}
