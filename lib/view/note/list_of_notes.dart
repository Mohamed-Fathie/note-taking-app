import 'package:flutter/material.dart';
import 'package:freecodecamp/dialog/logout_dialog.dart';
import 'package:freecodecamp/services/cloud_storage/firebase_notes.dart';

typedef NoteCallback = void Function(CloudNotes note);

class ListOfNotes extends StatelessWidget {
  final List<CloudNotes> notes;
  final NoteCallback ondeletenote;
  final NoteCallback onTapnote;
  const ListOfNotes(
      {super.key,
      required this.notes,
      required this.ondeletenote,
      required this.onTapnote});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (context, index) {
        final note = notes[index];
        return ListTile(
          onTap: () => onTapnote(note),
          title: Text(
            note.text,
            maxLines: 1,
            softWrap: true,
            overflow: TextOverflow.ellipsis,
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              if (await conformationDialog(
                    context: context,
                    title: "delete",
                    content: "are you sure you want to delet this note",
                    button: 'yes',
                  ) ==
                  true) {
                ondeletenote(note);
              }
            },
          ),
        );
      },
    );
  }
}
