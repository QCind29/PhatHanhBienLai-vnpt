import 'package:flutter/material.dart';
import 'package:vnpt/Cau_Hinh/CauHinh_ThemMoi.dart';

import '../Database/SQLHelper.dart';

class CauHinh extends StatefulWidget {
  @override
  CauHinhActivity createState() => CauHinhActivity();
}

class CauHinhActivity extends State<CauHinh> {
  SQLHelper? sqlHelper;
  List<Map<String, dynamic>> dataList = [];
  void _refresh() async {
    final data = await SQLHelper.getAllCH();
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
  Future<void> _deleteCH(id) async {
    await SQLHelper.deleteCH(id);
    _refresh();
  }

//Delete dialog
  void showDeleteWarning(BuildContext context, id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xóa cấu hình'),
          content: Text(
            'Bạn muốn xóa cấu hình đang chọn?',
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
                _deleteCH(id);
                _refresh();

                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _refresh();

    if (dataList != null || dataList.isNotEmpty || dataList.length > 0) {
      isNull = false;
    }

    return Scaffold(
        appBar: AppBar(
          title: Text("Cấu hình"),
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
                      return CauHinh_ThemMoi();
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
                child: Text("Cấu Hình đang rỗng"),
              )
            : ListView.builder(
                itemCount: dataList.length,
                itemBuilder: (context, index) {
                  return Column(children: [
                    Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          side: BorderSide(color: Colors.black, width: 1.0)),
                      color: Colors.white,
                      margin: const EdgeInsets.all(15.0),
                      child: ListTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              dataList[index]['Url'],
                              style: TextStyle(fontWeight: FontWeight.bold,),

                            ),
                            Text(
                              dataList[index]['Username'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              dataList[index]['Password'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              dataList[index]['Acaccount'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              dataList[index]['Acpass'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              dataList[index]['Pattern'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              dataList[index]['Serial'],
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        trailing: SizedBox(
                          width: 100,
                          child: Row(
                            children: [
                              IconButton(
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CauHinh_ThemMoi(),
                                          // Pass the arguments as part of the RouteSettings. The
                                          // DetailScreen reads the arguments from these settings.
                                          settings: RouteSettings(
                                            arguments:
                                                dataList[index]['id'] ?? " ",
                                          ),
                                        ));
                                  },
                                  icon: Icon(
                                    Icons.edit,
                                    color: Colors.purple,
                                  )),
                              IconButton(
                                  onPressed: () {
                                    final c = dataList[index]['id'];
                                    showDeleteWarning(context, c);
                                    _refresh();
                                  },
                                  icon: Icon(Icons.delete, color: Colors.red))
                            ],
                          ),
                        ),
                      ),
                    ),
                    Divider(
                      indent: 15,
                      endIndent: 15,
                      color: Colors.grey, // Set the color of the divider line
                      height: 5, // Set the height of the divider line
                      thickness: 0.5, // Set the thickness of the divider line
                    ),
                  ]);
                }));
  }
}
