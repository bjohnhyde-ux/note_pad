import 'dart:convert';

class NoteModel {
  final String id;
  String title;
  String content;
  DateTime datetime;

  NoteModel({
    required this.id,
    required this.title,
    required this.content,
    required this.datetime,
  });
  //Map to JSON ENCODING
  Map<String,dynamic> toMap()
  {
    return
      {
        'id':id,
        'title':title,
        'content':content,
        'datetime':datetime.toIso8601String()
      };
  }
  //DECODE
  factory NoteModel.fromMap(Map<String,dynamic>map)
  {
    return NoteModel(id: map['id'] as String,
        title: map['title'] as String? ?? '',
        content: map['content'] as String? ?? '',
        datetime: DateTime.parse(map['datetime'] as String));
  }
  String toJson()=> json.encode(toMap());

  factory NoteModel.fromJson(String source) =>
    NoteModel.fromMap(json.decode(source) as Map<String, dynamic>);




}
