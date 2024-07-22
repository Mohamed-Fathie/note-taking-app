import 'package:freecodecamp/services/Local_storage/constaints.dart';

class UserDatabase {
  final int id;
  final String email;

  UserDatabase({required this.id, required this.email});
  UserDatabase.fromRow(Map<String, Object?> map)
      : id = map[idcolom] as int,
        email = map[emailcolom] as String;

  @override
  String toString() {
    // TODO: implement toString
    return 'user id is $id';
  }

  @override
  bool operator ==(covariant UserDatabase other) => id == other.id;

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;
}
