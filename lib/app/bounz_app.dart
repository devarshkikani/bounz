import 'package:bounz_revamp_app/main.dart';
import 'package:flutter/material.dart';

class BounzApp extends StatefulWidget {
  const BounzApp({Key? key}) : super(key: key);

  @override
  _BounzAppState createState() => _BounzAppState();
}

class _BounzAppState extends State<BounzApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'SourceSansPro'),
      routerConfig: appRouter.config(),
      builder: (context, child) {
        final textScale = MediaQuery.of(context).textScaleFactor;
        return MediaQuery(
          child: child!,
          data: MediaQuery.of(context)
              .copyWith(textScaleFactor: textScale >= 1.1 ? 1.1 : textScale),
        );
      },
    );
  }
}
