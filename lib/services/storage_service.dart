import 'dart:convert';

import 'package:note_pad/modules/note_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String noteKey = "userList";

  Future<List<NoteModel>> checkFile() async {
    final prefs = await SharedPreferences.getInstance();
    final String? noteJson = prefs.getString(noteKey);

    if (noteJson == null || noteJson.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> decodedList = json.decode(noteJson);
      return decodedList
          .map((item) => NoteModel.fromMap(item as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }


  Future<bool> saveNote(List<NoteModel> notes) async
  {
    final prefs = await SharedPreferences.getInstance();
    final List<Map<String,dynamic>> mapList = notes.map((notes)=> notes.toMap()).toList();
    final String encoded=json.encode(mapList);
    return await prefs.setString(noteKey, encoded);

  }
}
