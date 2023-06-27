import 'CauHinh_Model.dart';

class Cauhinh_Publish extends CauHinh_Model {
  Cauhinh_Publish(int id, String url_service, String Username, String Password,
      String Acaccount, String Acpass, String Pattern, String Serial)
      : super(
      id: id,
      Url: url_service,
      Username: Username,
      Password: Password,
      Acaccount: Acaccount,
      Acpass: Acpass,
      Pattern: Pattern,
      Serial: Serial);
}