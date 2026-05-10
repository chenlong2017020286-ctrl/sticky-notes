import 'package:flutter/material.dart';
import '../models/note_model.dart';

class NoteEditor extends StatefulWidget {
  final NoteModel? note;

  const NoteEditor({super.key, this.note});

  @override
  State<NoteEditor> createState() => _NoteEditorState();
}

class _NoteEditorState extends State<NoteEditor> {
  late TextEditingController _controller;
  late Color _color;
  late double _opacity;
  bool _isNew = false;

  @override
  void initState() {
    super.initState();
    _isNew = widget.note == null;
    _controller = TextEditingController(text: widget.note?.text ?? '');
    _color = _hexToColor(widget.note?.color ?? '#FFF9C4');
    _opacity = widget.note?.opacity ?? 1.0;
  }

  Color _hexToColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  String _colorToHex(Color c) {
    final r = (c.r * 255).round();
    final g = (c.g * 255).round();
    final b = (c.b * 255).round();
    return '#${r.toRadixString(16).padLeft(2, '0')}${g.toRadixString(16).padLeft(2, '0')}${b.toRadixString(16).padLeft(2, '0')}'.toUpperCase();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: _color,
      insetPadding: const EdgeInsets.all(24),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 480, maxHeight: 560),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: _darken(_color, 0.88))),
              ),
              child: Row(
                children: [
                  Text(
                    _isNew ? '新建便笺' : '编辑便笺',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: _darken(_color, 0.2),
                    ),
                  ),
                  const Spacer(),
                  // Color picker
                  _ToolBtn(Icons.palette_outlined, () => _showColorPicker()),
                  const SizedBox(width: 4),
                  // Opacity
                  _ToolBtn(Icons.opacity, () => _showOpacitySlider()),
                  const SizedBox(width: 4),
                  // Close
                  _ToolBtn(Icons.close, () => Navigator.pop(context)),
                ],
              ),
            ),
            // Editor
            Flexible(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  controller: _controller,
                  autofocus: !_isNew,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '在这里输入内容...',
                    hintStyle: TextStyle(color: Colors.black26),
                  ),
                  style: TextStyle(
                    fontSize: 15,
                    height: 1.6,
                    color: _darken(_color, 0.15),
                  ),
                ),
              ),
            ),
            // Bottom bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: _darken(_color, 0.88))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('取消',
                        style: TextStyle(color: _darken(_color, 0.4))),
                  ),
                  const SizedBox(width: 8),
                  FilledButton(
                    onPressed: () {
                      Navigator.pop(context, {
                        'text': _controller.text,
                        'color': _colorToHex(_color),
                        'opacity': _opacity,
                      });
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: _darken(_color, 0.7),
                      foregroundColor: _darken(_color, 0.1),
                    ),
                    child: Text(_isNew ? '创建' : '保存'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _darken(Color c, double factor) {
    return Color.fromARGB(
      (c.a * 255).round(),
      (c.r * 255 * factor).round().clamp(0, 255),
      (c.g * 255 * factor).round().clamp(0, 255),
      (c.b * 255 * factor).round().clamp(0, 255),
    );
  }

  void _showColorPicker() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('选择颜色'),
        content: Wrap(
          spacing: 10,
          runSpacing: 10,
          children: noteColors.map((c) {
            final hex = c['code'] as String;
            final color = _hexToColor(hex);
            final selected = _colorToHex(color) == _colorToHex(_color);
            return GestureDetector(
              onTap: () {
                setState(() => _color = color);
                Navigator.pop(ctx);
              },
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selected ? Colors.black54 : Colors.black12,
                    width: selected ? 3 : 1,
                  ),
                  boxShadow: selected
                      ? [BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 8)]
                      : null,
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showOpacitySlider() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('透明度'),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Slider(
                value: _opacity,
                min: 0.3,
                max: 1.0,
                divisions: 14,
                label: '${(_opacity * 100).round()}%',
                onChanged: (v) => setState(() => _opacity = v),
              ),
              Text('${(_opacity * 100).round()}%',
                  style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}

class _ToolBtn extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _ToolBtn(this.icon, this.onTap);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(6),
          child: Icon(icon, size: 20, color: Colors.black54),
        ),
      ),
    );
  }
}
