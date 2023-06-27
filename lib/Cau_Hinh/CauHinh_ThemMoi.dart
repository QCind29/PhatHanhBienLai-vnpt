import 'package:flutter/material.dart';

import '../Database/SQLHelper.dart';
import '../Model/CauHinh_Model.dart';
import '../Uppercase.dart';

class CauHinh_ThemMoi extends StatefulWidget {
  @override
  CauHinh_ThemMoiActivity createState() => CauHinh_ThemMoiActivity();
}


class CauHinh_ThemMoiActivity extends State<CauHinh_ThemMoi> {
  SQLHelper? sqlHelper;
  bool _CapNhat = false;


  List<Map<String, dynamic>> dataList1 = [];
  CauHinh_Model? _cauHinh_Model;
  Map<String, dynamic>? dataList2;

  final _fromKey = GlobalKey<FormState>();

  final urlController = TextEditingController();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final acaccountController = TextEditingController();
  final acpassController = TextEditingController();
  final patternController = TextEditingController();
  final serialController = TextEditingController();
// controller for update mode
  final updateurlController = TextEditingController();
  final updateusernameController = TextEditingController();
  final updatepasswordController = TextEditingController();
  final updateacaccountController = TextEditingController();
  final updateacpassController = TextEditingController();
  final updatepatternController = TextEditingController();
  final updateserialController = TextEditingController();

  void _refresh() async {
    final data = await SQLHelper.getAllCH();
    setState(() {
      dataList1 = data;
    });
  }

  @override
  void initState() {
    super.initState();
    _refresh();
    updateurlController.text = dataList2?['Url'].toString() ?? "";
    updateusernameController.text = dataList2?['Username'].toString() ?? "";
    updatepasswordController.text = dataList2?['Password'].toString() ?? "";
    updateacaccountController.text = dataList2?['Acaccount'].toString() ?? "";
    updateacpassController.text = dataList2?['Acpass'].toString() ?? "";
    updatepatternController.text = dataList2?['Pattern'].toString() ?? "";
    updateserialController.text = dataList2?['Serial'].toString() ?? "";
  }

  //Update an CauHinh
  Future<void> _updateCH(id) async {
    await SQLHelper.updateCH(
        id,
        updateurlController.text,
        updateusernameController.text,
        updatepasswordController.text,
        updateacaccountController.text,
        updateacpassController.text,
        updatepatternController.text,
        updateserialController.text);
    _refresh();
    print("Update completed");
  }

  //Add a new CauHinh
  Future<void> _addCH() async {
    await SQLHelper.createCH(
        urlController.text,
        usernameController.text,
        passwordController.text,
        acaccountController.text,
        acpassController.text,
        patternController.text,
        serialController.text);
    _refresh();
    print("Add completed");
  }

  //Get CauHinh by ID from CauHinh_Activity
  Future<void> _getCH(id) async {
    final data = await SQLHelper.getCH(id);
    if (dataList2 != data) {
      setState(() {
        dataList2 = data;
        updateurlController.text = dataList2?['Url'].toString() ?? "";
        updateusernameController.text = dataList2?['Username'].toString() ?? "";
        updatepasswordController.text = dataList2?['Password'].toString() ?? "";
        updateacaccountController.text =
            dataList2?['Acaccount'].toString() ?? "";
        updateacpassController.text = dataList2?['Acpass'].toString() ?? "";
        updatepatternController.text = dataList2?['Pattern'].toString() ?? "";
        updateserialController.text = dataList2?['Serial'].toString() ?? "";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    int a = 0;
    // Get ID from CauHinh_Activity
    final cauhinh = ModalRoute.of(context)!.settings.arguments;
    if (cauhinh != null) {
      _CapNhat = true;
      a = int.parse(cauhinh.toString());
      if (dataList2 == null) _getCH(a);
    }
    ;

    //Appbar for Them Moi Cau Hinh
    AppBar _addnewAppbar = AppBar(
      title: Text("Cấu hình - Thêm mới"),
      actions: [
        FloatingActionButton(
          child: Icon(Icons.save, color: Colors.white,),
          backgroundColor: Colors.blueAccent,
          onPressed: () async {
            if (_fromKey.currentState!.validate()) {
              await _addCH();
              print("Add new CH complete line 128");
            }
            _refresh();

            Navigator.pop(context);
            urlController.clear();
            usernameController.clear();
            passwordController.clear();
            acaccountController.clear();
            acpassController.clear();
            patternController.clear();
            serialController.clear();
          },
        )
      ],
    );
    //Appbar for Cap Nhat Cau Hinh
    AppBar _updateAppbar = AppBar(
      title: Text("Cấu hình - Cập nhật"),
      actions: [
        FloatingActionButton(
          child: Icon(Icons.save, color: Colors.white,),
          backgroundColor: Colors.blueAccent,
          onPressed: () async {
            if (_fromKey.currentState!.validate()) {
              await _updateCH(a);
            }
            _refresh();

            Navigator.pop(context);
          },
        )
      ],
    );

    // Body for Them Moi Cau Hinh
    Widget _addnewBody = SingleChildScrollView(child: Column(
      children: [
        Form(
          key: _fromKey,
      child: Column(
          children: [
        //Nhap url service form
        Container(
          margin: EdgeInsets.fromLTRB(
              13.0, 30.0, 13.0, 5.0), // Set margins of 16 pixels on all sides

          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "Vui lòng điền đầy đủ thông tin!";
              }
              return null;
            },
            controller: urlController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: "Nhập url service",
              labelStyle: TextStyle(color: Colors.grey),
              hintText: "Nhập url service",
            ),
          ),
        ),
        // Nhap username form
        Container(
          margin: EdgeInsets.fromLTRB(
              13.0, 5.0, 13.0, 5.0), // Set margins of 16 pixels on all sides

          child: TextFormField(
            validator: (value) {
              if (value!.isEmpty) {
                return "Vui lòng điền đầy đủ thông tin!";
              }
              return null;
            },
            controller: usernameController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: "Nhập username",
              labelStyle: TextStyle(color: Colors.grey),
              hintText: "Nhập username",
            ),
          ),
        ),
        //Nhap password form
        Container(
          margin: EdgeInsets.fromLTRB(
              13.0, 5.0, 13.0, 5.0), // Set margins of 16 pixels on all sides

          child: TextFormField(
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return "Vui lòng điền đầy đủ thông tin!";
              }
              return null;
            },
            controller: passwordController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: "Nhập password",
              labelStyle: TextStyle(color: Colors.grey),
              hintText: "Nhập password",
            ),
          ),
        ),

        // Nhap ac account form
        Container(
          margin: EdgeInsets.fromLTRB(
              13.0, 5.0, 13.0, 5.0), // Set margins of 16 pixels on all sides

          child: TextFormField(

            validator: (value) {
              if (value!.isEmpty) {
                return "Vui lòng điền đầy đủ thông tin!";
              }
              return null;
            },
            controller: acaccountController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: "Nhập ac account",
              labelStyle: TextStyle(color: Colors.grey),
              hintText: "Nhập ac account",
            ),
          ),
        ),

        // Nhap ac pass form
        Container(

          margin: EdgeInsets.fromLTRB(
              13.0, 5.0, 13.0, 5.0), // Set margins of 16 pixels on all sides

          child: TextFormField(
            obscureText: true,
            validator: (value) {
              if (value!.isEmpty) {
                return "Vui lòng điền đầy đủ thông tin!";
              }
              return null;
            },
            controller: acpassController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: "Nhập ac pass",
              labelStyle: TextStyle(color: Colors.grey),
              hintText: "Nhập ac pass",
            ),
          ),
        ),

        //Nhap pattern form
        Container(
          margin: EdgeInsets.fromLTRB(
              13.0, 5.0, 13.0, 5.0), // Set margins of 16 pixels on all sides

          child: TextFormField(
            inputFormatters: [
              UpperCaseTextFormatter(),
            ],
            validator: (value) {
              if (value!.isEmpty) {
                return "Vui lòng điền đầy đủ thông tin!";
              }
              return null;
            },
            controller: patternController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: "Nhập pattern",
              labelStyle: TextStyle(color: Colors.grey),
              hintText: "Nhập pattern",
            ),
          ),
        ),

        //Nhap serial form
        Container(
          margin: EdgeInsets.fromLTRB(
              13.0, 5.0, 13.0, 5.0), // Set margins of 16 pixels on all sides

          child: TextFormField(
            inputFormatters: [
              UpperCaseTextFormatter(),
            ],
            validator: (value) {
              if (value!.isEmpty) {
                return "Vui lòng điền đầy đủ thông tin!";
              }
              return null;
            },
            controller: serialController,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 1.5, color: Colors.grey),
                borderRadius: BorderRadius.circular(5.0),
              ),
              labelText: "Nhập serial",
              labelStyle: TextStyle(color: Colors.grey),
              hintText: "Nhập serial",
            ),
          ),
        ),
        ]))],
    ));

    // Body for Cap Nhat Cau Hinh

    Widget _updateBody =  SingleChildScrollView(child: Column(
      children: [
        Form(
            key: _fromKey,
            child: Column(
                children: [
                  //Nhap url service form
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        13.0, 30.0, 13.0, 5.0), // Set margins of 16 pixels on all sides

                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Vui lòng điền đầy đủ thông tin!";
                        }
                        return null;
                      },
                      controller: updateurlController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        labelText: "Nhập url service",
                        labelStyle: TextStyle(color: Colors.grey),
                        hintText: "Nhập url service",
                      ),
                    ),
                  ),
                  // Nhap username form
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        13.0, 5.0, 13.0, 5.0), // Set margins of 16 pixels on all sides

                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Vui lòng điền đầy đủ thông tin!";
                        }
                        return null;
                      },
                      controller: updateusernameController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        labelText: "Nhập username",
                        labelStyle: TextStyle(color: Colors.grey),
                        hintText: "Nhập username",
                      ),
                    ),
                  ),
                  //Nhap password form
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        13.0, 5.0, 13.0, 5.0), // Set margins of 16 pixels on all sides

                    child: TextFormField(
                      obscureText: true,


                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Vui lòng điền đầy đủ thông tin!";
                        }
                        return null;
                      },
                      controller: updatepasswordController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        labelText: "Nhập password",
                        labelStyle: TextStyle(color: Colors.grey),
                        hintText: "Nhập password",
                      ),
                    ),
                  ),

                  // Nhap ac account form
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        13.0, 5.0, 13.0, 5.0), // Set margins of 16 pixels on all sides

                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Vui lòng điền đầy đủ thông tin!";
                        }
                        return null;
                      },
                      controller: updateacaccountController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        labelText: "Nhập ac account",
                        labelStyle: TextStyle(color: Colors.grey),
                        hintText: "Nhập ac account",
                      ),
                    ),
                  ),

                  // Nhap ac pass form
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        13.0, 5.0, 13.0, 5.0), // Set margins of 16 pixels on all sides

                    child: TextFormField(
                      obscureText: true,


                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Vui lòng điền đầy đủ thông tin!";
                        }
                        return null;
                      },
                      controller: updateacpassController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        labelText: "Nhập ac pass",
                        labelStyle: TextStyle(color: Colors.grey),
                        hintText: "Nhập ac pass",
                      ),
                    ),
                  ),

                  //Nhap pattern form
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        13.0, 5.0, 13.0, 5.0), // Set margins of 16 pixels on all sides

                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Vui lòng điền đầy đủ thông tin!";
                        }
                        return null;
                      },
                      controller: updatepatternController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        labelText: "Nhập pattern",
                        labelStyle: TextStyle(color: Colors.grey),
                        hintText: "Nhập pattern",
                      ),
                    ),
                  ),

                  //Nhap serial form
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        13.0, 5.0, 13.0, 5.0), // Set margins of 16 pixels on all sides

                    child: TextFormField(
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Vui lòng điền đầy đủ thông tin!";
                        }
                        return null;
                      },
                      controller: updateserialController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(width: 1.5, color: Colors.grey),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        labelText: "Nhập serial",
                        labelStyle: TextStyle(color: Colors.grey),
                        hintText: "Nhập serial",
                      ),
                    ),
                  ),
                ]))],
    ));

    return Scaffold(
      appBar: _CapNhat ? _updateAppbar : _addnewAppbar ,
      body: _CapNhat ? _updateBody : _addnewBody,
    );
  }
}
