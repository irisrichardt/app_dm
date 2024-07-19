import 'package:app_dm/models/user.dart';
import 'package:app_dm/services/user_service.dart';

class UserRepository {
  final UserService userService;

  UserRepository({required this.userService});

  Future<Usuario> createUser(Map<String, dynamic> data) async {
    return await userService.createUser(data);
  }

    Future<List<Usuario>> getUsers() {
    return userService.fetchUsers();
  }
}
