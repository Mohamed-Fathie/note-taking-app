import 'package:freecodecamp/services/Local_storage/constaints.dart';

class NoteDatabase {
  final int id;
  final int userId;
  final String text;

  NoteDatabase({required this.id, required this.userId, required this.text});
  NoteDatabase.fromRow(Map<String, Object?> map)
      : id = map[idcolom] as int,
        userId = map[userIdcolom] as int,
        text = map[textcolom] as String;
  @override
  String toString() {
    // TODO: implement toString
    return 'note id = $id ,  text = $text userid = $userId';
  }

  bool operator ==(covariant NoteDatabase other) => id == other.id;

  @override
  // TODO: implement hashCode
  int get hashCode => id.hashCode;
}
