import 'package:flutter/material.dart';
import 'package:jui/constants/urls.dart';
import 'package:jui/models/enums/social_providers.dart';
import 'package:jui/models/social_branding.dart';
import 'package:url_launcher/url_launcher.dart';

class SocialLoginButton extends StatelessWidget {
  final SocialProviders _provider;

  SocialLoginButton(this._provider);

  @override
  Widget build(BuildContext context) {
    var branding = SocialBranding.fromProvider(_provider);

    return Container(
      height: 40,
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(branding.color),
          elevation: MaterialStateProperty.all(2),
        ),
        onPressed: () => _onSocialTapped(_provider),
        child: Row(
          children: [
            branding.icon,
            SizedBox(width: 10),
            Text(
              "Login with ${branding.name}",
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
          ],
        ),
      ),
    );
  }

  _onSocialTapped(SocialProviders provider) async {
    var providerName = provider.toString().split(".").last;
    var url = "$oauthUrl/$providerName/login";
    var shouldNavigate = await canLaunch(url);
    if (shouldNavigate) {
      await launch(url);
    }
  }
}
