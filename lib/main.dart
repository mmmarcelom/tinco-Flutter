import 'package:flutter/material.dart';
import 'telas/TelaInicial.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: "/",
      routes: { "/inicial": (context) => TelaInicial() },
      home: TelaInicial()));
}