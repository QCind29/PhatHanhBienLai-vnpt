class CauHinh_Model {
  final int? id;
  final String? Url;
  final String? Username;
  final String? Password;
  final String? Acaccount;
  final String? Acpass;
  final String? Pattern;
  final String? Serial;

  CauHinh_Model({
    this.id,
    this.Url,
    this.Username,
    this.Password,
    this.Acaccount,
    this.Acpass,
    this.Pattern,
    this.Serial,
  });
  CauHinh_Model.fromMap(Map<String, dynamic> res)
      : id = res['id'],
        Url = res['Url'],
        Username = res['Username'],
        Password = res['Password'],
        Acaccount = res['Acacount'],
        Acpass = res['Acpass'],
        Pattern = res['Pattern'],
        Serial = res['Serial'];
  Map<String, Object?> toMap() {
    return {
      "id": id,
      "Url": Url,
      "Username": Username,
      "Password": Password,
      "Acaccount": Acaccount,
      "Acpass": Acpass,
      "Pattern": Pattern,
      "Serial": Serial
    };
  }
}
