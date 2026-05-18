import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/help_article_model.dart';

class HelpArticleCard extends StatelessWidget {
  final HelpArticleModel article;

  const HelpArticleCard({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ExpansionTile(
        title: Text(
          article.title,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        subtitle: Text(article.shortDescription),
        childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              article.content,
              style: const TextStyle(
                color: AppColors.lightTextSecondary,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
