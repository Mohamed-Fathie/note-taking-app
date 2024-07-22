import 'package:freecodecamp/services/Local_storage/CRUD_database.dart';
import 'package:freecodecamp/services/Local_storage/note_DB.dart';
import 'package:freecodecamp/services/cloud_storage/CRUD_firebase.dart';
import 'package:freecodecamp/services/cloud_storage/firebase_notes.dart';
import 'package:freecodecamp/view/note/Observer/Subject.dart';
import 'package:freecodecamp/view/note/Observer/note_observer.dart';

class StorageFacade implements Subject {
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
  final List<NoteObserver> _observers = [];
  //  CRUD operatios

  // C in CRUD
  Future<CloudNotes> createNote({
    required String ownerEmail,
  }) async {
    final localUser = await _localStorage.getOrCreateUser(email: ownerEmail);
    await _localStorage.createNote(owner: localUser);
    final notes =
        await _remoteStorage.createNote(ownerId: localUser.id.toString());
    notifyNoteAdded(notes);
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
    final localNote = await _localStorage.getNote(id: int.parse(noteid));
    await _localStorage.updateNote(note: localNote, text: text);
    final note = await _remoteStorage.updatenote(noteid: noteid, text: text);
    notifyNoteUpdated(note);
  }

//D in CRUD
  Future<void> deletenote({required String noteId}) async {
    await _localStorage.deleteNote(id: int.parse(noteId));
    await _remoteStorage.deletenote(noteid: noteId);
    notifyNoteDeleted(noteId);
  }

  @override
  void addObserver(NoteObserver observer) {
    _observers.add(observer);
  }

  @override
  void removeObserver(NoteObserver observer) {
    _observers.remove(observer);
  }

  @override
  void notifyNoteAdded(CloudNotes note) {
    for (var observer in _observers) {
      observer.onNoteAdded(note);
    }
  }

  @override
  void notifyNoteDeleted(String noteId) {
    for (var observer in _observers) {
      observer.onNoteDeleted(noteId);
    }
  }

  @override
  void notifyNoteUpdated(CloudNotes note) {
    for (var observer in _observers) {
      observer.onNoteUpdated(note);
    }
  }
}
