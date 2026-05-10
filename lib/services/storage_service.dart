import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/note_model.dart';

class StorageService {
  static StorageService? _instance;
  late File _file;
  Map<String, NoteModel> _notes = {};

  StorageService._();

  static StorageService get instance {
    _instance ??= StorageService._();
    return _instance!;
  }

  Future<void> init() async {
    final dir = await getApplicationDocumentsDirectory();
    _file = File('${dir.path}/sticky_notes.json');
    await load();
  }

  Future<void> load() async {
    if (!await _file.exists()) {
      _notes = {};
      return;
    }
    try {
      final content = await _file.readAsString();
      final data = json.decode(content) as Map<String, dynamic>;
      _notes = data.map((k, v) => MapEntry(k, NoteModel.fromJson(v as Map<String, dynamic>)));
    } catch (_) {
      _notes = {};
    }
  }

  Future<void> save() async {
    final data = _notes.map((k, v) => MapEntry(k, v.toJson()));
    await _file.writeAsString(json.encode(data));
  }

  List<NoteModel> get notes => _notes.values.toList()
    ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));

  NoteModel? get(String id) => _notes[id];

  Future<NoteModel> create({String text = '', String color = '#FFF9C4'}) async {
    final note = NoteModel(text: text, color: color);
    _notes[note.id] = note;
    await save();
    return note;
  }

  Future<NoteModel> update(String id, {String? text, String? color, double? opacity}) async {
    final note = _notes[id];
    if (note == null) throw Exception('Note not found: $id');
    _notes[id] = note.copyWith(text: text, color: color, opacity: opacity);
    await save();
    return _notes[id]!;
  }

  Future<void> delete(String id) async {
    _notes.remove(id);
    await save();
  }

  int get count => _notes.length;
}
