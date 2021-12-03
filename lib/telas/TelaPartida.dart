// ignore_for_file: file_names
import 'dart:convert';
import 'dart:io';

import 'package:contador_tinco/modelos/partida.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import 'TelaPontuar.dart';

class TelaPartida extends StatefulWidget {
  const TelaPartida({Key? key}) : super(key: key);

  @override
  _TelaPartidaState createState() => _TelaPartidaState();
}

class _TelaPartidaState extends State<TelaPartida> {

  late Partida _partida;

    Future<Partida> _buscarPartida() async {
      final diretorio = await getApplicationDocumentsDirectory();
      final arquivo = File("${diretorio.path}/partidaAtual.json");
      String dados = await arquivo.readAsString();
      print("Recuperando partida: " + dados);
      return Partida.fromJson(json.decode(dados));
    }

  _encerrar() async {

    final diretorio = await getApplicationDocumentsDirectory();
    final arquivo = File("${diretorio.path}/partidas.json");
    String dados = await arquivo.readAsString();
    List<dynamic> objetos = json.decode(dados);
    print(objetos);
    _partida.calcularVencedor();
    objetos.add(_partida.toJson());
    print(objetos);

    await arquivo.writeAsString(json.encode(objetos));
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: const Text("Tinco")),
        body: SingleChildScrollView(
          child: Column(children: [
            Padding(
              padding: EdgeInsets.all(20),
              child: Center(
                child: Text(
                  "Partida Atual",
                  style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold)))),
            FutureBuilder<Partida>(
              future: _buscarPartida(),
              builder: (context, snapshot){
                if(snapshot.hasData){
                  _partida = snapshot.data!;
                  return ListView.builder(
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: _partida.jogadores.length,
                    itemBuilder: (context, i) {
                      return ListTile(
                        title: Text(_partida.jogadores[i].nome),
                        subtitle: Text("Placar: ${_partida.jogadores[i].placar.toString()} pontos"));
                  });
                }else{
                  return const Center(child: CircularProgressIndicator());
                }
            }),
            Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    child: Text("Pontuar"),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  TelaPontuar(partida: _partida))).then((_) => setState(() {}));
                    }),
                ElevatedButton(child: Text("Encerrar"), onPressed: _encerrar )
              ])
          ]
    )));
  }
}
