import 'package:flutter/material.dart';
import 'package:note_pad/modules/note_model.dart';
import 'package:note_pad/providers/note_provider.dart';
import 'package:note_pad/screens/note_edit_screen.dart';
import 'package:provider/provider.dart';

class NoteScreen extends StatelessWidget {
  const NoteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('My Notes')),
      body: Consumer<NoteProvider>(
        builder: (context, note, child) {
          if (note.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          final notes = note.notes;
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  onChanged: note.searchNote,
                  decoration: InputDecoration(
                    hintText: 'Search',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
              ),
              Expanded(child: notes.isEmpty ? Center(child: Column(
                children: [
                  Text(note.search.isEmpty ? "No notes found!" : "Search note not found!")
                ],
              ),
              ) :
                  ListView.builder(
                    itemCount: notes.length,
                      itemBuilder: (context,index)
                      {
                        final demoNote = notes[index];
                        return Card(
                          child: ListTile(
                            title: Text(demoNote.title),
                            subtitle: Text(demoNote.content),
                            trailing: IconButton(onPressed: (){
                              _confirmDelete(context,demoNote);
                            }, icon: Icon(Icons.delete,color: Colors.red,),
                            ),
                            onTap: ()
                            {
                              Navigator.of(context).push(MaterialPageRoute(builder: (context)=>NoteEditorScreen()));
                            },
                          ),
                        );
                      })
              )
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(onPressed: ()
      {
        Navigator.of(context).push(MaterialPageRoute(builder: (context)=> NoteEditorScreen(),
        )
        );
        }, child: Icon(Icons.add),
      ),
    );
  }
}
void _confirmDelete(BuildContext context, NoteModel noteModel)
{
  showDialog(context: context, builder: (context)=>
      AlertDialog(
        title: Text("Are You Sure?"),
        content: Text("You want to delete this note!"),
        actions: [
          TextButton(onPressed: (){
            Navigator.of(context).pop();
          }, child: Text("Cancel")),
          FilledButton(onPressed: ()
          {
            context.read<NoteProvider>().deleteNote(noteModel.id);
            Navigator.of(context).pop();
          }, child: Text("Delete"))
        ],
      ));
}
