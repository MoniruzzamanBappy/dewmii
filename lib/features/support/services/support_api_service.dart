import '../../../core/constants/api_constants.dart';
import '../../../core/network/api_client.dart';
import '../models/faq_model.dart';
import '../models/help_article_model.dart';
import '../models/support_ticket_model.dart';

class SupportApiService {
  final ApiClient _apiClient;

  SupportApiService({ApiClient? apiClient})
    : _apiClient = apiClient ?? ApiClient();

  Future<List<FaqModel>> getFaqs() async {
    final response = await _apiClient.get(ApiConstants.faqs);
    final data = response['data'];

    if (data is! List) return [];

    return data
        .map((item) => FaqModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<List<HelpArticleModel>> getHelpArticles() async {
    final response = await _apiClient.get(ApiConstants.helpArticles);
    final data = response['data'];

    if (data is! Map<String, dynamic>) return [];

    final items = data['items'];

    if (items is! List) return [];

    return items
        .map((item) => HelpArticleModel.fromJson(item as Map<String, dynamic>))
        .toList();
  }

  Future<Map<String, dynamic>> submitContactDemo({
    required String name,
    required String email,
    required String phone,
    required String subject,
    required String message,
  }) async {
    return _apiClient.get(ApiConstants.contact);
  }

  Future<List<SupportTicketModel>> getTickets() async {
    final response = await _apiClient.get(ApiConstants.supportTickets);
    final data = response['data'];

    if (data is! Map<String, dynamic>) return [];

    final items = data['items'];

    if (items is! List) return [];

    return items
        .map(
          (item) => SupportTicketModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();
  }

  Future<Map<String, dynamic>> createTicketDemo({
    required String subject,
    required String message,
    required String priority,
    int? orderId,
  }) async {
    return _apiClient.get(ApiConstants.supportTicketCreate);
  }

  Future<SupportTicketDetailsModel?> getTicketDetails(int ticketId) async {
    final response = await _apiClient.get(
      ApiConstants.supportTicketDetails(ticketId),
    );

    final data = response['data'];

    if (data is! Map<String, dynamic>) return null;

    return SupportTicketDetailsModel.fromJson(data);
  }

  Future<Map<String, dynamic>> replyTicketDemo({
    required int ticketId,
    required String message,
  }) async {
    return _apiClient.get(ApiConstants.supportTicketReply);
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
