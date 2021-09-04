import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:moordak/presentation/components/menu_widget.dart';
import 'package:moordak/presentation/consts/colors.dart';
import 'package:moordak/presentation/router/app_router.dart';
import 'package:moordak/presentation/screens/home_screen.dart';
import 'package:moordak/presentation/screens/login_register/login_screen.dart';

void main() {
  runApp(MyApp(
    appRouter: AppRouter(),
  ));
}

class MyApp extends StatefulWidget {
  final appRouter;

  const MyApp({Key key, this.appRouter}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState(appRouter);
}

class _MyAppState extends State<MyApp> {
  final AppRouter appRouter;

  _MyAppState(@required this.appRouter);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: appRouter.onGenerateRoute,
      theme: ThemeData(
        primaryColor: maincolor,
        fontFamily: 'IRANSans',
      ),
    );
  }
}
