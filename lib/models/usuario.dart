class Usuario {
  String username; // Renomeado de nome para username
  String password; // Campo adicionado
  String name; // Renomeado de nome para name
  DateTime birthDate; // Campo adicionado e do tipo DateTime
  String gender; // Campo adicionado
  String email;

  Usuario({
    required this.username,
    required this.password,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.email,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      username: json['username'] ?? '',
      password: json['password'] ?? '',
      name: json['name'] ?? '',
      birthDate: DateTime.tryParse(json['birthDate'] ?? '') ?? DateTime.now(),
      gender: json['gender'] ?? '',
      email: json['email'] ?? '',
    );
  }
}
