import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:ysr_project/features/home_screen/providers/home_feed_repo_provider.dart';

class ShareCard {
  final String title;
  final String link;

  const ShareCard({
    required this.title,
    required this.link,
  });

  Future<void> launchURL(BuildContext context) async {
    try {
      final uri = Uri.parse(link);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not open the video')),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Invalid video URL')),
        );
      }
    }
  }

  Future<void> shareOnSocialMedia(BuildContext context, String platform) async {
    try {
      final encodedLink = Uri.encodeComponent(link);
      final shareText = 'Check out this video: $title\n$link';
      final encodedText = Uri.encodeComponent(shareText);

      String? url;
      Uri? uri;

      switch (platform.toLowerCase()) {
        case 'whatsapp':
          // Try app URL scheme first
          uri = Uri.parse('whatsapp://send?text=$encodedText');
          if (await canLaunchUrl(uri)) {
            await launchUrl(uri);
            return;
          }
          // Fallback to web
          url = 'https://wa.me/?text=$encodedText';
          break;
        case 'facebook':
          url =
              'https://www.facebook.com/sharer/sharer.php?u=$encodedLink&quote=$encodedText';
          break;
        case 'twitter':
          url = 'https://twitter.com/intent/tweet?text=$encodedText';
          break;
        default:
          await Share.share(shareText);
          return;
      }

      if (url != null) {
        uri = Uri.parse(url);
        if (await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
        } else {
          // Fallback to generic share if can't launch URL
          await Share.share(shareText);
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Could not share to ${platform.toUpperCase()}')),
        );
      }
      // Fallback to generic share
      await Share.share('Check out this video: $title\n$link');
    }
  }
}
