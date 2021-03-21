import 'package:flutter/material.dart';
import 'package:jui/models/dto/response/problem_response.dart';

class PopupUtils {
  /// Shows an error popup to the user containing the information that fits the specific error
  static void showError(BuildContext context, ProblemResponse problem) {
    if (problem.message.isNotEmpty) {
      // Error text is present
      _showError(context, problem);
    }
  }

  static void _showError(BuildContext context, ProblemResponse problem) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error!"),
            content: SingleChildScrollView(
              child: Text(problem.message),
            ),
            actions: [
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }
}
