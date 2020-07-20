import 'package:flutter/material.dart';
import 'package:mcq_app/widgets/mcq_item_grid.dart';

class EditMCQPaperPage extends StatefulWidget {
  static const routeName = '/edit-paper-page';
  @override
  _EditMCQPaperPageState createState() => _EditMCQPaperPageState();
}

class _EditMCQPaperPageState extends State<EditMCQPaperPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher'),
        actions: <Widget>[],
      ),
      body: MCQItemGrid(),
    );
  }
}
