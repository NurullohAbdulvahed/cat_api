import 'dart:async';

import 'package:cat_ui/pages/search_page.dart';
import 'package:cat_ui/pages/upload_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'drop_down_page.dart';
import 'home_page.dart';



class PageControllerPage extends StatefulWidget {
  const PageControllerPage({Key? key}) : super(key: key);

  @override
  _PageControllerPageState createState() => _PageControllerPageState();
}

class _PageControllerPageState extends State<PageControllerPage> {
  int changeIndex = 0;
  bool isOffline = false;
  PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body:PageView(
        physics: NeverScrollableScrollPhysics(),
        controller: _controller,
        onPageChanged: (index){
          setState(() {
            changeIndex = index;
          });
        },
        children: [
          HomePage(),
          SearchPage(),
          DropDownPage(),
          Upload_Page(),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Container(
        padding: EdgeInsets.only(left: 15),
        margin: EdgeInsets.only(left: 40,right: 40,bottom: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(40),
        ),
        child: BottomNavigationBar(
          selectedItemColor: Colors.black,
          currentIndex: changeIndex,
          backgroundColor: Colors.transparent,
          elevation: 0,
          onTap: (int index){
            setState(() {
              changeIndex = index;
              _controller.jumpToPage(index);
            });
          },
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,

          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: ""
            ),
            BottomNavigationBarItem(
                icon:Icon(Icons.search),
                label: ""
            ),
            BottomNavigationBarItem(
                icon:Icon(FontAwesomeIcons.solidCommentDots),
                label: ""
            ),
            BottomNavigationBarItem(
                icon:Icon(FontAwesomeIcons.upload),
                label: ""
            ),
          ],
        ),
      ),
    );
  }


}