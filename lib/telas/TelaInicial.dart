// ignore_for_file: file_names, non_constant_identifier_names, prefer_const_constructors
import 'package:contador_tinco/modelos/partida.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';


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

    final DateTime agora = DateTime.now();
    final DateFormat formatador = DateFormat('dd/MM/yyyy');
    final String hoje = formatador.format(agora);
    print(hoje);

    Partida _partida = Partida(data: hoje, jogadores: jogadores, rodadas: 0, vencedor: "");

    final diretorio = await getApplicationDocumentsDirectory();

    print("Criando partida: " + json.encode(_partida.toJson()));
    await File("${diretorio.path}/partidaAtual.json").writeAsString(json.encode(_partida.toJson()));
  }

  @override
  void initState() {
    super.initState();
    Intl.defaultLocale = 'pt_BR';
    initializeDateFormatting('pt_BR', null);
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
                  padding: EdgeInsets.only(top: 25, bottom: 20),
                  child: Center(
                    child: Text(
                      "Minhas partidas",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold)))),
                Divider(),
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
                        padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
                        child: Center(
                          child: ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            itemCount: _partidas.length,
                            itemBuilder: (context, i) {
                              return Card(
                                color: Colors.blueAccent.withOpacity(0.2),
                                margin: EdgeInsets.all(5),
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(10, 20, 10, 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Data: ${_partidas[i].data}"),
                                          Text("Vencedor: ${_partidas[i].vencedor}"),
                                      ])),
                                    Padding(
                                      padding: EdgeInsets.fromLTRB(10, 5, 10, 20),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text("Jogadores: ${_partidas[i].jogadores.length.toString()}"),
                                      ])),
                                  ]));
                            })))
                      : Padding(
                        padding: EdgeInsets.all(20),
                          child: Text("Nenhuma partida para exibir"));
                    }}),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
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
                        child: Text("Partida Atual"))
                ])
          ])),
    );
  }
}
