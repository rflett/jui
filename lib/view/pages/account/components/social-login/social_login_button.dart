import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:jui/constants/urls.dart';
import 'package:jui/models/enums/social_providers.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialLoginButton extends StatelessWidget {
  final SocialProviders _provider;

  SocialLoginButton(this._provider);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      child: Material(
        color: Colors.transparent,
        elevation: 2,
        child: InkWell(
          onTap: () => _onSocialTapped(),
          child: Image.asset(_getImageAsset()),
        ),
      ),
    );
  }

  _onSocialTapped() async {
    var providerName = this._provider.toString().split(".").last;
    var url = "$oauthLoginUrl/$providerName";
    var shouldNavigate = await canLaunch(url);
    if (shouldNavigate) {
      await launch(url);
    }
  }

  String _getImageAsset() {
    switch (this._provider) {
      case SocialProviders.google:
        return "images/social/google.png";
      case SocialProviders.spotify:
        return "images/social/spotify.png";
      case SocialProviders.facebook:
        return "images/social/facebook.png";
      case SocialProviders.instagram:
        return "images/social/instagram.png";
      case SocialProviders.delegator:
        return "images/social/delegator.png";
    }
  }
}
