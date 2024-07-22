import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freecodecamp/services/cloud_storage/constaints.dart';
import 'package:freecodecamp/services/cloud_storage/firebase_notes.dart';

class FirebaseNote {
  final notes = FirebaseFirestore.instance.collection("notes");

  //singlten instance in this class
  static FirebaseNote? _instance;
  FirebaseNote._Singleton();
  factory FirebaseNote() {
    if (_instance == null) {
      return _instance = FirebaseNote._Singleton();
    }
    return _instance!;
  }

  Stream<List<CloudNotes>> allnotes({required String ownerid}) {
    // Return a stream of list of CloudNotes objects
    return notes.snapshots().map((event) =>
        // Transform each snapshot into a list of CloudNotes objects
        event.docs
            // Map each document to a CloudNotes object using a factory constructor
            .map((e) => CloudNotes.fromfirestore(e))
            // Filter the CloudNotes objects to include only those with the matching ownerid
            .where((element) => element.userId == ownerid)
            // Convert the filtered results to a list
            .toList());
  }

  // C in CRUD
  Future<CloudNotes> createNote({required String ownerId}) async {
    return await notes.add({
      ownerIdfeildName: ownerId,
      textfieldName: "",
    }).then((value) {
      return value.get().then((value) => CloudNotes(
            id: value.id,
            userId: ownerId,
            text: "",
          ));
    });
  }

// R in CRUD.
  Future<List<CloudNotes>> getallnotes({required String ownerId}) async {
    return await notes
        .where(ownerIdfeildName, isEqualTo: ownerId)
        .get()
        .then((value) => value.docs.map((e) {
              return CloudNotes.fromfirestore(e);
            }).toList());
  }

//U in CRUD
  Future<CloudNotes> updatenote(
      {required String noteid, required String text}) async {
    await notes.doc(noteid).update({textfieldName: text});
    final docSnapshot = await notes.doc(noteid).get();

    if (docSnapshot.exists) {
      return CloudNotes.fromfire(docSnapshot);
    } else {
      throw Exception("Note not found");
    }
  }

//  D in CRUD
  Future<void> deletenote({required String noteid}) async {
    await notes.doc(noteid).delete();
  }
}
