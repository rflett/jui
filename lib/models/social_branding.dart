import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:tuple/tuple.dart';
import 'enums/social_providers.dart';

class SocialBranding {
  final String name;
  final FaIcon icon;
  final Color color;

  SocialBranding(this.name, this.icon, this.color);

  factory SocialBranding.fromProvider(SocialProviders provider) {
    var branding = _getSocialBranding(provider);
    return SocialBranding(branding.item3, branding.item1, branding.item2);
  }

  static Tuple3<FaIcon, Color, String> _getSocialBranding(
      SocialProviders provider) {
    switch (provider) {
      case SocialProviders.google:
        return Tuple3(
            FaIcon(FontAwesomeIcons.google, color: Colors.white, size: 22),
            Colors.red,
            "Google");
      case SocialProviders.spotify:
        return Tuple3(
            FaIcon(FontAwesomeIcons.spotify, color: Colors.white, size: 22),
            Colors.green,
            "Spotify");
      case SocialProviders.facebook:
        return Tuple3(
            FaIcon(FontAwesomeIcons.facebook, color: Colors.white, size: 22),
            Colors.blue.shade900,
            "Facebook");
      case SocialProviders.instagram:
        return Tuple3(
            FaIcon(FontAwesomeIcons.instagram, color: Colors.white, size: 22),
            Color(0xffD8357C),
            "Instagram");
      case SocialProviders.delegator:
        return Tuple3(
            FaIcon(FontAwesomeIcons.instagram, color: Colors.white, size: 22),
            Colors.red,
            "Delegator");
    }
  }
}
