class Usuario {
  final String username;
  final String password;
  final String name;
  final String birthDate;
  final String gender;
  final String email;

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
      'username': username,
      'password': password,
      'name': name,
      'birthDate': birthDate,
      'gender': gender,
      'email': email,
    };
  }
}
