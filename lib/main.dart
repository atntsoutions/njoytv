import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:njoytv/theme.dart';

import 'utils/singleton.dart';
import 'router.dart';

// main app

void main() {
  runApp(
    ChangeNotifierProvider<ThemeSelector>(
      create: (context) => ThemeSelector(),
      child: MyApp(
        router: AppRouter(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  final AppRouter router;
  MyApp({Key? key, required this.router}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Singleton.isLoggedIn = true;
    return MaterialApp(
      title: Singleton.App_Caption,
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      onGenerateRoute: router.generateRoute,
      theme: Provider.of<ThemeSelector>(context, listen: true).getTheme(),
    );
  }
}
