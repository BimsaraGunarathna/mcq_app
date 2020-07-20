import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Widgets
import '../widgets/app_drawer.dart';

//Providers
import '../providers/mcq_paper_provider.dart';

//Pages
import 'edit_mcq_paper_page.dart';

//Models
import '../models/mcq_paper.dart';

//Widget
import '../widgets/mcq_edit_card_item.dart';

class TeacherPage extends StatefulWidget {
  static const routeName = '/teacher-page';
  const TeacherPage({Key key}) : super(key: key);

  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  //
  bool _isLoading = true;
  List<MCQPaper> teacherPapers = [];

  @override
  void initState() {
    setState(() {
      _isLoading = false;
    });
    _getTeacherPaper();
  }

  Future _refresh() {
    _getTeacherPaper();

    this.setState(() {
      _isLoading = false;
    });
  }

  Future<void> _getTeacherPaper() async {
    final mCQPaperData = Provider.of<MCQPaperProvider>(context);
    teacherPapers = mCQPaperData.getMCQPaper;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Teacher'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              //do something.
              Navigator.of(context).pushNamed(EditMCQPaperPage.routeName);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _refresh,
        child: ListView.builder(
          padding: const EdgeInsets.all(0.5),
          itemCount: teacherPapers.length,
          itemBuilder: (context, index) => ChangeNotifierProvider.value(
            //See 15 of State Management
            //value is better than builder for lists which rebuild after the intial build.
            value: teacherPapers[index],
            //builder: (ctx) => vehicles[index],
            child: MCQEditCardItem(),
          ),
        ),
      ),
    );
  }
}
