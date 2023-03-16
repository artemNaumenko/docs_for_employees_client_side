import 'package:crypto/crypto.dart';
import 'dart:convert';

class HashService{
  static Digest getHash(String str){
    List<int> bytes = utf8.encode(str); // data being hashed
    return sha1.convert(bytes);
  }
}