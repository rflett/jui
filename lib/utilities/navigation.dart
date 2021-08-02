import 'package:flutter/cupertino.dart';
import 'package:jui/constants/app_routes.dart';

class Navigate {
  final BuildContext _context;

  Navigate(this._context);

  // Navigates to a page and places it at the root of the navigation stack
  void _rootNavigateTo(String url) {
    Navigator.pushNamedAndRemoveUntil(_context, url, (route) => false);
  }

  void toFirstTimeSetupGroupPage() {
    _rootNavigateTo(firstTimeSetupGroupRoute);
  }

  void toFirstTimeSetupInvitePage() {
    _rootNavigateTo(firstTimeSetupInviteRoute);
  }

  void toGamePage() {
    _rootNavigateTo(gameRoute);
  }

  void toLoginPage() {
    _rootNavigateTo(loginRoute);
  }
}
