import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:moordak/logic/blocs/dashboard_bloc/dashboard_bloc.dart';
import 'package:moordak/logic/blocs/loan_bloc/loan_bloc.dart';
import 'package:moordak/logic/blocs/transaction_bloc/transaction_bloc.dart';
import 'package:moordak/logic/blocs/user_bloc/user_bloc.dart';
import 'package:moordak/presentation/components/menu_widget.dart';
import 'package:moordak/presentation/consts/colors.dart';
import 'package:moordak/presentation/screens/about_us/about_us.dart';
import 'package:moordak/presentation/screens/about_us/contact_us.dart';
import 'package:moordak/presentation/screens/home_screen.dart';
import 'package:moordak/presentation/screens/loan_screen/loan_screen.dart';
import 'package:moordak/presentation/screens/transactions_screens/transaction_screen.dart';
import 'package:moordak/presentation/screens/user_screens/user_screen.dart';

class DrawerScreen extends StatefulWidget {
  @override
  DrawerScreenState createState() => DrawerScreenState();
}

class DrawerScreenState extends State<DrawerScreen> {
  static GlobalKey<SliderMenuContainerState> drawerKey =
      new GlobalKey<SliderMenuContainerState>();
  String title;
  String currentPage = 'home';
  Map<String, Widget> navChildren = <String, Widget>{
    'home': BlocProvider<DashboardBloc>(
      create: (BuildContext context) => DashboardBloc(),
      child: HomeScreen(),
    ),
    'users': BlocProvider<UserBloc>(
      create: (BuildContext context) => UserBloc(),
      child: UserScreen(),
    ),
    'transactions': BlocProvider<TransactionBloc>(
      create: (BuildContext context) => TransactionBloc(),
      child: TransactionsScreen(),
    ),
    'loans': BlocProvider<LoanBloc>(
      create: (BuildContext context) => LoanBloc(),
      child: LoanScreen(),
    ),
    'contact_us': new ContactUsScreen(),
    'about_us': new AboutUsScreen(),
  };

  @override
  void initState() {
    title = "صفحه اصلی";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SliderMenuContainer(
          drawerIconColor: Colors.white,
          appBarColor: maincolor,
          hasAppBar: false,
          slideDirection: SlideDirection.RIGHT_TO_LEFT,
          key: drawerKey,
          sliderMenuOpenSize: 200,
          title: Text(
            title,
            style: TextStyle(
                fontSize: 18, fontWeight: FontWeight.w700, color: Colors.white),
          ),
          sliderMenu: Directionality(
            textDirection: TextDirection.rtl,
            child: MenuWidget(
              onItemClick: (key) {
                drawerKey.currentState.closeDrawer();

                setState(() {
                  if (key == 'users') {
                    chanePage('users');
                    this.title = 'کاربران';
                  } else if (key == 'transactions') {
                    chanePage('transactions');
                    this.title = 'تراکنش ها';
                  } else if (key == 'about_us') {
                    chanePage('about_us');
                    this.title = 'درباره ما';
                  } else if (key == 'contact_us') {
                    chanePage('contact_us');
                    this.title = 'تماس با ما';
                  } else if (key == 'home') {
                    chanePage('home');
                    this.title = 'صفحه اصلی';
                  } else if (key == 'loans') {
                    chanePage('loans');
                  }
                });
              },
            ),
          ),
          sliderMain: Directionality(
            textDirection: TextDirection.rtl,
            child: navChildren[currentPage],
          )),
    );
  }

  chanePage(String activePage) {
    setState(() {
      currentPage = activePage;
    });
  }
}
