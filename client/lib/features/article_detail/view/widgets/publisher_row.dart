import 'package:flutter/material.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/core/theme/app_palette.dart';

class PublisherRow extends StatelessWidget {
  final String publisherName;
  final String authorName;

  const PublisherRow({super.key, required this.publisherName, required this.authorName});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Publisher logo
        ClipRRect(
          borderRadius: BorderRadius.circular(30),
          child: Image.asset(
'assets/images/snrtbotola.png',
            width: 48,
            height: 48,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              width: 48,
              height: 48,
              color: Palette.gray100,
              child: Icon(Icons.article, color: Palette.gray400, size: 24),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Name & Author
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
Text(
                publisherName,
                style: AppTypography.bodyBold16.copyWith(color: Palette.gray900),
              ),
              const SizedBox(height: 2),
Text(
authorName,
                style: AppTypography.bodyMedium14.copyWith(color: Palette.gray400),
              ),
            ],
          ),
        ),
        // Follow Button
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Palette.primary,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            minimumSize: const Size(0, 40),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
          onPressed: () {},
          child: Text(
'Save',
            style: AppTypography.bodyBold16.copyWith(color: Palette.white),
          ),
        ),
      ],
    );
  }
}
