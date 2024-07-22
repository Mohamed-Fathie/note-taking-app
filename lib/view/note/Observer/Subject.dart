import 'package:freecodecamp/services/cloud_storage/firebase_notes.dart';
import 'package:freecodecamp/view/note/Observer/note_observer.dart';

abstract class Subject {
  void addObserver(NoteObserver observer);
  void removeObserver(NoteObserver observer);
  void notifyNoteAdded(CloudNotes note);
  void notifyNoteUpdated(CloudNotes note);
  void notifyNoteDeleted(String noteId);
}
