import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freecodecamp/dialog/logout_dialog.dart';
import 'package:freecodecamp/services/auth/bloc/auth_bloc.dart';
import 'package:freecodecamp/services/auth/bloc/auth_event.dart';
import 'package:freecodecamp/services/auth_service.dart';
import 'package:freecodecamp/services/cloud_storage/firebase_notes.dart';
import 'package:freecodecamp/services/storage_service.dart';
import 'package:freecodecamp/view/note/Observer/note_observer.dart';
import 'package:freecodecamp/view/note/list_of_notes.dart';

class NoteView extends StatefulWidget {
  const NoteView({super.key});

  @override
  State<NoteView> createState() => _NoteViewState();
}

enum MenuAction {
  logout;
}

class _NoteViewState extends State<NoteView> implements NoteObserver {
  String get userid => AuthService.firebase().currentUser!.id;
  late StorageFacade _facade;
  List<CloudNotes> _notes = [];
  //late final NoteService _noteservice;

  @override
  void initState() {
    _facade = StorageFacade();
    _facade.addObserver(this);
    _loadInitialNotes();
    super.initState();
  }

  @override
  void dispose() {
    _facade.removeObserver(this);
    super.dispose();
  }

  Future<void> _loadInitialNotes() async {
    final notes = await _facade.getAllRemoteNotes(ownerId: userid).first;
    setState(() {
      _notes = notes
          .map((note) =>
              CloudNotes(id: note.id, text: note.text, userId: note.userId))
          .toList();
    });
  }

  @override
  void onNoteAdded(CloudNotes note) {
    setState(() {
      _notes.add(CloudNotes(id: note.id, text: note.text, userId: note.userId));
    });
  }

  @override
  void onNoteDeleted(String noteId) {
    setState(() {
      _notes.removeWhere((note) => note.id == noteId.toString());
    });
  }

  @override
  void onNoteUpdated(CloudNotes note) {
    setState(() {
      final index = _notes.indexWhere((n) => n.id == note.id);
      if (index != -1) {
        _notes[index] =
            CloudNotes(id: note.id, text: note.text, userId: note.userId);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Notes'),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed('/newnote/');
              },
              icon: const Icon(Icons.add)),
          PopupMenuButton<MenuAction>(
            onSelected: (value) async {
              switch (value) {
                case MenuAction.logout:
                  if (await conformationDialog(
                        context: context,
                        title: 'log out',
                        content: 'are sure you want to log out',
                        button: 'Log out',
                      ) &&
                      context.mounted) {
                    context.read<AuthBloc>().add(
                          const LoggoutEvent(),
                        );
                  }
              }
            },
            itemBuilder: (context) {
              return const [
                PopupMenuItem<MenuAction>(
                  value: MenuAction.logout,
                  child: Text('log out'),
                ),
              ];
            },
          )
        ],
      ),
      body: ListOfNotes(
        notes: _notes,
        ondeletenote: (note) async {
          await _facade.deletenote(noteId: note.id);
        },
        onTapnote: (note) {
          Navigator.of(context).pushNamed('/newnote/', arguments: note);
        },
      ),

      // StreamBuilder(
      //     stream: _facade.getAllRemoteNotes(ownerId: userid),
      //     // _noteservice.allnotes(ownerid: userid),
      //     builder: (context, snapshot) {
      //       switch (snapshot.connectionState) {
      //         case ConnectionState.waiting:
      //         case ConnectionState.active:
      //           if (snapshot.hasData) {
      //             final allnotes = snapshot.data as List<CloudNotes>;
      //             return ListOfNotes(
      //               notes: allnotes,
      //               ondeletenote: (note) async {
      //                 await _facade.deletenote(noteId: note.id);
      //               },
      //               onTapnote: (note) {
      //                 Navigator.of(context)
      //                     .pushNamed('/newnote/', arguments: note);
      //               },
      //             );
      //           } else {
      //             return const Text('add new note');
      //           }
      //         default:
      //           return const Text('something went wrong');
      //       }
      //     })

      //  FutureBuilder(
      //   future: _noteservice.getOrCreateUser(email: useremail),
      //   builder: (context, snapshot) {
      //     switch (snapshot.connectionState) {
      //       case ConnectionState.done:
      //         return StreamBuilder(
      //             stream: _noteservice.allnotes,
      //             builder: (context, snapshot) {
      //               switch (snapshot.connectionState) {
      //                 case ConnectionState.waiting:
      //                 case ConnectionState.active:
      //                   if (snapshot.hasData) {
      //                     final allnotes = snapshot.data as List<NoteDatabase>;
      //                     print(allnotes);
      //                     return ListOfNotes(
      //                       notes: allnotes,
      //                       ondeletenote: (note) async {
      //                         await _noteservice.deleteNote(id: note.id);
      //                       },
      //                       onTapnote: (note) {
      //                         Navigator.of(context)
      //                             .pushNamed('/newnote/', arguments: note);
      //                       },
      //                     );
      //                   } else {
      //                     return const Text('add new note');
      //                   }
      //                 default:
      //                   return const Text('something went wrong');
      //               }
      //             });
      //       default:
      //         return const Text('builder ');
      //     }
      //   },
    );
  }
}
