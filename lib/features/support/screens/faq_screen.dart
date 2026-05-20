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
  final TextEditingController searchController = TextEditingController();

  bool isLoading = true;
  List<FaqModel> faqs = [];
  List<HelpArticleModel> articles = [];
  String query = '';

  List<FaqModel> get filteredFaqs {
    final value = query.trim().toLowerCase();
    if (value.isEmpty) return faqs;
    return faqs.where((faq) {
      return faq.question.toLowerCase().contains(value) ||
          faq.answer.toLowerCase().contains(value) ||
          faq.category.toLowerCase().contains(value);
    }).toList();
  }

  List<HelpArticleModel> get filteredArticles {
    final value = query.trim().toLowerCase();
    if (value.isEmpty) return articles;
    return articles.where((article) {
      return article.title.toLowerCase().contains(value) ||
          article.shortDescription.toLowerCase().contains(value) ||
          article.content.toLowerCase().contains(value) ||
          article.category.toLowerCase().contains(value);
    }).toList();
  }

  Future<void> fetchData() async {
    setState(() => isLoading = true);

    try {
      final result = await Future.wait([
        service.getFaqs(),
        service.getHelpArticles(),
      ]);

      if (!mounted) return;
      setState(() {
        faqs = result[0] as List<FaqModel>;
        articles = result[1] as List<HelpArticleModel>;
      });
    } catch (error) {
      if (!mounted) return;
      AppToast.show(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final shownFaqs = filteredFaqs;
    final shownArticles = filteredArticles;

    return Scaffold(
      appBar: AppBar(title: const Text('FAQs & Articles')),
      body: isLoading
          ? const _FaqSkeleton()
          : RefreshIndicator(
              onRefresh: fetchData,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: colors.primaryContainer.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(26),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Search help library',
                          style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: searchController,
                          onChanged: (value) => setState(() => query = value),
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration(
                            hintText: 'Search question, article, order, return...',
                            prefixIcon: const Icon(Icons.search_rounded),
                            suffixIcon: query.isEmpty
                                ? null
                                : IconButton(
                                    onPressed: () {
                                      searchController.clear();
                                      setState(() => query = '');
                                    },
                                    icon: const Icon(Icons.close_rounded),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  _SectionTitle(title: 'Common Questions', count: shownFaqs.length),
                  const SizedBox(height: 12),
                  if (shownFaqs.isEmpty)
                    const _EmptyResult(message: 'No matching FAQs found.')
                  else
                    ...shownFaqs.map((faq) => FaqTile(faq: faq)),
                  const SizedBox(height: 20),
                  _SectionTitle(title: 'Help Articles', count: shownArticles.length),
                  const SizedBox(height: 12),
                  if (shownArticles.isEmpty)
                    const _EmptyResult(message: 'No matching articles found.')
                  else
                    ...shownArticles.map((article) => HelpArticleCard(article: article)),
                ],
              ),
            ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  final int count;

  const _SectionTitle({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Row(
      children: [
        Expanded(
          child: Text(title, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: colors.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text('$count', style: TextStyle(color: colors.primary, fontWeight: FontWeight.w900)),
        ),
      ],
    );
  }
}

class _EmptyResult extends StatelessWidget {
  final String message;

  const _EmptyResult({required this.message});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Text(message, textAlign: TextAlign.center),
    );
  }
}

class _FaqSkeleton extends StatelessWidget {
  const _FaqSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: 7,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        return Container(
          height: index == 0 ? 128 : 82,
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(24),
          ),
        );
      },
    );
  }
}
