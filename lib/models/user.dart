class Usuario {
  final String id;
  final String username;
  final String password;
  final String name;
  final String birthDate;
  final String gender;
  final String email;

  Usuario({
    required this.id,
    required this.username,
    required this.password,
    required this.name,
    required this.birthDate,
    required this.gender,
    required this.email,
  });

  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      username: json['username'],
      password: json['password'],
      name: json['name'],
      birthDate: json['birthDate'],
      gender: json['gender'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'name': name,
      'birthDate': birthDate,
      'gender': gender,
      'email': email,
    };
  }

  factory Usuario.simpleFromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'],
      username: json['username'],
      password: '', // Opcional, dependendo de como deseja lidar com isso
      name: '',
      birthDate: '',
      gender: '',
      email: '',
    );
  }

  // Método toJson simplificado
  Map<String, dynamic> simpleToJson() {
    return {
      'id': id,
      'username': username,
    };
  }
}
