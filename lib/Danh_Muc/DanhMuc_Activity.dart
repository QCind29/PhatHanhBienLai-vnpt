import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vnpt/Danh_Muc/DanhMuc_ThemMoi.dart';
import 'package:vnpt/Database/SQLHelper.dart';

import '../Model/DanhMuc_Model.dart';

class DanhMuc_Activity extends StatefulWidget {
  const DanhMuc_Activity({Key? key}) : super(key: key);
  @override
  DanhMucActivity createState() => DanhMucActivity();
}

class DanhMucActivity extends State<DanhMuc_Activity> {
  SQLHelper? sqlHelper;
  List<Map<String, dynamic>> dataList = [];
  void _refresh() async {
    final data = await SQLHelper.getAllDM();
    setState(() {
      dataList = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh();
  }

  bool isNull = true;

// Delete a DM by ID
  Future<void> _deleteDM(id) async {
    await SQLHelper.deleteDM(id);
    _refresh();
  }

  //Delete dialog
  void showDeleteWarning(BuildContext context, id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xóa danh mục'),
          content: Text(
            'Bạn muốn xóa danh mục đang chọn?',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            TextButton(
              child: Text('Đóng'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Xóa'),
              onPressed: () {
                _deleteDM(id);
                _refresh();

                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

// format for Numberformat
  menhgia(number) {
    final formatCurrency = NumberFormat("#,##0");
    return formatCurrency.format(number);
  }

  @override
  Widget build(BuildContext context) {
    _refresh();
    if (dataList != null || dataList.isNotEmpty || dataList.length > 0) {
      isNull = false;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Danh mục"),
          actions: [
            FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Colors.blueAccent,
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: Duration(milliseconds: 500),
                    pageBuilder: (context, animation, secondaryAnimation) {
                      return DanhMuc_ThemMoi();
                    },
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      return SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(1.0, 0.0),
                          end: Offset.zero,
                        ).animate(animation),
                        child: child,
                      );
                    },
                  ),
                );
              },
            )
          ],
        ),
        body: isNull
            ? Center(
                child: Text("Danh mục đang rỗng"),
              )
            : Container(
                child: ListView.builder(
                    itemCount: dataList.length,
                    itemBuilder: (context, index) {
                      return Column(children: [
                        Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5.0),
                              side:
                                  BorderSide(color: Colors.black, width: 1.0)),
                          color: Colors.white,
                          margin: const EdgeInsets.all(15.0),
                          child: ListTile(
                            title: Text(
                              dataList[index]['NoiDung'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              menhgia(int.parse(
                                      dataList[index]['MenhGia'].toString())) +
                                  "đ",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: SizedBox(
                              width: 100,
                              child: Row(
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.edit,
                                      color: Colors.purple,
                                    ),
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DanhMuc_ThemMoi(),
                                            // Pass the arguments as part of the RouteSettings. The
                                            // DetailScreen reads the arguments from these settings.
                                            settings: RouteSettings(
                                              arguments:
                                                  dataList[index]['id'] ?? " ",
                                            ),
                                          ));
                                    },
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      final c = dataList[index]['id'];
                                      showDeleteWarning(context, c);
                                      _refresh();
                                    },
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Divider(
                          indent: 15,
                          endIndent: 15,
                          color:
                              Colors.grey, // Set the color of the divider line
                          height: 5, // Set the height of the divider line
                          thickness:
                              0.5, // Set the thickness of the divider line
                        ),
                      ]);
                    })));
  }
}
