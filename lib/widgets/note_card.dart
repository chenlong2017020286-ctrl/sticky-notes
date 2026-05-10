import 'package:flutter/material.dart';
import '../models/note_model.dart';

class NoteCard extends StatelessWidget {
  final NoteModel note;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  Color _parseColor(String hex) {
    hex = hex.replaceFirst('#', '');
    if (hex.length == 6) hex = 'FF$hex';
    return Color(int.parse(hex, radix: 16));
  }

  Color _darken(Color c, double factor) {
    return Color.fromARGB(
      (c.a * 255).round(),
      (c.r * 255 * factor).round().clamp(0, 255),
      (c.g * 255 * factor).round().clamp(0, 255),
      (c.b * 255 * factor).round().clamp(0, 255),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bg = _parseColor(note.color);
    final textColor = _darken(bg, 0.2);
    final timeColor = _darken(bg, 0.45);

    return Opacity(
      opacity: note.opacity,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  border: Border(bottom: BorderSide(color: _darken(bg, 0.88))),
                ),
                child: Row(
                  children: [
                    Text(note.formattedTime,
                        style: TextStyle(fontSize: 11, color: timeColor)),
                    const Spacer(),
                    _IconBtn(Icons.delete_outline, timeColor, onDelete, _darken(bg, 0.9)),
                  ],
                ),
              ),
              // Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Text(
                    note.text.isEmpty ? '空便笺' : note.text,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 14,
                      height: 1.6,
                    ),
                    maxLines: 8,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _IconBtn extends StatelessWidget {
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final Color? hoverColor;

  const _IconBtn(this.icon, this.color, this.onTap, this.hoverColor);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(6),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 18, color: color),
        ),
      ),
    );
  }
}
