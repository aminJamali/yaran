import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moordak/logic/blocs/installment_bloc/installment_bloc.dart';
import 'package:moordak/logic/blocs/loan_bloc/loan_bloc.dart';
import 'package:moordak/logic/blocs/transaction_bloc/transaction_bloc.dart';
import 'package:moordak/logic/blocs/user_bloc/user_bloc.dart';
import 'package:moordak/presentation/screens/about_us/about_us.dart';
import 'package:moordak/presentation/screens/about_us/contact_us.dart';
import 'package:moordak/presentation/screens/drawer.dart';
import 'package:moordak/presentation/screens/home_screen.dart';
import 'package:moordak/presentation/screens/loan_screen/add_loan_screen.dart';
import 'package:moordak/presentation/screens/loan_screen/loan_screen.dart';
import 'package:moordak/presentation/screens/login_register/login_screen.dart';
import 'package:moordak/presentation/screens/login_register/splash_screen.dart';
import 'package:moordak/presentation/screens/transactions_screens/add_transaction.dart';
import 'package:moordak/presentation/screens/transactions_screens/details_transaction.dart';
import 'package:moordak/presentation/screens/transactions_screens/edit_transaction.dart';
import 'package:moordak/presentation/screens/transactions_screens/transaction_screen.dart';
import 'package:moordak/presentation/screens/user_screens/details_user.dart';
import 'package:moordak/presentation/screens/user_screens/edit_user.dart';
import 'package:moordak/presentation/screens/user_screens/register_screen.dart';
import 'package:moordak/presentation/screens/user_screens/user_screen.dart';

class AppRouter {
  Route onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/home_page':
        return MaterialPageRoute(
          builder: (_) => new Directionality(
              textDirection: TextDirection.rtl, child: HomeScreen()),
        );
      case '/':
        return MaterialPageRoute(
          builder: (_) => new Directionality(
            textDirection: TextDirection.rtl,
            child: BlocProvider(
              create: (BuildContext context) => UserBloc(),
              child: SplashScreen(),
            ),
          ),
        );

      case '/user_page':
        return MaterialPageRoute(
          builder: (_) => new Directionality(
            textDirection: TextDirection.rtl,
            child: BlocProvider(
              create: (BuildContext context) => UserBloc(),
              child: UserScreen(),
            ),
          ),
        );
      case '/user_login_page':
        return MaterialPageRoute(
          builder: (_) => new Directionality(
            textDirection: TextDirection.rtl,
            child: BlocProvider(
              create: (BuildContext context) => UserBloc(),
              child: LoginScreen(),
            ),
          ),
        );

      case '/user_edit_page':
        return MaterialPageRoute(
          builder: (_) => new Directionality(
              textDirection: TextDirection.rtl, child: EditUserSreen()),
        );
      case '/user_details_page':
        return MaterialPageRoute(
          builder: (_) => new Directionality(
              textDirection: TextDirection.rtl, child: DetailsUserScreen()),
        );
      case '/contact_us_page':
        return MaterialPageRoute(
          builder: (_) => new Directionality(
              textDirection: TextDirection.rtl, child: ContactUsScreen()),
        );
      case '/register_page':
        return MaterialPageRoute(
            builder: (_) => new Directionality(
                  textDirection: TextDirection.rtl,
                  child: BlocProvider(
                    create: (BuildContext context) => UserBloc(),
                    child: RegisterScreen(),
                  ),
                ));
      case '/about_us_page':
        return MaterialPageRoute(
          builder: (_) => new Directionality(
              textDirection: TextDirection.rtl, child: AboutUsScreen()),
        );

      case '/transaction_add_page':
        return MaterialPageRoute(
          builder: (_) => new Directionality(
            textDirection: TextDirection.rtl,
            child: MultiBlocProvider(
              providers: [
                BlocProvider<UserBloc>(
                  create: (BuildContext context) => UserBloc(),
                ),
                BlocProvider<TransactionBloc>(
                  create: (BuildContext context) => TransactionBloc(),
                ),
              ],
              child: AddTransaction(),
            ),
          ),
        );
      case '/transaction_details_page':
        return MaterialPageRoute(
          builder: (_) => new Directionality(
              textDirection: TextDirection.rtl,
              child: DetailsTransactionScreen()),
        );
      case '/transaction_edit_page':
        return MaterialPageRoute(
          builder: (_) => new Directionality(
            textDirection: TextDirection.rtl,
            child: MultiBlocProvider(
              providers: [
                BlocProvider<UserBloc>(
                  create: (BuildContext context) => UserBloc(),
                ),
                BlocProvider<TransactionBloc>(
                  create: (BuildContext context) => TransactionBloc(),
                ),
              ],
              child: EditTransactionScreen(),
            ),
          ),
        );
      case '/drawer':
        return MaterialPageRoute(
          builder: (_) => DrawerScreen(),
        );
      case '/transactions_page':
        return MaterialPageRoute(
          builder: (_) => new Directionality(
            textDirection: TextDirection.rtl,
            child: BlocProvider(
              create: (BuildContext context) => TransactionBloc(),
              child: TransactionsScreen(),
            ),
          ),
        );
      case '/loans_page':
        return MaterialPageRoute(
          builder: (_) => new Directionality(
            textDirection: TextDirection.rtl,
            child: BlocProvider(
              create: (BuildContext context) => LoanBloc(),
              child: LoanScreen(),
            ),
          ),
        );
      case '/loan_add_page':
        return MaterialPageRoute(
          builder: (_) => new Directionality(
            textDirection: TextDirection.rtl,
            child: MultiBlocProvider(
              providers: [
                BlocProvider<UserBloc>(
                  create: (BuildContext context) => UserBloc(),
                ),
                BlocProvider<LoanBloc>(
                  create: (BuildContext context) => LoanBloc(),
                ),
              ],
              child: AddLoanScreen(),
            ),
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) => new Directionality(
              textDirection: TextDirection.rtl, child: HomeScreen()),
        );
    }
  }
}
