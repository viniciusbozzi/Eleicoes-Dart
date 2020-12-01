import 'dart:io';
import 'dart:convert';
import 'package:csv/csv.dart';

class Candidato {
  int numero;
  String nome;
  String partido;
  String coligacao;
  int nvotos;
  num votosval;
}

main() {
  var caminho = "testes/riodejaneiro/in/divulga.csv";
  final input = new File(caminho).openRead();
  final fields = input.transform(utf8.decoder).transform(new CsvToListConverter(fieldDelimiter: '\n')).toList();
  fields.then((values){

    var eleitos = [];
    var candidatos = [];
    var nvagas = 0;
    int total_votos = 0;
    var info;
    var partido;
    var coligacao;
    var sigla;
    var contents = values[0];
    contents.removeAt(0);

    for(var i = 0; i < (contents.length-1); i++){
      var politico1 = Candidato();
      info = contents[i].split(";");
      politico1.numero = int.parse(info[1]);
      politico1.nome = info[2];
      sigla = info[3];
      politico1.nvotos = int.parse(info[4].replaceAll(".", ""));
      total_votos = total_votos + politico1.nvotos;
      info[5] = info[5].replaceAll(",",".");
      politico1.votosval = double.parse(info[5].replaceAll(" %",""));

      if(sigla.contains('-')){
        sigla = sigla.split("-");
        politico1.partido = sigla[0].trim();
        politico1.coligacao = sigla[1].trim();
      }else{
        politico1.partido = sigla.trim();
        politico1.coligacao = "";
      }
      if(info[0][0] == "*"){
        nvagas = nvagas + 1;
        eleitos.add(politico1);
      }
      candidatos.add(politico1);
    }

    eleitos.sort((a,b) => a.nvotos.compareTo(b.nvotos));
    candidatos.sort((a,b) => a.nvotos.compareTo(b.nvotos));

    //Relatorios
    print("Número de vagas: $nvagas\n");
    print("Vereadores eleitos:");
    int j = 1;
    for(var i = (eleitos.length - 1); i >= 0; i--){
      var nome = eleitos[i].nome;
      var partido = eleitos[i].partido;
      var nvotos = eleitos[i].nvotos;
      var coligacao = eleitos[i].coligacao;
      if(coligacao.length > 1){
        print("$j - $nome ($partido, $nvotos votos) - Coligação: $coligacao");
      }else{
        print("$j - $nome ($partido, $nvotos votos)");
      }
      j = j + 1;
    }
    j = 1;
    print("\nCandidatos mais votados (em ordem decrescente de votação e respeitando o número de vagas):");
    for(var i = (candidatos.length - 1); i >= candidatos.length - nvagas; i--){
      var nome = candidatos[i].nome;
      var partido = candidatos[i].partido;
      var nvotos = candidatos[i].nvotos;
      var coligacao = candidatos[i].coligacao;
      if(coligacao.length > 1){
        print("$j - $nome ($partido, $nvotos votos) - Coligação: $coligacao");
      }else{
        print("$j - $nome ($partido, $nvotos votos)");
      }
      j = j + 1;
    }
    print("\nTotal de votos nominais: $total_votos");
  });    
}
