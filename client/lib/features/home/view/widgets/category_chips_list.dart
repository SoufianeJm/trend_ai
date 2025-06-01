import 'package:flutter/material.dart';
import 'package:client/features/home/view/widgets/category_chip.dart';

class CategoryChipsList extends StatelessWidget {
  const CategoryChipsList({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      {'label': 'Botola', 'icon': 'assets/icons/botola.png'},
      {'label': 'Live', 'icon': 'assets/icons/live.png'},
      {'label': 'News', 'icon': 'assets/icons/news.png'},
      {'label': 'Forja', 'icon': 'assets/icons/forja.png'},
      {'label': 'Ossoud', 'icon': 'assets/icons/ossoud.png'},
      {'label': 'Others', 'icon': 'assets/icons/others.png'},
    ];

    return SizedBox(
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: categories
            .map((category) => CategoryChip(
                  label: category['label']!,
                  assetPath: category['icon']!,
                ))
            .toList(),
      ),
    );
  }
}
