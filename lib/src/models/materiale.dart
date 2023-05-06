import 'package:flutter/material.dart';

class Materiale{

  late int id;
  late String nome;
  late Color color;

  Materiale.fromJSON(jsonMap){
    id=jsonMap['id'];
    nome=jsonMap['name'];
    color=fromHex(jsonMap['color']);
  }

  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }
}