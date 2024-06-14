import 'dart:io';

class Usuario {
  final String nome;
  final int cpf;
  final String email;
  final String senha;
  final File? avatar;

  Usuario({
    required this.nome,
    required this.cpf,
    required this.email,
    required this.senha,
    this.avatar,
  });
}
