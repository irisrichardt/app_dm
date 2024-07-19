import 'user.dart'; // Certifique-se de que o caminho esteja correto

class Team {
  final String id;
  final String name;
  final List<Usuario> members;

  Team({
    required this.id,
    required this.name,
    required this.members,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'],
      name: json['name'],
      members: (json['members'] as List<dynamic>)
          .map((member) =>
              Usuario.simpleFromJson(member as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'members': members.map((member) => member.simpleToJson()).toList(),
    };
  }
}
