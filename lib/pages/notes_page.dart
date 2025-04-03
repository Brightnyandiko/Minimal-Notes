import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:minimal_notes_app/components/drawer.dart';
import 'package:minimal_notes_app/components/note_tile.dart';
import 'package:minimal_notes_app/models/note.dart';
import 'package:minimal_notes_app/models/notes_database.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final textController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //on app startup, fetch the existing note
    readNotes();
  }

  //create a note
  void createNote(){
    showDialog(context: context, builder: (context) => AlertDialog(
      backgroundColor: Theme.of(context).colorScheme.background,
      content: TextField(
        controller: textController,
      ),
      actions: [
        //create button
        MaterialButton(onPressed: () {
          //add to db
          context.read<NoteDatabase>().addNote(textController.text);

          //clear the controller
          textController.clear();

          //pop the dialog
          Navigator.pop(context);
        },
        child: const Text("Create"),
        )
      ],
    ));
  }

  //read notes
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  //update a note
  void updateNotes(Note note) {
    // pre-fill the current note text
    textController.text = note.text;
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: Theme.of(context).colorScheme.background,
          title: Text("Update Note"),
          content: TextField(controller: textController,),
          actions: [
            MaterialButton(
                onPressed: () {
                  //update note in db
                  context.read<NoteDatabase>().updateNote(note.id, textController.text);

                  //clear controller
                  textController.clear();

                  //pop the dialog box
                  Navigator.pop(context);
                },
              child: const Text("Update"),
            )
          ],
        )
    );
  }

  //delete a note
  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }
  @override
  Widget build(BuildContext context) {
    //note database
    final noteDatabase = context.watch<NoteDatabase>();

    //current notes
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      backgroundColor: Theme.of(context).colorScheme.background,
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        backgroundColor: Theme.of(context).colorScheme.primary,
        child:  Icon(Icons.add, color: Theme.of(context).colorScheme.inversePrimary,),
      ),
      drawer: MyDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // HEADING
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: Text(
              "Notes",
              style: GoogleFonts.dmSerifText(
                  fontSize: 48,
                  color: Theme.of(context).colorScheme.inversePrimary
              ),
            ),
          ),

          //LIST OF NOTES
          Expanded(
            child: ListView.builder(
              itemCount: currentNotes.length,
                itemBuilder: (context, index) {
                  // get individual note
                  final note = currentNotes[index];

                  //return ListTile
                  return NoteTile(
                      text: note.text,
                      onDeletePressed: () => deleteNote(note.id),
                      onEditPressed: () => updateNotes(note),
                  );

                }
            ),
          ),
        ],
      ),
    );
  }
}
