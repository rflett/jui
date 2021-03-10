import 'package:flutter/material.dart';
import 'package:jui/models/enums/social_providers.dart';

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
          onTap: () => _onSocialTapped,
          child: Image.asset(_getImageAsset()),
        ),
      ),
    );
  }

  _onSocialTapped() {}

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
