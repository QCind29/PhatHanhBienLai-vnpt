import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:vnpt/Database/SQLHelper.dart';

import '../Model/DanhMuc_Model.dart';

class DanhMuc_ThemMoi extends StatefulWidget {
  @override
  DanhMuc_ThemMoiActivity createState() => DanhMuc_ThemMoiActivity();
}

class DanhMuc_ThemMoiActivity extends State<DanhMuc_ThemMoi> {
  SQLHelper? sqlHelper;

  List<Map<String, dynamic>> dataList1 = [];
  DanhMuc_Model? danhMuc_Model;
  Map<String, dynamic>? dataList2;

  final _fromKey = GlobalKey<FormState>();
  final menhgiaController = TextEditingController();
  final noidungController = TextEditingController();
  final updataMenhgiaController = TextEditingController();
  final updatenoidungController = TextEditingController();

  void _refresh() async {
    final data = await SQLHelper.getAllDM();
    setState(() {
      dataList1 = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh();
    updataMenhgiaController.text = dataList2?['MenhGia'].toString() ?? "";
    updatenoidungController.text = dataList2?['NoiDung'].toString() ?? "";
  }

  //Update an DanhMuc
  Future<void> _updateDM(id) async {
    await SQLHelper.updateDM(id, int.parse(updataMenhgiaController.text),
        updatenoidungController.text);
    _refresh();
    print("Update completed");
  }

//Add a new DanhMuc
  Future<void> _addItem() async {
    await SQLHelper.createDM(
        noidungController.text, int.parse(menhgiaController.text));
    _refresh();
    print("Add completed");
  }

// Check is CapNhat mode?
  bool _CapNhat = false;

//Get DanhMuc by ID from DanhMuc_Activity
  Future<void> _getDM(id) async {
    final data = await SQLHelper.getDM(id);
    if (dataList2 != data) {
      setState(() {
        dataList2 = data;
        updataMenhgiaController.text = dataList2?['MenhGia'].toString() ?? "";
        updatenoidungController.text = dataList2?['NoiDung'].toString() ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int a = 0;
    // Get ID from DanhMuc_Activity
    final danhmuc = ModalRoute.of(context)!.settings.arguments;
    if (danhmuc != null) {
      _CapNhat = true;
      a = int.parse(danhmuc.toString());
      if (dataList2 == null) _getDM(a);
    }
    ;
//Appbar for Them Moi Danh Muc
    AppBar _addnewAppbar = AppBar(
      title: Text("Danh mục - Thêm mới"),
      actions: [
        FloatingActionButton(
          child: Icon(Icons.save, color: Colors.white,),
          backgroundColor: Colors.blueAccent,
          onPressed: () async {
            if (_fromKey.currentState!.validate()) {


              await _addItem();

              print("Noi dung la ${noidungController.text}");
            }
            _refresh();

            Navigator.pop(context);
            menhgiaController.clear();
            noidungController.clear();
          },
        )
      ],
    );
    //Appbar for Cap Nhat Danh Muc

    AppBar _updateAppbar = AppBar(
      title: Text("Danh mục - Cập nhật"),
      actions: [
        FloatingActionButton(
          child: Icon(Icons.save, color: Colors.white,),
          backgroundColor: Colors.blueAccent,
          onPressed: () async {
            if (_fromKey.currentState!.validate()) {
              _updateDM(a);

              print("Noi dung la dc cap nhat $a");
            }
            _refresh();

            Navigator.pop(context);
          },
        )
      ],
    );
    //Body for Them Moi Danh Muc
    Widget _addnewBody = Column(children: [
      Form(
          key: _fromKey,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(13.0, 13.0, 13.0,
                    5.0), // Set margins of 16 pixels on all sides

                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Vui lòng điền đầy đủ thông tin!";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  controller: menhgiaController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelText: "Nhập mệnh giá",
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: "Nhập mệnh giá",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(13.0, 5.0, 13.0,
                    5.0), // Set margins of 16 pixels on all sides

                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Vui lòng điền đầy đủ thông tin!";
                    }
                    return null;
                  },
                  controller: noidungController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelText: "Nhập nội dung",
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: "Nhập nội dung",
                  ),
                ),
              ),
            ],
          ))
    ]);
    //Body for Cap Nhat Danh Muc
    Widget _updateBody = Column(children: [
      Form(
          key: _fromKey,
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(13.0, 13.0, 13.0,
                    5.0), // Set margins of 16 pixels on all sides

                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Vui lòng điền đầy đủ thông tin!";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  controller: updataMenhgiaController,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelText: "Nhập mệnh giá",
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: "Nhập mệnh giá",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(13.0, 5.0, 13.0,
                    5.0), // Set margins of 16 pixels on all sides

                child: TextFormField(
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Vui lòng điền đầy đủ thông tin!";
                    }
                    return null;
                  },
                  controller: updatenoidungController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelText: "Nhập nội dung",
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: "Nhập nội dung",
                  ),
                ),
              ),
            ],
          ))
    ]);

    return Scaffold(
      appBar: _CapNhat ? _updateAppbar : _addnewAppbar,
      body: _CapNhat ? _updateBody : _addnewBody,
    );
  }
}
