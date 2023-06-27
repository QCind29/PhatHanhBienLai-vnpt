import 'package:flutter/material.dart';
import 'package:vnpt/Cau_Hinh/CauHinh_Activity.dart';
import 'package:vnpt/Danh_Muc/DanhMuc_Activity.dart';
import 'package:vnpt/Danh_Muc/DanhMuc_ThemMoi.dart';
import 'package:vnpt/Phat_Hanh/PhatHanh_Activity.dart';

void main() {
  runApp(MaterialApp(
    title: "Phát Hành Biên Lai",
    home: MyHomePage(),
  ));
}


class MyHomePage extends StatefulWidget {
  @override
  MyHomePageState createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int currentIndex = 0;
  final List<Widget> listBody = [
    PhatHanh(),
    CauHinh(),
    DanhMuc_Activity(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: listBody[currentIndex],


      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blue,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.upload), label: 'Phát hành'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Cấu hình'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Danh mục')
        ],
        currentIndex: currentIndex,
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
      ),
    );
  }
}
