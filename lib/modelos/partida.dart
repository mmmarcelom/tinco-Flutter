class Partida {

  late String data;
  late List<Jogador> jogadores;
  late int rodadas;

  Partida({
    required this.data,
    required this.jogadores,
    required this.rodadas
  });

  factory Partida.fromJson(Map<String, dynamic> json) => Partida(
    data: json["data"],
    jogadores: List<Jogador>.from(json["jogadores"].map((x) => Jogador.fromJson(x))),
    rodadas: json["rodadas"],
  );

  Map<String, dynamic> toJson() => {
    "data": data,
    "jogadores": List<dynamic>.from(jogadores.map((x) => x.toJson())),
    "rodadas": rodadas,
  };
}

class Jogador{
  String nome;
  int placar;
  late bool trinco;
  late bool set;
  late bool medalhao;

  Jogador({required this.nome, required this.placar});

  factory Jogador.fromJson(Map<String, dynamic> json) => Jogador(
    nome: json["nome"],
    placar: json["placar"],
  );

  Map<String, dynamic> toJson() => {
    "nome": nome,
    "placar": placar,
  };

  pontuar(){

    int pontos = 0;

    if(medalhao && set){
      pontos++;
    }

    if(medalhao == false){
      pontos--;
    }

    if(trinco == true){
      pontos--;
    }

    placar = placar + pontos;
    print("$nome: ${placar.toString()}");
  }

}