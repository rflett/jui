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
      height: 40,
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
    var url = "$oauthUrl/$providerName/login";
    var shouldNavigate = await canLaunch(url);
    if (shouldNavigate) {
      await launch(url);
    }
  }

  String _getImageAsset() {
    switch (this._provider) {
      case SocialProviders.google:
        return "assets/images/social/google.png";
      case SocialProviders.spotify:
        return "assets/images/social/spotify.png";
      case SocialProviders.facebook:
        return "assets/images/social/facebook.png";
      case SocialProviders.instagram:
        return "assets/images/social/instagram.png";
      case SocialProviders.delegator:
        return "assets/images/social/delegator.png";
    }
  }
}
