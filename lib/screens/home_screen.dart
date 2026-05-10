import 'package:flutter/material.dart';
import '../models/note_model.dart';
import '../services/storage_service.dart';
import '../widgets/note_card.dart';
import '../widgets/note_editor.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _storage = StorageService.instance;
  List<NoteModel> _notes = [];
  bool _loaded = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_loaded) {
      _loaded = true;
      _refresh();
      if (_notes.isEmpty) {
        _createWelcomeNote();
      }
    }
  }

  Future<void> _createWelcomeNote() async {
    await _storage.create(
      text: '欢迎使用 StickyNotes！\n\n'
          '• 点击 ➕ 创建新便笺\n'
          '• 点击便笺编辑内容\n'
          '• 点击调色板更换颜色\n'
          '• 长按便笺拖动调整位置（未来版本）',
      color: '#BBDEFB',
    );
    _refresh();
  }

  Future<void> _refresh() async {
    setState(() => _notes = _storage.notes);
  }

  Future<void> _createNote() async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => const NoteEditor(),
    );
    if (result != null) {
      await _storage.create(
        text: result['text'] as String,
        color: result['color'] as String,
      );
      _refresh();
    }
  }

  Future<void> _editNote(NoteModel note) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (_) => NoteEditor(note: note),
    );
    if (result != null) {
      await _storage.update(
        note.id,
        text: result['text'] as String,
        color: result['color'] as String,
        opacity: result['opacity'] as double,
      );
      _refresh();
    }
  }

  Future<void> _deleteNote(NoteModel note) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除便笺'),
        content: const Text('确定要删除这条便笺吗？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('取消')),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _storage.delete(note.id);
      _refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.sticky_note_2, size: 24),
            const SizedBox(width: 8),
            const Text('StickyNotes'),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${_notes.length}',
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: '刷新',
            onPressed: _refresh,
          ),
        ],
      ),
      body: _notes.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.note_add, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('点击右下角 + 创建第一条便笺',
                      style: TextStyle(color: Colors.grey, fontSize: 15)),
                ],
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = (constraints.maxWidth / 280).floor().clamp(1, 6);
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio: 0.85,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: _notes.length,
                  itemBuilder: (_, i) => NoteCard(
                    note: _notes[i],
                    onTap: () => _editNote(_notes[i]),
                    onDelete: () => _deleteNote(_notes[i]),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _createNote,
        child: const Icon(Icons.add),
      ),
    );
  }
}
