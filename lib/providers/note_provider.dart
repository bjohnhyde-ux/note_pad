import 'package:flutter/material.dart';
import 'package:note_pad/modules/note_model.dart';
import 'package:note_pad/services/storage_service.dart';

class NoteProvider extends ChangeNotifier {
  final StorageService _storageService = StorageService();

  List<NoteModel> _list = [];
  bool _isLoading = true;
  String _search = "";

  List<NoteModel> get notes {
    if (_search.trim().isEmpty) {
      return _list;
    }

    return _list.where((note) {
      final q = _search.toLowerCase();
      return note.title.toLowerCase().contains(q) ||
          note.content.toLowerCase().contains(q);
    }).toList();
  }

  bool get isLoading => _isLoading;
  String get search => _search;

  Future<void> fetchAndSetNotes() async
  {
    _isLoading = true;
    notifyListeners();

    List<NoteModel> loadedNote = await _storageService.checkFile();
    _list.sort((a,b)=> b.datetime.compareTo(a.datetime));
    _isLoading = false;
    notifyListeners();
  }
  // Add new Note
  Future<void> addNote(String title, String content) async{
    final newNote = NoteModel(
        id: DateTime.now().toString(),
        title: title.trim().isEmpty? 'Untitled' : title.trim(),
        content: content.trim(),
        datetime: DateTime.now(),);
    _list.insert(0, newNote);
    notifyListeners();
    await _storageService.saveNote(_list);
  }
  //Update


Future<void> updateNote(String id, String newTitle, String newContent) async{
    final index=_list.indexWhere((note)=>note.id==id);

    if(index!=-1){
      _list[index].title=newTitle.trim().isEmpty? "untitle" : newTitle.trim();
      _list[index].content=newContent.trim();
      _list[index].datetime=DateTime.now();


      final updateNote=_list.removeAt(index);
      _list.insert(0, updateNote);

      notifyListeners();
      await _storageService.saveNote(_list);
    }
}


//Delete

Future<void> deleteNote(String id)
  async{
    _list.removeWhere((note)=>note.id == id);
    notifyListeners();
    await _storageService.saveNote(_list);
  }

  //Search
void searchNote (String query){
    _search = query;
    notifyListeners();

}
}

