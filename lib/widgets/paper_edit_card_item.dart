import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
//import 'dart:convert' show utf8;

//Pages
import '../pages/paper_edit_page.dart';

//Models
import '../models/mcq_paper.dart';

//Provider
import '../providers/mcq_paper_provider.dart';

class PaperEditCardItem extends StatelessWidget {
  //var encoded = utf8.encode('Lorem ipsum dolor sit amet, consetetur...');

  @override
  Widget build(BuildContext context) {
    return Consumer<MCQPaper>(
      builder: (context, mcq, child) => GestureDetector(
        onTap: () {
          Navigator.of(context).pushNamed(
            PaperEditPage.routeName,
            arguments: mcq.paperId,
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
                    mcq.paperThumbnailImgURL,
                    fit: BoxFit.cover,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      mcq.paperDescription,
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
