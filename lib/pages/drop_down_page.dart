import 'package:flutter/material.dart';


class DropDownPage extends StatefulWidget {
  static const String id = "DropDownPage";
  const DropDownPage({Key? key}) : super(key: key);

  @override
  _DropDownPageState createState() => _DropDownPageState();
}

class _DropDownPageState extends State<DropDownPage> {
  String? _chosenValue;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DropDown'),
      ),
      // body: Center(
      //   child: Container(
      //     padding: const EdgeInsets.all(0.0),
      //     child: DropdownButton<String>(
      //       value: _chosenValue,
      //       elevation: 5,
      //       style: TextStyle(color: Colors.black),
      //
      //       items: <String>[
      //         'Android',
      //         'IOS',
      //         'Flutter',
      //         'Node',
      //         'Java',
      //         'Python',
      //         'PHP',
      //       ].map<DropdownMenuItem<String>>((String value) {
      //         return DropdownMenuItem<String>(
      //           value: value,
      //           child: Text(value),
      //         );
      //       }).toList(),
      //       hint: Text(
      //         "Please choose a cats",
      //         style: TextStyle(
      //             color: Colors.black,
      //             fontSize: 16,
      //             fontWeight: FontWeight.w600),
      //       ),
      //       onChanged: (String? value) {
      //         setState(() {
      //           _chosenValue = value!;
      //         });
      //       },
      //     ),
      //   ),
      // ),
    );
  }
}
