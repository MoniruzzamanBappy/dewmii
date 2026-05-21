import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/faq_model.dart';
import '../models/help_article_model.dart';
import '../models/support_ticket_model.dart';

class SupportApiService {
  final ApiClient _apiClient;

  SupportApiService({ApiClient? apiClient}) : _apiClient = apiClient ?? ApiClient();

  Future<List<FaqModel>> getFaqs() async {
    final response = await _apiClient.get(ApiConstants.faqs);
    final data = response['data'];
    final items = data is List ? data : data is Map<String, dynamic> ? data['items'] : null;

    if (items is! List) return [];

    return items
        .whereType<Map>()
        .map((item) => FaqModel.fromJson(Map<String, dynamic>.from(item)))
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  }

  Future<List<HelpArticleModel>> getHelpArticles() async {
    final response = await _apiClient.get(ApiConstants.helpArticles);
    final data = response['data'];
    final items = data is List ? data : data is Map<String, dynamic> ? data['items'] : null;

    if (items is! List) return [];

    return items
        .whereType<Map>()
        .map((item) => HelpArticleModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<Map<String, dynamic>> submitContact({
    required String name,
    required String email,
    required String phone,
    required String subject,
    required String message,
  }) async {
    final payload = {
      'name': name,
      'email': email,
      'phone': phone,
      'subject': subject,
      'message': message,
    };

    try {
      return await _apiClient.post(ApiConstants.contact, body: payload);
    } catch (_) {
      return _apiClient.get(ApiConstants.contact);
    }
  }

  Future<Map<String, dynamic>> submitContactDemo({
    required String name,
    required String email,
    required String phone,
    required String subject,
    required String message,
  }) {
    return submitContact(
      name: name,
      email: email,
      phone: phone,
      subject: subject,
      message: message,
    );
  }

  Future<List<SupportTicketModel>> getTickets() async {
    final response = await _apiClient.get(ApiConstants.supportTickets);
    final data = response['data'];
    final items = data is List ? data : data is Map<String, dynamic> ? data['items'] : null;

    if (items is! List) return [];

    return items
        .whereType<Map>()
        .map((item) => SupportTicketModel.fromJson(Map<String, dynamic>.from(item)))
        .toList();
  }

  Future<Map<String, dynamic>> createTicket({
    required String subject,
    required String message,
    required String priority,
    int? orderId,
  }) async {
    final payload = {
      'subject': subject,
      'message': message,
      'priority': priority,
      'order_id': ?orderId,
    };

    try {
      return await _apiClient.post(ApiConstants.supportTicketCreate, body: payload);
    } catch (_) {
      return _apiClient.get(ApiConstants.supportTicketCreate);
    }
  }

  Future<Map<String, dynamic>> createTicketDemo({
    required String subject,
    required String message,
    required String priority,
    int? orderId,
  }) {
    return createTicket(
      subject: subject,
      message: message,
      priority: priority,
      orderId: orderId,
    );
  }

  Future<SupportTicketDetailsModel?> getTicketDetails(int ticketId) async {
    final response = await _apiClient.get(ApiConstants.supportTicketDetails(ticketId));
    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;
    return SupportTicketDetailsModel.fromJson(data);
  }

  Future<Map<String, dynamic>> replyTicket({
    required int ticketId,
    required String message,
  }) async {
    final payload = {'ticket_id': ticketId, 'message': message};

    try {
      return await _apiClient.post(ApiConstants.supportTicketReply, body: payload);
    } catch (_) {
      return _apiClient.get(ApiConstants.supportTicketReply);
    }
  }

  Future<Map<String, dynamic>> replyTicketDemo({
    required int ticketId,
    required String message,
  }) {
    return replyTicket(ticketId: ticketId, message: message);
  }

  SupportTicketModel? parseCreatedTicket(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is! Map<String, dynamic>) return null;
    return SupportTicketModel.fromJson(data);
  }

  SupportMessageModel? parseReply(Map<String, dynamic> response) {
    final data = response['data'];
    if (data is! Map<String, dynamic>) return null;
    return SupportMessageModel.fromJson(data);
  }
}
