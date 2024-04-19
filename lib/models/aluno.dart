import 'dart:io';

class Aluno {
  final String nome;
  final int matricula;
  final String email;
  final String senha;
  final File? avatar;

  Aluno({
    required this.nome,
    required this.matricula,
    required this.email,
    required this.senha,
    this.avatar,
  });
}
