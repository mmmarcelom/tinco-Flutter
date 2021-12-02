// ignore_for_file: file_names, non_constant_identifier_names, prefer_const_constructors
import 'package:contador_tinco/modelos/partida.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

import 'TelaPartida.dart';

class TelaInicial extends StatefulWidget {
  const TelaInicial({Key? key}) : super(key: key);

  @override
  _TelaInicialState createState() => _TelaInicialState();
}

class _TelaInicialState extends State<TelaInicial> {

  List<Partida> _partidas = [];

  _buscarPartidas() async{
    final diretorio = await getApplicationDocumentsDirectory();
    if(await File("${diretorio.path}/partidas.json").exists()) {
      final arquivo = File("${diretorio.path}/partidas.json");
      String dados = await arquivo.readAsString();

      List<dynamic> objetos = json.decode(dados);

      for(var i = 0; i<objetos.length; i++){
        _partidas.add(Partida.fromJson(objetos[i]));
      }

    } else {
      print("criou o arquivo inicial");
      File("${diretorio.path}/partidas.json").writeAsString("[]");
      File("${diretorio.path}/partidaAtual.json").writeAsString("");
    }
  }

  _criarNovaPartida() async {

    List<Jogador> jogadores = [];
    jogadores.add(Jogador(nome: "Marcelo", placar: 0));
    jogadores.add(Jogador(nome: "Tainá", placar: 0));
    jogadores.add(Jogador(nome: "Felipe", placar: 0));
    jogadores.add(Jogador(nome: "Erick", placar: 0));

    Partida _partida = Partida(data: "02/12/2021", jogadores: jogadores, rodadas: 0);

    final diretorio = await getApplicationDocumentsDirectory();

    print("Criando partida: " + json.encode(_partida.toJson()));
    await File("${diretorio.path}/partidaAtual.json").writeAsString(json.encode(_partida.toJson()));
  }


  @override
  Widget build(BuildContext context) {
    _partidas = [];
    return Scaffold(
      appBar: AppBar(title: const Text("Tinco")),
      body: SingleChildScrollView(
          child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(20),
                  child: Center(
                    child: Text(
                      "Minhas partidas",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold)))),
                FutureBuilder(
                  future: _buscarPartidas(),
                  builder: (context, snapshot){
                  switch(snapshot.connectionState){
                    case ConnectionState.none:
                    case ConnectionState.active:
                    case ConnectionState.waiting:
                      return const Center(child: CircularProgressIndicator());
                    case ConnectionState.done:
                    return _partidas.isNotEmpty
                      ? Padding(
                        padding: EdgeInsets.all(20),
                        child: Center(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: _partidas.length,
                            itemBuilder: (context, i) {
                              return ListTile(
                                  title: Text(_partidas[i].data.toString()),
                                  subtitle: Text("${_partidas[i].jogadores.length.toString()} jogadores"));
                            })))
                      : Padding(
                        padding: EdgeInsets.all(20),
                          child: Text("Nenhuma partida para exibir"));
                    }}),
                ElevatedButton(
                    onPressed: () {
                      _criarNovaPartida();
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TelaPartida())).then((_) => setState(() {}));
                    },
                    child: Text("Nova partida")),
                ElevatedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => TelaPartida())).then((_) => setState(() {}));
                    },
                    child: Text("Partida Atual")),
          ])),
    );
  }
}
