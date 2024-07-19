import 'dart:io';

class Atividade {
  final String titulo;
  final String descricao;
  final String status;
  final String prioridade;
  final int storyPoints;
  final String equipeResponsavel;
  final List<File>? anexos;

  Atividade({
    required this.titulo,
    required this.descricao,
    required this.status,
    required this.prioridade,
    required this.storyPoints,
    required this.equipeResponsavel,
    this.anexos,
  });
}
