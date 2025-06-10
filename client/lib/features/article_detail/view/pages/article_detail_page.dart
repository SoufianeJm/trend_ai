import 'package:flutter/material.dart';
import 'package:client/features/article_detail/view/widgets/article_image.dart';
import 'package:client/features/article_detail/view/widgets/publisher_row.dart';
import 'package:client/features/article_detail/view/widgets/article_title.dart';
import 'package:client/features/article_detail/view/widgets/meta_row.dart';
import 'package:client/features/article_detail/view/widgets/article_content.dart';
import 'package:client/features/article_detail/view/widgets/comment_input.dart';
import 'package:client/core/theme/app_palette.dart';

class ArticleDetailPage extends StatelessWidget {
  const ArticleDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    const String title = "Bitcoin Bull Run ‘May Not Happen Until 2025";
    const String content = '''Bitcoin is a crypto asset that is a reference for various altcoins that have currently been launched, so its price movements are an important benchmark that has a major impact on other crypto assets.

Start Crypto Asset Investment at Crypto Magic!
In 2024, there are many events that are enough to affect the crypto market, starting from the Bitcoin network will experience a reduction in rewards (Halving), the Bitcoin ETF that has been approved, and the Dencun upgrade that will be launched in the near future.

Bitcoin as a Trendsetter
Bitcoin (BTC) has changed the entire financial system as we know it by being an alternative to centralized, government-controlled economies, the blockchain technology used in cryptocurrencies eliminates the need for centralized intermediaries and puts control back in the hands of users.

Its decentralized nature not only challenged conventional notions of financial autonomy, but also spawned a wide array of other alternative cryptocurrencies (altcoins), spreading its influence massively.

Therefore, Bitcoin serves as the ultimate benchmark of crypto market trends and conditions. Its price movements can set the tone for other assets in the crypto space, influencing investor confidence in both Bitcoin and altcoins.''';

    return Scaffold(
      backgroundColor: Palette.white,
      body: Stack(
        children: [
          // Scrollable main content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80), // to account for bottom input
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image + overlay bar
                Stack(
                  children: [
                    const ArticleImage(),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _circleIconButton(
                                icon: Icons.arrow_back,
                                onTap: () => Navigator.of(context).pop(),
                              ),
                              _circleIconButton(
                                icon: Icons.more_horiz,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Article body
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PublisherRow(),
                      const SizedBox(height: 24),
                      ArticleTitle(title: title),
                      const SizedBox(height: 20),
                      const MetaRow(),
                      const SizedBox(height: 20),
                      ArticleContent(content: content),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: SafeArea(
        child: Container(
          color: Palette.background,
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
          child: const CommentInput(),
        ),
      ),
    );
  }

  Widget _circleIconButton({required IconData icon, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.28),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onTap,
      ),
    );
  }
}
