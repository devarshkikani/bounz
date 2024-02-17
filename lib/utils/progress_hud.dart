import 'package:flutter/material.dart';

class OptionPage {
  /// Show Option
  Future<void> showOption(BuildContext context) async {
    showDialog<dynamic>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          _dialogContext = context;
          return const Loading();
        }
    );
  }

  /// BuildContext
  BuildContext? _dialogContext;

  void hideOption() {
    if (_dialogContext != null) {
      if (Navigator.canPop(_dialogContext!)) {
        Navigator.pop(_dialogContext!);
      }
      _dialogContext = null;
    }
  }
}

class Loading extends StatelessWidget {
  const Loading({super.key});
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.transparent,
      body: Padding(
        padding: EdgeInsets.only(top: 20.0),
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }
}
