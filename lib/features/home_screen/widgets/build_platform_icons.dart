import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum SocialMediaIcons {
  Comment(Icons.comment),
  Facebook(Icons.facebook),
  Twitter(FontAwesomeIcons.twitter),
  WhatsApp(FontAwesomeIcons.whatsapp),
  Instagram(FontAwesomeIcons.instagram),
  Snapchat(Icons.snapchat),
  Other(Icons.more_horiz),
  Voting(Icons.how_to_vote),
  Like(Icons.thumb_up);

  final IconData icon;
  const SocialMediaIcons(this.icon);

  static IconData getIconData(String platform) {
    switch (platform.toLowerCase()) {
      case 'comment':
        return SocialMediaIcons.Comment.icon;
      case 'facebook':
        return SocialMediaIcons.Facebook.icon;
      case 'twitter/x':
        return SocialMediaIcons.Twitter.icon;
      case 'whatsapp':
        return SocialMediaIcons.WhatsApp.icon;
      case 'instagram':
        return SocialMediaIcons.Instagram.icon;
      case 'snapchat':
        return SocialMediaIcons.Snapchat.icon;
      case 'voting':
        return SocialMediaIcons.Voting.icon;
      case 'like':
        return SocialMediaIcons.Like.icon;
      default:
        return SocialMediaIcons.Other.icon;
    }
  }
}
