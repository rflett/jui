import 'package:flutter/material.dart';
import 'package:jui/models/dto/response/problem_response.dart';

class PopupUtils {
  /// Shows an error popup to the user containing the information that fits the specific error
  static void showError(BuildContext context, ProblemResponse problem, {String title = "Unexpected error!"}) {
    if (!problem.success) {
      // Error text is present
      _showError(context, problem, title);
    }
  }

  static void _showError(BuildContext context, ProblemResponse problem, String title) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Text(problem.error),
            ),
            actions: [
              TextButton(
                child: Text('Dismiss'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
