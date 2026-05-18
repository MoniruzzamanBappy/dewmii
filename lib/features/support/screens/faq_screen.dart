import 'package:flutter/material.dart';

import '../../../shared/widgets/app_toast.dart';
import '../models/faq_model.dart';
import '../models/help_article_model.dart';
import '../services/support_api_service.dart';
import '../widgets/faq_tile.dart';
import '../widgets/help_article_card.dart';

class FAQScreen extends StatefulWidget {
  const FAQScreen({super.key});

  @override
  State<FAQScreen> createState() => _FAQScreenState();
}

class _FAQScreenState extends State<FAQScreen> {
  final SupportApiService service = SupportApiService();

  bool isLoading = true;
  List<FaqModel> faqs = [];
  List<HelpArticleModel> articles = [];

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
    });

    try {
      final faqResult = await service.getFaqs();
      final articleResult = await service.getHelpArticles();

      if (!mounted) return;

      setState(() {
        faqs = faqResult;
        articles = articleResult;
      });
    } catch (error) {
      if (!mounted) return;

      AppToast.show(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('FAQs & Articles')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchData,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  const Text(
                    'Common Questions',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  ...faqs.map((faq) => FaqTile(faq: faq)),
                  const SizedBox(height: 22),
                  const Text(
                    'Help Articles',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  ...articles.map(
                    (article) => HelpArticleCard(article: article),
                  ),
                ],
              ),
            ),
    );
  }
}
