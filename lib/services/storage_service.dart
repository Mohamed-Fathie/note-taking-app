import 'package:freecodecamp/services/Local_storage/CRUD_database.dart';
import 'package:freecodecamp/services/Local_storage/note_DB.dart';
import 'package:freecodecamp/services/cloud_storage/CRUD_firebase.dart';
import 'package:freecodecamp/services/cloud_storage/firebase_notes.dart';

class StorageFacade {
  //singlten instance in this class
  static StorageFacade? _storage = StorageFacade._instantiation();
  StorageFacade._instantiation();
  factory StorageFacade() {
    if (_storage == null) {
      return _storage = StorageFacade._instantiation();
    }
    return _storage!;
  }

  //local storage
  final DBnote _localStorage = DBnote();
  //remote storage
  final FirebaseNote _remoteStorage = FirebaseNote();

  //  CRUD operatios

  // C in CRUD
  Future<CloudNotes> createNote({
    required String ownerEmail,
  }) async {
    final localUser = await _localStorage.getOrCreateUser(email: ownerEmail);
    // await _localStorage.createNote(owner: localUser);
    final notes =
        await _remoteStorage.createNote(ownerId: localUser.id.toString());

    return notes;
  }

//R in CRUD
  Stream<List<CloudNotes>> getAllRemoteNotes({required String ownerId}) {
    return _remoteStorage.allnotes(ownerid: ownerId);
  }

  Future<List<NoteDatabase>> getAllLocalNotes() async {
    return await _localStorage.getAllNotes();
  }

  //synching notes
  Future<void> synchronizeNotes({required String ownerEmail}) async {
    final localNotes = await _localStorage.getAllNotes();
    for (var note in localNotes) {
      await _remoteStorage.createNote(
        ownerId: note.userId.toString(),
      );
    }
  }

  //U in CRUD
  Future<void> updateNote({
    required String noteid,
    required String text,
  }) async {
    // final localNote = await _localStorage.getNote(id: int.parse(noteid));
    // await _localStorage.updateNote(note: localNote, text: text);
    await _remoteStorage.updatenote(noteid: noteid, text: text);
  }

//D in CRUD
  Future<void> deletenote({required String noteId}) async {
    // await _localStorage.deleteNote(id: int.parse(noteId));
    await _remoteStorage.deletenote(noteid: noteId);
  }
}
