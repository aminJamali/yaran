import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:moordak/data/dtos/installment_dtos/do_installment.dart';
import 'package:moordak/data/models/loan_model.dart';
import 'package:moordak/logic/blocs/installment_bloc/installment_bloc.dart';
import 'package:moordak/presentation/components/lable.dart';
import 'package:moordak/presentation/consts/colors.dart';
import 'package:moordak/presentation/consts/strings.dart';
import 'package:persian_number_utility/persian_number_utility.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class LoanDetailsScreen extends StatefulWidget {
  final LoanModel loanModel;

  const LoanDetailsScreen({this.loanModel});
  @override
  _LoanDetailsScreenState createState() => _LoanDetailsScreenState();
}

class _LoanDetailsScreenState extends State<LoanDetailsScreen> {
  InstallmentBloc _installmentBloc;
  bool _isLoading = false;
  SharedPreferences _preferences;
  bool _isTaqsit = false;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _installmentBloc = BlocProvider.of<InstallmentBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _installmentBloc,
      listener: (context, state) {
        if (state is InstallmentExceptionState) {
          _exceptionState(state.message);
        } else if (state is DoInstallmentState) {
          _doInstallment(state.isSuccessed);
        }
      },
      builder: (context, state) {
        if (state is InstallmentLoadingState) {
          _isLoading = true;
        }

        return Scaffold(
          key: _scaffoldKey,
          appBar: _buildAppBar(),
          body: new SingleChildScrollView(
            child: new Column(
              children: [
                new Lable(
                  title: "نام و نام خانوادگی :",
                  description:
                      '${widget.loanModel.firstName} ${widget.loanModel.lastName == null ? "" : widget.loanModel.lastName}',
                ),
                new Divider(
                  height: 4,
                  color: Colors.grey[400],
                ),
                new Lable(
                  title: "کد ملی :",
                  description: '${widget.loanModel.nationalCode}',
                ),
                new Divider(
                  height: 4,
                  color: Colors.grey[400],
                ),
                new Lable(
                  title: "مقدار وام",
                  description:
                      '${widget.loanModel.loanVal.toString().seRagham()} ریال',
                ),
                new Divider(
                  height: 4,
                  color: Colors.grey[400],
                ),
                new Lable(
                  title: "دوره ماهیانه :",
                  description:
                      '${widget.loanModel.installmentMonthPeriod.toString()}',
                ),
                new Divider(
                  height: 4,
                  color: Colors.grey[400],
                ),
                new Lable(
                  title: "مبلغ هر قسط :",
                  description:
                      '${widget.loanModel.installmentVal.toString().seRagham()} ریال',
                ),
                new Divider(
                  height: 4,
                  color: Colors.grey[400],
                ),
                new Lable(
                  title: "تاریخ دریافت :",
                  description: '${widget.loanModel.getDate.toPersianDate()}',
                ),
                new Divider(
                  height: 4,
                  color: Colors.grey[400],
                ),
                new Lable(
                  title: "وضعیت وام :",
                  description: widget.loanModel.isFinished == true
                      ? "اتمام یافته"
                      : "جاری",
                ),
                new Divider(
                  height: 4,
                  color: Colors.grey[400],
                ),
                widget.loanModel.loanInstallments.length == 0 ||
                        _isTaqsit == true
                    ? _buildDoInstallmentButton(widget.loanModel.id)
                    : new Container(
                        child: new Text(
                          'عملیات تقسیط انجام شده',
                          style: new TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  _exceptionState(String exception) async {
    _isLoading = false;
    if (exception == '401') {
      _preferences = await SharedPreferences.getInstance();
      _preferences.clear();
      Navigator.pushReplacementNamed(context, '/');
    } else {
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(exception),
        ),
      );
    }
  }

  _doInstallment(bool isSuccessed) {
    _isLoading = false;
    if (isSuccessed == true) {
      setState(() {
        _isTaqsit = false;
      });
      Toast.show('با موفقیت قسط بندی شد', context, duration: 2);
    } else {
      Toast.show('عملیات نا موفق', context, duration: 2);
    }
  }

  Widget _buildDoInstallmentButton(int loanId) {
    return InkWell(
        onTap: () async {
          _preferences = await SharedPreferences.getInstance();
          _installmentBloc.add(
            DoInstallmentEvent(
              new DoInstallmentDto(
                apiToken: _preferences.getString('apiToken'),
                id: loanId,
              ),
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.only(
            top: 30.0,
          ),
          width: 230.0,
          height: 40.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: maincolor,
          ),
          child: Center(
            child: _isLoading == true
                ? new CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(
                    'تقسیط وام',
                    style: TextStyle(
                      fontFamily: 'IRANSans',
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
          ),
        ));
  }

  Widget _buildAppBar() {
    return new AppBar(
      backgroundColor: maincolor,
      title: Text(
        'جزئیات وام',
        style: new TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }
}
