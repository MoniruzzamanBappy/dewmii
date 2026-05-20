class FaqModel {
  final int id;
  final String category;
  final String question;
  final String answer;
  final int sortOrder;

  const FaqModel({
    required this.id,
    required this.category,
    required this.question,
    required this.answer,
    required this.sortOrder,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: _toInt(json['id']),
      category: _toStringValue(json['category']),
      question: _toStringValue(json['question']),
      answer: _toStringValue(json['answer']),
      sortOrder: _toInt(json['sort_order'] ?? json['sortOrder']),
    );
  }
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

String _toStringValue(dynamic value) => value?.toString() ?? '';
