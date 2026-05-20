class SupportTicketModel {
  final int id;
  final String ticketNumber;
  final String subject;
  final String status;
  final String priority;
  final int? orderId;
  final String lastMessage;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SupportTicketModel({
    required this.id,
    required this.ticketNumber,
    required this.subject,
    required this.status,
    required this.priority,
    this.orderId,
    required this.lastMessage,
    this.createdAt,
    this.updatedAt,
  });

  factory SupportTicketModel.fromJson(Map<String, dynamic> json) {
    return SupportTicketModel(
      id: _toInt(json['id']),
      ticketNumber: _toStringValue(json['ticket_number'] ?? json['ticketNumber'] ?? json['number']),
      subject: _toStringValue(json['subject'] ?? json['title']),
      status: _toStringValue(json['status']).isEmpty ? 'open' : _toStringValue(json['status']),
      priority: _toStringValue(json['priority']).isEmpty ? 'medium' : _toStringValue(json['priority']),
      orderId: _toNullableInt(json['order_id'] ?? json['orderId']),
      lastMessage: _toStringValue(json['last_message'] ?? json['lastMessage'] ?? json['message']),
      createdAt: _toDate(json['created_at'] ?? json['createdAt']),
      updatedAt: _toDate(json['updated_at'] ?? json['updatedAt']),
    );
  }
}

class SupportSenderModel {
  final int id;
  final String name;
  final String? avatarUrl;

  const SupportSenderModel({required this.id, required this.name, this.avatarUrl});

  factory SupportSenderModel.fromJson(Map<String, dynamic> json) {
    return SupportSenderModel(
      id: _toInt(json['id']),
      name: _toStringValue(json['name']).isEmpty ? 'Support' : _toStringValue(json['name']),
      avatarUrl: _toNullableString(json['avatar_url'] ?? json['avatarUrl']),
    );
  }
}

class SupportMessageModel {
  final int id;
  final String senderType;
  final SupportSenderModel sender;
  final String message;
  final List<String> attachments;
  final DateTime? createdAt;

  const SupportMessageModel({
    required this.id,
    required this.senderType,
    required this.sender,
    required this.message,
    required this.attachments,
    this.createdAt,
  });

  factory SupportMessageModel.fromJson(Map<String, dynamic> json) {
    final senderJson = json['sender'];
    final attachmentsJson = json['attachments'];

    return SupportMessageModel(
      id: _toInt(json['id']),
      senderType: _toStringValue(json['sender_type'] ?? json['senderType']).isEmpty
          ? 'agent'
          : _toStringValue(json['sender_type'] ?? json['senderType']),
      sender: SupportSenderModel.fromJson(
        senderJson is Map<String, dynamic> ? senderJson : <String, dynamic>{},
      ),
      message: _toStringValue(json['message'] ?? json['body']),
      attachments: attachmentsJson is List
          ? attachmentsJson.map((item) => item.toString()).where((item) => item.isNotEmpty).toList()
          : const [],
      createdAt: _toDate(json['created_at'] ?? json['createdAt']),
    );
  }
}

class SupportTicketDetailsModel {
  final int id;
  final String ticketNumber;
  final String subject;
  final String status;
  final String priority;
  final int? orderId;
  final List<SupportMessageModel> messages;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SupportTicketDetailsModel({
    required this.id,
    required this.ticketNumber,
    required this.subject,
    required this.status,
    required this.priority,
    this.orderId,
    required this.messages,
    this.createdAt,
    this.updatedAt,
  });

  factory SupportTicketDetailsModel.fromJson(Map<String, dynamic> json) {
    final messagesJson = json['messages'] ?? json['replies'];

    return SupportTicketDetailsModel(
      id: _toInt(json['id']),
      ticketNumber: _toStringValue(json['ticket_number'] ?? json['ticketNumber'] ?? json['number']),
      subject: _toStringValue(json['subject'] ?? json['title']),
      status: _toStringValue(json['status']).isEmpty ? 'open' : _toStringValue(json['status']),
      priority: _toStringValue(json['priority']).isEmpty ? 'medium' : _toStringValue(json['priority']),
      orderId: _toNullableInt(json['order_id'] ?? json['orderId']),
      messages: messagesJson is List
          ? messagesJson
              .whereType<Map>()
              .map((item) => SupportMessageModel.fromJson(Map<String, dynamic>.from(item)))
              .toList()
          : const [],
      createdAt: _toDate(json['created_at'] ?? json['createdAt']),
      updatedAt: _toDate(json['updated_at'] ?? json['updatedAt']),
    );
  }
}

int _toInt(dynamic value) {
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value) ?? 0;
  return 0;
}

int? _toNullableInt(dynamic value) {
  if (value == null) return null;
  if (value is int) return value;
  if (value is num) return value.toInt();
  if (value is String) return int.tryParse(value);
  return null;
}

String _toStringValue(dynamic value) => value?.toString() ?? '';

String? _toNullableString(dynamic value) {
  final text = value?.toString();
  return text == null || text.trim().isEmpty ? null : text;
}

DateTime? _toDate(dynamic value) {
  if (value is DateTime) return value;
  if (value is String && value.trim().isNotEmpty) return DateTime.tryParse(value);
  return null;
}
