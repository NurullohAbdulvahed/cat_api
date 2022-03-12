
import 'package:cat_ui/pages/page_controller.dart';
import 'package:cat_ui/pages/search_page.dart';
import 'package:cat_ui/pages/drop_down_page.dart';
import 'package:cat_ui/pages/home_page.dart';
import 'package:cat_ui/pages/upload_page.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home:const PageControllerPage(),
      routes: {
        HomePage.id : (context) => const HomePage(),
        SearchPage.id : (context) => const SearchPage(),
        DropDownPage.id : (context) => const DropDownPage(),
      },
    );
  }
}

