import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      color: Colors.brown,
      title: "gpa clac",
      home: Home(),
      theme: ThemeData(primarySwatch: Colors.brown),
    );
  }
}

class Home extends StatefulWidget {
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Course> courses = [];
  TextEditingController _gPA = TextEditingController();
  TextEditingController _lsth = TextEditingController();
  TextEditingController _courseName = TextEditingController();
  TextEditingController _courseGpa = TextEditingController();
  TextEditingController _coursecrdt = TextEditingController();

  Future showGpa(BuildContext context) {
    double gpa = double.parse(_gPA.text) * int.parse(_lsth.text);
    int nold = int.parse(_lsth.text);
    for (var i = 0; i < courses.length; i++) {
      gpa += courses[i].gpa * courses[i].courseHours;
      nold += courses[i].courseHours;
    }
    gpa /= nold;
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(20.0),
                  child: Text("your GPA = $gpa"),
                ),
              ],
            ),
          );
        });
  }

  Future addsubgect(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GpaText(
                controller: _courseName,
                textFilter: TextInputType.text,
                label: "Course Name",
                hint: "enter your Course Name",
              ),
              GpaText(
                controller: _courseGpa,
                textFilter: TextInputType.numberWithOptions(
                    signed: false, decimal: true),
                label: "Course GPA",
                hint: "enter Course Gpa",
              ),
              GpaText(
                controller: _coursecrdt,
                textFilter: TextInputType.numberWithOptions(
                    signed: false, decimal: true),
                label: "Course Hours",
                hint: "enter your Course Hours",
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    courses.add(Course(
                        _courseName.text,
                        double.parse(_courseGpa.text),
                        int.parse(_coursecrdt.text)));
                  });
                  _courseGpa.clear();
                  _courseName.clear();
                  _coursecrdt.clear();
                  Navigator.of(context).pop();
                },
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    border: Border.all(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      'Done',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[Text("Gpa Calculator")],
      )),
      body: Column(
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          GpaText(
            controller: _gPA,
            textFilter:
                TextInputType.numberWithOptions(signed: false, decimal: true),
            label: "current GPA",
            hint: "enter your current Gpa",
          ),
          GpaText(
            controller: _lsth,
            textFilter:
                TextInputType.numberWithOptions(signed: false, decimal: false),
            label: "Last registerd hours",
            hint: "please enter Last registerd hours",
          ),
          Expanded(
            child: ListView.builder(
                itemCount: courses.length,
                itemBuilder: (context, index) {
                  final item = courses[index];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Dismissible(
                      // background: Container(
                      //   color: Colors.brown[70],
                      //   child: Icon(Icons.delete),
                      // ),
                      key: UniqueKey(),
                      onDismissed: (direction) {
                        setState(() {
                          courses.removeAt(index);
                        });
                      },
                      child: SemsterTile(item),
                    ),
                  );
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              InkWell(
                onTap: () => showGpa(context),
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    border: Border.all(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      'Calculate GPA',
                      style: TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
              ),
              InkWell(
                onTap: () => addsubgect(context),
                child: Container(
                  padding: EdgeInsets.all(10.0),
                  height: 50.0,
                  decoration: BoxDecoration(
                    color: Colors.brown,
                    border: Border.all(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Center(
                    child: Text(
                      'Add Course',
                      style: new TextStyle(fontSize: 18.0, color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class Course {
  String name;
  double gpa;
  int courseHours;
  Course(this.name, this.gpa, this.courseHours);
}

class GpaText extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType textFilter;
  final String label;
  final String hint;
  GpaText({this.controller, this.textFilter, this.hint, this.label});
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(border: Border.all()),
        child: TextField(
          controller: controller,
          autocorrect: false,
          keyboardType: textFilter,
          decoration: InputDecoration(
              labelText: label,
              hintText: hint,
              hasFloatingPlaceholder: true,
              border: InputBorder.none),
        ),
      ),
    );
  }
}

class SemsterTile extends StatelessWidget {
  final Course course;
  SemsterTile(this.course);
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        decoration: BoxDecoration(border: Border.all()),
        child: ListTile(
          title: Text(course.name),
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text("course Gpa :" + course.gpa.toString()),
              Text("credit hours: " + course.courseHours.toString()),
            ],
          ),
        ),
      ),
    );
  }
}