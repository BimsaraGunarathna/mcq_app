import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Widget
import '../widgets/mcq_edit_card_item.dart';

//Providers
import '../providers/mcq_paper_provider.dart';

class MCQItemGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final mCQData = Provider.of<MCQPaperProvider>(context);
    final vehicles = mCQData.getMCQItems;

    return ListView.builder(
      padding: const EdgeInsets.all(0.5),
      itemCount: vehicles.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        //See 15 of State Management
        //value is better than builder for lists which rebuild after the intial build.
        value: vehicles[index],
        //builder: (ctx) => vehicles[index],
        child: MCQEditCardItem(),
      ),
    );
  }
}
