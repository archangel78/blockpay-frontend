import 'dart:async';
import 'package:encrypt/encrypt.dart';
import 'package:http/http.dart' as http;
import 'dart:typed_data';

Future<void> main() async {
  var url = Uri.http('127.0.0.1:8080', '/create_transaction');
  var privKeyId = "abcd";
  var toHashString = "{'toAccount: 'admin2', `amount`: `321`, `prover`: `" +
      privKeyId.substring(0, 4) +
      "`}";

  final key = Key.fromUtf8(privKeyId);
  final iv = IV.fromSecureRandom(16);
  AESMode mode = AESMode.cbc;
  final encrypter = Encrypter(AES(key, mode: mode));
  final encrypted = encrypter.encrypt(toHashString, iv: iv);

  print(encrypted.base16);
  print(iv.base16);

  var response = await http.post(url, headers: {
    "Accesstoken":
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhY2NvdW50TmFtZSI6ImFkbWluMSIsImVtYWlsSWQiOiJhZG1pbjFAZ21haWwuY29tIiwiZXhwIjoxNjY1MjEzNTQ3fQ.n-SyfHGJEqo5FaJRZb5G87P3LEY1mvSu6Ivz_-0kdbs",
    "Transactionkey": encrypted.base16,
    "iv": iv.base16
  });
  print(response.body);
}

Uint8List convertStringToUint8List(String str) {
  final List<int> codeUnits = str.codeUnits;
  print(codeUnits.length);
  final Uint8List unit8List = Uint8List.fromList(codeUnits);

  return unit8List;
}
