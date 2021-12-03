// ignore_for_file: file_names
import 'package:contador_tinco/modelos/partida.dart';
import 'package:flutter/material.dart';

import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

class TelaPontuar extends StatefulWidget {
  final Partida partida;
  const TelaPontuar({Key? key, required this.partida}) : super(key: key);

  @override
  _TelaPontuarState createState() => _TelaPontuarState();
}

class _TelaPontuarState extends State<TelaPontuar> {

  @override
  void initState() {
    super.initState();
    widget.partida.jogadores.forEach(
      (jogador) {
        jogador.trinco = false;
        jogador.set = false;
        jogador.medalhao = false;
    });
  }

  _calcular() async {

    widget.partida.jogadores.forEach((jogador) => jogador.pontuar());

    final diretorio = await getApplicationDocumentsDirectory();
    print("Atualizando partida: " + widget.partida.toString());
    File("${diretorio.path}/partidaAtual.json").writeAsString(json.encode(widget.partida.toJson()));

    Navigator.pop(context);

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Tinco")),
        body: SingleChildScrollView(
          child: Column(
          children: [
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: widget.partida.jogadores.length,
              itemBuilder: (context, i) {
                return CardJogador(jogador: widget.partida.jogadores[i]);
            }),
            ElevatedButton(onPressed: _calcular, child: Text("Calcular"))
        ])
    ));
  }
}

class CardJogador extends StatefulWidget {
  final Jogador jogador;
  const CardJogador({Key? key, required this.jogador}) : super(key: key);

  @override
  _CardJogadorState createState() => _CardJogadorState();
}

class _CardJogadorState extends State<CardJogador> {

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.amber.withOpacity(0.5),
        margin: EdgeInsets.fromLTRB(20, 10, 20, 0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(widget.jogador.nome, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15))),
                  GestureDetector(
                      child: BotaoImagem(
                        imagem: "imagens/set.png", tapped: widget.jogador.set),
                        onTap: () => setState(() { widget.jogador.set = !widget.jogador.set; })),
                  GestureDetector(
                      child: BotaoImagem(
                        imagem: "imagens/medalhao.png",
                        tapped: widget.jogador.medalhao),
                      onTap: () => setState(() { widget.jogador.medalhao = !widget.jogador.medalhao; })),
                  GestureDetector(
                      child: BotaoImagem(
                        imagem: "imagens/trinco.png",
                        tapped: widget.jogador.trinco),
                      onTap: () => setState(() { widget.jogador.trinco = !widget.jogador.trinco; })),
                ])
            ]));
  }
}

class BotaoImagem extends StatefulWidget {
  final String imagem;
  final bool tapped;
  const BotaoImagem({Key? key, required this.imagem, required this.tapped }) : super(key: key);

  @override
  _BotaoImagemState createState() => _BotaoImagemState();
}

class _BotaoImagemState extends State<BotaoImagem> {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: widget.tapped ? EdgeInsets.all(5) : EdgeInsets.all(8),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            border: widget.tapped ? Border.all(color: Colors.black26, width: 5) : Border.all(color: Colors.black26, width: 2)),
        child: Image.asset(widget.imagem, width: 50, height: 50, fit: BoxFit.contain, alignment: Alignment.center));
  }
}
