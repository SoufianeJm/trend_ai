import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';

// This file is deprecated and can be deleted.
  const ActionRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.favorite_border, color: Palette.gray400),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.comment_outlined, color: Palette.gray400),
          onPressed: () {},
        ),
        IconButton(
          icon: Icon(Icons.share_outlined, color: Palette.gray400),
          onPressed: () {},
        ),
      ],
    );
  }
}
