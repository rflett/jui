import 'package:flutter/material.dart';
import 'package:friendsbet/models/response/problem_response.dart';

class PopupUtils {
  /// Shows an error popup to the user containing the information that fits the specific error
  static void showError(BuildContext context, ProblemResponse problem) {
    if (problem.errors != null && problem.errors.isNotEmpty) {
      // Validation errors are present
      _showValidationErrors(context, problem);
    } else {
      // Another form of error, just show the text
      _showOtherError(context, problem);
    }
  }

  static void _showValidationErrors(
      BuildContext context, ProblemResponse problem) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Validation Errors!"),
            content: SingleChildScrollView(
              child: ListBody(
                children: _formatErrorsIntoList(problem),
              ),
            ),
            actions: [
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  static void _showOtherError(BuildContext context, ProblemResponse problem) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Error!"),
            content: SingleChildScrollView(
              child: Text(problem.detail),
            ),
            actions: [
              FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  static List<Column> _formatErrorsIntoList(ProblemResponse problems) {
    List<Column> errorList = [];
    problems.errors.forEach((field, errorStrings) {
      var parentColumn = Column(
        children: [Text(field, style: TextStyle(fontWeight: FontWeight.bold))],
      );

      // Add the child errors
      parentColumn.children
          .addAll(errorStrings.map((error) => Text("- $error")));

      errorList.add(parentColumn);
    });
    return errorList;
  }
}
