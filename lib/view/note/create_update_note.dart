import 'package:flutter/material.dart';
import 'package:freecodecamp/dialog/generics/get_argument.dart';
import 'package:freecodecamp/dialog/share_empty_note.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/services/cloud_storage/firebase_notes.dart';
import 'package:freecodecamp/services/storage_service.dart';
import 'package:share_plus/share_plus.dart';

class CreatOrUpdateNote extends StatefulWidget {
  const CreatOrUpdateNote({super.key});

  @override
  State<CreatOrUpdateNote> createState() => _CreatOrUpdateNoteState();
}

class _CreatOrUpdateNoteState extends State<CreatOrUpdateNote> {
  final String ownerEmail = AuthService.firebase().currentUser!.email;
  CloudNotes? _note;
  // NoteDatabase? _note;
  //late final FirebaseService _noteservice;
  late StorageFacade _facade;
  //late final NoteService _noteservice;
  late TextEditingController _controller;
  @override
  void initState() {
    _facade = StorageFacade();
    _controller = TextEditingController();
    super.initState();
  }

  Future<CloudNotes> _createNewNote(BuildContext context) async {
    final response = context.getargument<CloudNotes>();
    if (response != null) {
      _note = response;
      _controller.text = response.text;
      return response;
    }
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    } else {
      //final owner = await _noteservice.getuser(email: useremail);
      final creatednote = await _facade.createNote(ownerEmail: ownerEmail);
      _note = creatednote;
      return creatednote;
    }
  }

  void _deleteNoteIfEmpty() async {
    final note = _note;
    if (_controller.text.isEmpty && note != null) {
      //_noteservice.deletenote(noteid: note.id);
      _facade.deletenote(noteId: note.id);
    }
  }

  void _controllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _controller.text;
    await _facade.updateNote(noteid: note.id, text: text);
  }

  void _savenote() async {
    final note = _note;
    final text = _controller.text;
    if (note != null && text.isNotEmpty) {
      await _facade.updateNote(noteid: note.id, text: text);
    }
  }

  void _setListener() {
    _controller.removeListener(_controllerListener);
    _controller.addListener(_controllerListener);
  }

  @override
  void dispose() async {
    _deleteNoteIfEmpty();
    _savenote();
    _controller.dispose();
    super.dispose();
    await _facade.synchronizeNotes(ownerEmail: ownerEmail);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('new note'),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            onPressed: () async {
              if (_note == null || _controller.text.isEmpty) {
                await shareemptynote(context);
              } else {
                Share.share(_controller.text);
              }
            },
            icon: const Icon(Icons.share_rounded),
          )
        ],
      ),
      body: FutureBuilder(
        future: _createNewNote(context),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.done:
              _setListener();
              return TextField(
                controller: _controller,
                decoration:
                    const InputDecoration(hintText: "write your note here:"),
                keyboardType: TextInputType.multiline,
                maxLines: null,
              );
            default:
              return const CircularProgressIndicator();
          }
        },
      ),
    );
  }
}