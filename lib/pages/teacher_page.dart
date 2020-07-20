import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Widgets
//import '../widgets/app_drawer.dart';

//Providers
import '../providers/mcq_paper_provider.dart';

//Pages

//Models
import '../models/mcq_paper.dart';

//Widget
import '../widgets/paper_edit_card_item.dart';

class TeacherPage extends StatefulWidget {
  static const routeName = '/teacher-page';
  const TeacherPage({Key key}) : super(key: key);

  @override
  _TeacherPageState createState() => _TeacherPageState();
}

class _TeacherPageState extends State<TeacherPage> {
  //
  bool _isLoading = false;
  List<MCQPaper> teacherPapers = [];

  @override
  void initState() {
    //initiate loading indicator.
    this.setState(() {
      _isLoading = true;
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _getTeacherPaper();
    super.didChangeDependencies();
  }

  Future<void> _refresh() async {
    _getTeacherPaper();
    this.setState(() {
      _isLoading = false;
    });
    //Await 3 seconds.
    await new Future.delayed(new Duration(seconds: 3));
  }

  Future<void> _getTeacherPaper() async {
    teacherPapers = [];
    final mCQPaperData = Provider.of<MCQPaperProvider>(context);
    teacherPapers = mCQPaperData.getMCQPaper;
    print('_getTeacherPaper is WORKING' + teacherPapers.toString());
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Teacher'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () {
              //do something.
              //Navigator.of(context).pushNamed(EditMCQPaperPage.routeName);
            },
          ),
        ],
      ),
      body: _isLoading
          ? CircularProgressIndicator()
          : RefreshIndicator(
              onRefresh: _refresh,
              child: ListView.builder(
                padding: const EdgeInsets.all(0.5),
                itemCount: teacherPapers.length,
                itemBuilder: (context, index) => ChangeNotifierProvider.value(
                  //See 15 of State Management
                  //value is better than builder for lists which rebuild after the intial build.
                  value: teacherPapers[index],
                  //builder: (ctx) => vehicles[index],
                  child: PaperEditCardItem(),
                ),
              ),
            ),
    );
  }
}
