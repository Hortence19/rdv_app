import 'package:crypt/crypt.dart';

class MyUtils {
  String hashPswd(String psw) {
    final hashed = Crypt.sha256(psw, salt: 'to/?fbid=12625@@&3457!5');
    return hashed.hash;
  }
}
