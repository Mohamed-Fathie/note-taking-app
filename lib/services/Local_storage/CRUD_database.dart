import 'dart:async';
import 'dart:core';

import 'package:freecodecamp/dialog/generics/filtering.dart';
import 'package:freecodecamp/services/Local_storage/constaints.dart';
import 'package:freecodecamp/services/Local_storage/crud_exceptions.dart';
import 'package:freecodecamp/services/Local_storage/note_DB.dart';
import 'package:freecodecamp/services/Local_storage/user_DB.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';

class DBnote {
  Database? _db;
//cache notes
  List<NoteDatabase> _notes = [];
  UserDatabase? _user;

  // stream controller
  late final StreamController<List<NoteDatabase>> _noteStreamController;

  //stream for notes
  Stream<List<NoteDatabase>> get allnotes =>
      _noteStreamController.stream.filter((note) {
        final currentuser = _user;
        if (currentuser != null) {
          return note.userId == currentuser.id;
        } else {
          throw UserIsNull;
        }
      });

  //singlten instance in this class
  static final DBnote _shared = DBnote._initializer();

  DBnote._initializer() {
    _noteStreamController = StreamController<List<NoteDatabase>>.broadcast(
      onListen: () {
        _noteStreamController.sink.add(_notes);
      },
    );
  }

  factory DBnote() => _shared;

  Future<void> _ensureDBisoppened() async {
    try {
      await opendatabase();
    } on Couldnotopendb {
      //empty
    }
  }

  Future<UserDatabase> getOrCreateUser(
      {required String email, bool setcurrentuser = true}) async {
    try {
      final user = await getuser(email: email);
      if (setcurrentuser) {
        _user = user;
      }
      return user;
    } on DatabaseUserNotFound {
      final created = await createuser(email: email);
      if (setcurrentuser) {
        _user = created;
      }
      return created;
    } catch (e) {
      rethrow;
    }
  }

  Future<NoteDatabase> updateNote(
      {required NoteDatabase note, required String text}) async {
    await _ensureDBisoppened();
    final db = _getdatabaseorThrow();

    await getNote(id: note.id);
    final effects = await db.update(
      noteTable,
      {
        textcolom: text,
      },
      where: '$idcolom = ?',
      whereArgs: [note.id],
    );
    if (effects == 0) {
      throw CouldNotUpdateNote();
    } else {
      final Updatednote = await getNote(id: note.id);
      _notes.removeWhere((element) => element.id == note.id);
      _noteStreamController.add(_notes);
      return Updatednote;
    }
  }

  Future<List<NoteDatabase>> getAllNotes() async {
    await _ensureDBisoppened();
    final db = _getdatabaseorThrow();
    final notes = await db.query(noteTable);

    return notes.map((notesrow) => NoteDatabase.fromRow(notesrow)).toList();
  }

  Future<NoteDatabase> getNote({required int id}) async {
    await _ensureDBisoppened();
    final db = _getdatabaseorThrow();
    final note = await db.query(noteTable,
        where: '$idcolom = ?', whereArgs: [id], limit: 1);
    if (note.isEmpty) {
      throw CouldNotFindNote();
    }
    final row = NoteDatabase.fromRow(note[0]);
    _notes.removeWhere((element) => element.id == id);
    _notes.add(row);
    _noteStreamController.add(_notes);
    return row;
  }

  Future<int> deleteAllnote() async {
    await _ensureDBisoppened();
    final db = _getdatabaseorThrow();
    final deletedRows = await db.delete(noteTable);
    _notes = [];
    _noteStreamController.add(_notes);
    return deletedRows;
  }

  Future<void> deleteNote({required int id}) async {
    await _ensureDBisoppened();
    final db = _getdatabaseorThrow();
    final note = await db.delete(noteTable, where: 'id =?', whereArgs: [id]);
    if (note == 0) {
      throw NotExistingNote();
    } else {
      _notes.removeWhere((element) => element.id == id);
      _noteStreamController.add(_notes);
    }
  }

  Future<NoteDatabase> createNote({
    required UserDatabase owner,
  }) async {
    await _ensureDBisoppened();
    final db = _getdatabaseorThrow();
    final dbuser = await getuser(email: owner.email);
    if (dbuser != owner) {
      throw Couldnotfinduser();
    }
    final String text = '';
    final noteid = await db.insert(noteTable, {
      userIdcolom: owner.id,
      textcolom: text,
    });
    final note = NoteDatabase(id: noteid, userId: owner.id, text: text);
    _notes.add(note);
    _noteStreamController.add(_notes);
    return note;
  }

  Future<UserDatabase> getuser({required String email}) async {
    await _ensureDBisoppened();
    final db = _getdatabaseorThrow();
    final response = await db.rawQuery(
      '''SELECT * FROM 
      $usetTable WHERE $emailcolom = ? LIMIT 1''',
      [email],
    );
    if (response.isEmpty) {
      throw DatabaseUserNotFound();
    } else {
      return UserDatabase.fromRow(response[0]);
    }
  }

  Future<UserDatabase> createuser({required String email}) async {
    await _ensureDBisoppened();
    final db = _getdatabaseorThrow();

    final row = await db
        .rawQuery('''SELECT * FROM "user"  WHERE  email = ?;''', [email]);
    if (row.isNotEmpty) {
      throw UserAllreadyExist();
    }
    final userid = await db.insert(usetTable, {
      emailcolom: email,
    });
    return UserDatabase(id: userid, email: email);
  }

  Future<void> deleteuser({required String email, required int id}) async {
    await _ensureDBisoppened();
    final db = _getdatabaseorThrow();
    final String emails = email;
    final int ids = id;
    final response = await db.delete('user',
        where: 'id = ?  AND email = ?', whereArgs: [ids, emails]);
    if (response != 1) {
      throw Couldnotdeleteuser();
    }
  }

  Database _getdatabaseorThrow() {
    final db = _db;
    if (db == null) {
      throw closedDB();
    }
    return db;
  }

  Future<void> close() async {
    final db = _db;
    if (db != null) {
      await db.close();
      _db = null;
    } else {
      throw DbIsNotOpene();
    }
  }

  Future<void> opendatabase() async {
    final db = _db;
    if (db != null) {
      throw Couldnotopendb();
    }
    try {
      final docePath = await getApplicationDocumentsDirectory();
      final dbpath = join(docePath.path, dbName);
      final db = await openDatabase(dbpath);
      _db = db;
      // create note table in sqlite
      await db.execute(creatnoteTable);
      // create user table in sqlite
      await db.execute(creatuserTable);
      final allnotes = await getAllNotes();
      _notes = allnotes.toList();
      _noteStreamController.add(_notes);
    } on MissingPlatformDirectoryException {
      throw Unabletogetdirectory();
    }
  }
}
