class Partida {

  late String data;
  late List<Jogador> jogadores;
  late int rodadas;
  late String vencedor;

  Partida({
    required this.data,
    required this.jogadores,
    required this.rodadas,
    required this.vencedor
  });

  calcularVencedor(){
    int maiorPlacar = -5;

    jogadores.forEach((jogador) {

      if(jogador.placar == maiorPlacar){
        vencedor = "Empate";
      }

      if(jogador.placar > maiorPlacar) {
        vencedor = jogador.nome;
        maiorPlacar = jogador.placar;
      }

    });
  }

  factory Partida.fromJson(Map<String, dynamic> json) => Partida(
    data: json["data"],
    jogadores: List<Jogador>.from(json["jogadores"].map((x) => Jogador.fromJson(x))),
    rodadas: json["rodadas"],
    vencedor: json["vencedor"]
  );

  Map<String, dynamic> toJson() => {
    "data": data,
    "jogadores": List<dynamic>.from(jogadores.map((x) => x.toJson())),
    "rodadas": rodadas,
    "vencedor": vencedor
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