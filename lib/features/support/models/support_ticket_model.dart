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

  SupportTicketModel({
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
      id: json['id'] ?? 0,
      ticketNumber: json['ticket_number'] ?? '',
      subject: json['subject'] ?? '',
      status: json['status'] ?? '',
      priority: json['priority'] ?? '',
      orderId: json['order_id'],
      lastMessage: json['last_message'] ?? json['message'] ?? '',
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}

class SupportSenderModel {
  final int id;
  final String name;
  final String? avatarUrl;

  SupportSenderModel({required this.id, required this.name, this.avatarUrl});

  factory SupportSenderModel.fromJson(Map<String, dynamic> json) {
    return SupportSenderModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      avatarUrl: json['avatar_url'],
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

  SupportMessageModel({
    required this.id,
    required this.senderType,
    required this.sender,
    required this.message,
    required this.attachments,
    this.createdAt,
  });

  factory SupportMessageModel.fromJson(Map<String, dynamic> json) {
    final attachmentsJson = json['attachments'];

    return SupportMessageModel(
      id: json['id'] ?? 0,
      senderType: json['sender_type'] ?? '',
      sender: SupportSenderModel.fromJson(
        json['sender'] ?? <String, dynamic>{},
      ),
      message: json['message'] ?? '',
      attachments: attachmentsJson is List
          ? attachmentsJson.map((item) => item.toString()).toList()
          : [],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
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

  SupportTicketDetailsModel({
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
    final messagesJson = json['messages'];

    return SupportTicketDetailsModel(
      id: json['id'] ?? 0,
      ticketNumber: json['ticket_number'] ?? '',
      subject: json['subject'] ?? '',
      status: json['status'] ?? '',
      priority: json['priority'] ?? '',
      orderId: json['order_id'],
      messages: messagesJson is List
          ? messagesJson
                .map(
                  (item) => SupportMessageModel.fromJson(
                    item as Map<String, dynamic>,
                  ),
                )
                .toList()
          : [],
      createdAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.tryParse(json['updated_at'])
          : null,
    );
  }
}
