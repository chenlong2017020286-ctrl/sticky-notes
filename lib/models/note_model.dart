import 'package:uuid/uuid.dart';

const _uuid = Uuid();

class NoteModel {
  final String id;
  String text;
  String color;
  DateTime createdAt;
  DateTime updatedAt;
  double opacity;

  NoteModel({
    String? id,
    this.text = '',
    this.color = '#FFF9C4',
    DateTime? createdAt,
    DateTime? updatedAt,
    this.opacity = 1.0,
  })  : id = id ?? _uuid.v4().substring(0, 8),
        createdAt = createdAt ?? DateTime.now(),
        updatedAt = updatedAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'id': id,
        'text': text,
        'color': color,
        'opacity': opacity,
        'createdAt': createdAt.toIso8601String(),
        'updatedAt': updatedAt.toIso8601String(),
      };

  factory NoteModel.fromJson(Map<String, dynamic> json) => NoteModel(
        id: json['id'] as String,
        text: json['text'] as String? ?? '',
        color: json['color'] as String? ?? '#FFF9C4',
        opacity: (json['opacity'] as num?)?.toDouble() ?? 1.0,
        createdAt: DateTime.tryParse(json['createdAt'] as String? ?? ''),
        updatedAt: DateTime.tryParse(json['updatedAt'] as String? ?? ''),
      );

  NoteModel copyWith({
    String? text,
    String? color,
    double? opacity,
  }) {
    final now = DateTime.now();
    return NoteModel(
      id: id,
      text: text ?? this.text,
      color: color ?? this.color,
      opacity: opacity ?? this.opacity,
      createdAt: createdAt,
      updatedAt: now,
    );
  }

  String get formattedTime {
    final diff = DateTime.now().difference(updatedAt);
    if (diff.inMinutes < 1) return '刚刚';
    if (diff.inHours < 1) return '${diff.inMinutes}分钟前';
    if (diff.inDays < 1) return '${diff.inHours}小时前';
    return '${updatedAt.month}/${updatedAt.day} ${updatedAt.hour.toString().padLeft(2, '0')}:${updatedAt.minute.toString().padLeft(2, '0')}';
  }
}

const List<Map<String, dynamic>> noteColors = [
  {'name': '暖黄', 'code': '#FFF9C4'},
  {'name': '淡蓝', 'code': '#BBDEFB'},
  {'name': '新绿', 'code': '#C8E6C9'},
  {'name': '柔粉', 'code': '#F8BBD0'},
  {'name': '淡紫', 'code': '#E1BEE7'},
  {'name': '杏橙', 'code': '#FFE0B2'},
  {'name': '青绿', 'code': '#B2EBF2'},
  {'name': '暖灰', 'code': '#D7CCC8'},
  {'name': '素白', 'code': '#F5F5F5'},
  {'name': '浅绯', 'code': '#FFCDD2'},
  {'name': '深蓝', 'code': '#90CAF9'},
  {'name': '薄荷', 'code': '#A5D6A7'},
];
