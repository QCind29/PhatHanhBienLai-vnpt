import 'dart:convert';
// import 'dart:html';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:vnpt/Model/Cauhinh_Portal.dart';
import 'package:vnpt/Model/Cauhinh_Publish.dart';
import 'package:vnpt/Model/RadioButton_Model.dart';

import 'package:http/http.dart' as http;

import '../Database/SQLHelper.dart';

import '../NumberToVietnamese.dart';
import 'PhatHanh_BienLai.dart';

class PhatHanh extends StatefulWidget {
  @override
  PhatHanhActivity createState() => PhatHanhActivity();
}

class PhatHanhActivity extends State<PhatHanh> {
  RadioButton_Model? radioButton_Model;

  Cauhinh_Portal? cauhinh_Portal;
  Cauhinh_Publish? cauhinh_Publish;

  bool _MenhGiaisNull = true;

  Map<String, dynamic>? dataList2;
  Map<String, dynamic>? dataList3;
  Map<String, dynamic>? dataList4;

  //SoLuong controller
  TextEditingController soluongController = TextEditingController();
  //TongTien controller
  TextEditingController tongtienController = TextEditingController();
// HoTen controller
  TextEditingController hoten_Controller = TextEditingController();
// DiaChi controller
  TextEditingController diachi_Controller = TextEditingController();

  int defaultSoluong = 1;
  int defaultTongtien = 1000;

  String radioValue1 = "";

  SQLHelper? sqlHelper;
  List<Map<String, dynamic>> dataList = [];

  void _refresh() async {
    final data = await SQLHelper.getAllDM();

    setState(() {
      dataList = data;
      _getCH1(8);
      _getCH2(9);
    });
  }

  @override
  void initState() {
    super.initState();
    tongtienController.text = 1000.toString();
    soluongController.text = defaultSoluong.toString();
    _refresh();
  }

// format for Numberformat
  menhgia(number) {
    final formatCurrency = NumberFormat("#,##0");
    return formatCurrency.format(number);
  }

  void showMessage(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  //Get CauHinh have id 8 from CauHinh table
  Future<void> _getCH1(id) async {
    final data = await SQLHelper.getCH(id);
    if (dataList3 != data) {
      setState(() {
        dataList3 = data;
        cauhinh_Publish = Cauhinh_Publish(
            dataList3!['id'],
            dataList3!['Url'],
            dataList3!['Username'],
            dataList3!['Password'],
            dataList3!['Acaccount'],
            dataList3!['Acpass'],
            dataList3!['Pattern'],
            dataList3!['Serial']);
      });
    }
  }

  //Get CauHinh have id 8 from CauHinh table
  Future<void> _getCH2(id) async {
    final data = await SQLHelper.getCH(id);
    if (dataList4 != data) {
      setState(() {
        dataList4 = data;
        cauhinh_Portal = Cauhinh_Portal(
            dataList4!['id'],
            dataList4!['Url'],
            dataList4!['Username'],
            dataList4!['Password'],
            dataList4!['Acaccount'],
            dataList4!['Acpass'],
            dataList4!['Pattern'],
            dataList4!['Serial']);
      });
    }
  }

  List<String> PhatHanh(String name, String address, int cost) {
    if (hoten_Controller.text == null || hoten_Controller.text == "") {
      showMessage("Lỗi nhập liệu", "Vui lòng nhập họ và tên!");
      throw Exception("Invalid input: Họ và tên không được để trống!");
    }

    if (diachi_Controller.text == null || diachi_Controller.text == "") {
      showMessage("Lỗi nhập liệu", "Vui lòng nhập địa chỉ!");
      throw Exception("Invalid input: Địa chỉ không được để trống!");
    }

    if (radioValue1 == null || radioValue1.length < 3) {
      showMessage("Lỗi nhập liệu", "Vui lòng chọn nội dung thanh toán");
      throw Exception("Invalid input: Nội dung thanh toán không hợp lệ!");
    }

    if (soluongController.text == null || soluongController.text == "") {
      showMessage("Lỗi nhập liệu", "Vui lòng nhập số lượng!");
      throw Exception("Invalid input: Số lượng không được để trống!");
    }
    if (int.parse(tongtienController.text) == 0 ||
        tongtienController.text.length < 3) {
      showMessage("Lỗi nhập liệu", "Vui lòng chọn nội dung thanh toán!");
      throw Exception("Invalid input: Nội dung thanh toán không hợp lệ!");
    }
    String amountInWords = NumberToVietnamese.convert(cost);

    String formatNB = menhgia(cost).toString();
    List<String> detailBill = [name, address, formatNB, amountInWords];
    return detailBill;
  }

  @override
  Widget build(BuildContext context) {
    String name = hoten_Controller.text;
    String address = diachi_Controller.text;

    int tt = 0;

    _refresh();
    return Scaffold(
        appBar: AppBar(
          title: Text("Phát hành"),
          actions: [
            FloatingActionButton(
              child: Icon(Icons.publish),
              backgroundColor: Colors.blueAccent,
              onPressed: () {
                print(radioValue1.length);
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PhatHanh_BienLai(),
                      // Pass the arguments as part of the RouteSettings. The
                      // DetailScreen reads the arguments from these settings.
                      settings: RouteSettings(
                          arguments: PhatHanh(name, address,
                              int.parse(tongtienController.text))),
                    ));
              },
            )
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(13.0, 5.0, 13.0,
                    5.0), // Set margins of 16 pixels on all sides

                child: TextFormField(
                  controller: hoten_Controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelText: "Nhập họ tên",
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: "Nhập họ tên",
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(13.0, 5.0, 13.0,
                    5.0), // Set margins of 16 pixels on all sides

                child: TextFormField(
                  controller: diachi_Controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelText: "Nhập địa chỉ",
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: "Nhập đỉa chỉ",
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(13.0, 5.0, 13.0, 0),
                  padding: const EdgeInsets.fromLTRB(10.0, 20.0, 30.0, 20.0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        // <-- SEE HERE
                        child: SizedBox.shrink(),
                      ),
                      Text(
                        "Nội dung",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),
                      Expanded(
                        // <-- SEE HERE
                        child: SizedBox.shrink(),
                        flex: 3,
                      ),
                      Text(
                        "Số tiền",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  )),
              Container(
                  height: 200,
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: dataList.length,
                      itemBuilder: (context, index) {
                        return Column(children: [
                          Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5.0),
                                side: BorderSide(
                                    color: Colors.black, width: 1.0)),
                            color: Colors.white,
                            margin:
                                const EdgeInsets.fromLTRB(14.5, 0.0, 14.5, 0.0),
                            child: ListTile(
                              title: Row(children: [
                                Text(
                                  dataList[index]['NoiDung'],
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Expanded(
                                  // <-- SEE HERE
                                  child: SizedBox.shrink(),
                                  flex: 3,
                                ),
                                Align(
                                  alignment: Alignment.centerRight,
                                  child: Text(
                                    menhgia(int.parse(dataList[index]['MenhGia']
                                            .toString())) +
                                        "đ",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ]),
                              leading: Radio(
                                value: dataList[index]['MenhGia'].toString(),
                                groupValue: radioValue1,
                                onChanged: (value) {
                                  setState(() {
                                    radioValue1 = value!;
                                    radioButton_Model = RadioButton_Model(
                                        dataList[index]['id'],
                                        dataList[index]['NoiDung'],
                                        dataList[index]['MenhGia']);

                                    tt = int.parse(radioValue1) *
                                        int.parse(soluongController.text);
                                    tongtienController.text = tt.toString();
                                    _MenhGiaisNull = false;
                                  });
                                },
                              ),
                            ),
                          )
                        ]);
                      })),
              Container(
                margin: EdgeInsets.fromLTRB(13.0, 5.0, 13.0,
                    5.0), // Set margins of 16 pixels on all sides

                child: TextFormField(
                  controller: soluongController,
                  keyboardType: TextInputType.number,
                  onChanged: (value1) {
                    tt = int.parse(radioValue1) * int.parse(value1);
                    tongtienController.text = tt.toString();
                    soluongController.text = value1.toString();

                    // print("line 210 $text ,so luong $value1");
                    // focus.
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(width: 1.5, color: Colors.grey),
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                    labelText: "Nhập số lượng",
                    labelStyle: TextStyle(color: Colors.grey),
                    hintText: "Nhập số lượng",
                  ),
                ),
              ),
              Container(
                  margin: EdgeInsets.fromLTRB(13.0, 5.0, 13.0, 0),
                  padding: const EdgeInsets.fromLTRB(10.0, 20.0, 30.0, 20.0),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1.5, color: Colors.grey),
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        // <-- SEE HERE
                        child: SizedBox.shrink(),
                      ),
                      Text(
                        "Nội dung:",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15.0),
                      ),
                      Expanded(
                        // <-- SEE HERE
                        child: SizedBox.shrink(),
                        flex: 3,
                      ),
                      _MenhGiaisNull
                          ? Text("0đ",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ))
                          : Text(
                              menhgia(int.parse(tongtienController.text)) + "đ",
                              // Text("1000đ",

                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 15.0,
                              ),
                            ),
                    ],
                  )),
            ],
          ),
        ));
  }
}
