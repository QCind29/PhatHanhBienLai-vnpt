class DanhMuc_Model {
  final int? id;
  final String? NoiDung;
  final int? MenhGia;

   DanhMuc_Model({
     this.id,
     this.NoiDung,
     this.MenhGia,
  });

  // Convert a DanhMuc into a Map. The keys must correspond to the names of the
  // columns in the database.
  DanhMuc_Model.fromMap(Map<String, dynamic>res):
      id = res['id'],
        NoiDung = res['NoiDung'],
        MenhGia = res['MenhGia'];

  Map<String, Object?> toMap(){
    return {
      "id" : id,
      "NoiDung" : NoiDung,
      "MenhGia" : MenhGia,

    };
  }


}

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
