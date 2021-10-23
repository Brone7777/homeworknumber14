import 'package:flutter/material.dart';
import 'package:flutter_spinbox/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'service/api.dart';

class guess_the_age_of_the_teacher extends StatefulWidget {
  const guess_the_age_of_the_teacher({Key? key}) : super(key: key);

  @override
  _guess_the_age_of_the_teacherState createState() =>
      _guess_the_age_of_the_teacherState();
}

class _guess_the_age_of_the_teacherState
    extends State<guess_the_age_of_the_teacher> {
  int year = 0;
  int month = 0;
  bool check = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "ทายอายุ",
          style: GoogleFonts.kanit(),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.lightBlue.shade50,
              Colors.blueAccent.shade100,
            ],
          ),
        ),
        child: Center(
          child: check == true ? buildguesstrue() : buildGuess(),
        ),
      ),
    );
  }

  void _showMaterialDialog(String title, String msg) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(msg, style: Theme.of(context).textTheme.bodyText2),
          actions: [
            // ปุ่ม OK ใน dialog
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                // ปิด dialog
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> guessbutton() async {
    var data = (await Api()
            .submit("guess_teacher_age", {'year': year, 'month': month}))
        as Map<String, dynamic>;
    if (data == null) {
      return;
    } else {
      String text = data["text"];
      bool value = data["value"];
      if (value == true) {
        setState(() {
          check = true;
        });
      } else {
        _showMaterialDialog("ผลการทาย", text);
      }
    }
  }

  Column buildguesstrue() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "อายุอาจารย์",
          style: GoogleFonts.kanit(fontSize: 35.0),
        ),
        Text(
          "$year ปี $month เดือน",
          style: GoogleFonts.kanit(fontSize: 35.0),
        ),
        Icon(
          Icons.done_outline,
          color: Colors.green,
          size: 50.0,
        ),
      ],
    );
  }

  Column buildGuess() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "โปรดทายอายุ",
          style: GoogleFonts.kanit(fontSize: 40.0),
        ),
        Padding(
          padding: const EdgeInsets.all(40.0),
          child: Card(
            child: Column(
              children: [
                SpinBox(
                  min: 0,
                  max: 120,
                  value: 0,
                  onChanged: (value) => setState(() {
                    year = value as int;
                  }),
                  decoration: InputDecoration(labelText: "ปี"),
                ),
                SpinBox(
                  min: 0,
                  max: 12,
                  value: 0,
                  onChanged: (value) => setState(() {
                    month = value as int;
                  }),
                  decoration: InputDecoration(labelText: "เดือน"),
                ),
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: OutlinedButton(
                      onPressed: guessbutton,
                      child: Text(
                        "ทายอายุ",
                        style: GoogleFonts.kanit(),
                      )),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
