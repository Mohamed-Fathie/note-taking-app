import 'package:freecodecamp/services/cloud_storage/firebase_notes.dart';

abstract class NoteObserver {
  void onNoteAdded(CloudNotes note);
  void onNoteUpdated(CloudNotes note);
  void onNoteDeleted(String noteId);
}
