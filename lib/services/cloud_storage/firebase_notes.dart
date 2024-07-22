import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freecodecamp/services/cloud_storage/constaints.dart';

class CloudNotes {
  final String id;
  final String userId;
  String text;

  CloudNotes({required this.id, required this.userId, required this.text});
  CloudNotes.fromfirestore(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        userId = snapshot.data()[ownerIdfeildName],
        text = snapshot.data()[textfieldName];

  CloudNotes.fromfire(DocumentSnapshot<Map<String, dynamic>> snapshot)
      : id = snapshot.id,
        userId = snapshot.data()![ownerIdfeildName],
        text = snapshot.data()![textfieldName];
}
