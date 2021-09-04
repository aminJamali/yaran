import 'package:currency_input_formatters/currency_input_formatters.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:moordak/data/dtos/installment_dtos/do_installment.dart';
import 'package:moordak/data/dtos/loan_dtos/add_loan_dto.dart';
import 'package:moordak/data/dtos/transaction_dtos/transaction_add_dto.dart';
import 'package:moordak/data/dtos/user_dtos/get_user_info_dto.dart';
import 'package:moordak/data/repositories/mourdak_repository.dart';
import 'package:moordak/logic/blocs/installment_bloc/installment_bloc.dart';
import 'package:moordak/logic/blocs/loan_bloc/loan_bloc.dart';
import 'package:moordak/presentation/components/check_box.dart';
import 'package:moordak/presentation/components/text_input.dart';
import 'package:moordak/presentation/consts/colors.dart';
import 'package:moordak/presentation/consts/strings.dart';
import 'package:persian_datepicker/persian_datepicker.dart';
import 'package:persian_datepicker/persian_datetime.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

class AddLoanScreen extends StatefulWidget {
  @override
  _AddLoanScreenState createState() => _AddLoanScreenState();
}

class _AddLoanScreenState extends State<AddLoanScreen> {
  LoanBloc _loanBloc;
  InstallmentBloc _installmentBloc;
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _typeAheadController = TextEditingController();
  String _selectedUser;
  SharedPreferences _preferences;
  MourdakRepository _mourdakRepository = new MourdakRepository();
  bool _isLoading, _isFinished = false, _isSuccessed = false;
  TextEditingController _loanValController = new TextEditingController();

  TextEditingController _installmentCount = new TextEditingController();
  TextEditingController _installmentMonthPeriod = new TextEditingController();

  TextEditingController _installmentValController = new TextEditingController();
  final _currencyFormatter = CurrencyFormatter();
  int _loanVal, _installmentVal;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loanBloc = BlocProvider.of<LoanBloc>(context);

    dateTextController.text = 'تاریخ دریافت';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer(
      bloc: _loanBloc,
      listener: (context, state) {
        if (state is LoanExceptionState) {
          _exceptionState(state.message);
        } else if (state is AddLoanState) {
          _addLoan(state.isSuccessed);
        }
      },
      builder: (context, state) {
        if (state is LoanLoadingState) {
          _isLoading = true;
        }
        return Scaffold(
          appBar: _MyAppBar(),
          key: _scaffoldKey,
          backgroundColor: bodycolor,
          body: new Stack(
            alignment: Alignment.topCenter,
            children: [
              _background(),
              _form(),
            ],
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

  _addLoan(bool isSuccessed) {
    _isLoading = false;
    if (isSuccessed == true) {
      Toast.show('با موفقیت اضافه شد', context);
      _formKey.currentState.reset();
      _typeAheadController.clear();

      _installmentValController.clear();
      _installmentCount.clear();
      _installmentMonthPeriod.clear();
      _loanValController.clear();
      _isFinished = false;
    } else {
      Toast.show('عملیات ناموفق', context);
    }
  }

  Widget _background() {
    return Container(
      height: MediaQuery.of(context).size.height * .30,
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: maincolor,
          borderRadius: BorderRadius.only(
              bottomLeft: Radius.elliptical(700, 200),
              bottomRight: Radius.elliptical(700, 200))),
    );
  }

  Widget _submit(context) {
    return InkWell(
      onTap: () async {
        if (_formKey.currentState.validate()) {
          PersianDateTime persianDate1 =
              PersianDateTime(jalaaliDateTime: dateTextController.text);
          persianDate1.toGregorian();

          _preferences = await SharedPreferences.getInstance();
          String _apiToken = _preferences.getString('apiToken');

          AddLoanDto loanAddDto = new AddLoanDto(
            applicationUserId: _selectedUser,
            getDate: persianDate1.datetime.toString().replaceFirst(" ", "T"),
            installmentCount: int.parse(_installmentCount.text),
            apiToken: _apiToken,
            installmentMonthPeriod: int.parse(_installmentMonthPeriod.text),
            installmentVal: _installmentVal,
            isFinished: _isFinished,
            loanVal: _loanVal,
          );
          _loanBloc.add(
            new AddLoanEvent(loanAddDto),
          );
        }
      },
      child: Container(
        margin: EdgeInsets.only(top: 50.0, bottom: 60.0),
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
                  'ثبت',
                  style: TextStyle(
                    fontFamily: 'IRANSans',
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
        ),
      ),
    );
  }

  Widget _form() {
    return SingleChildScrollView(
        child: Container(
      width: MediaQuery.of(context).size.width,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Color(0xffffffff),
          borderRadius: BorderRadius.all(Radius.circular(20))),
      margin: EdgeInsets.only(
          right: 25, left: 25, top: MediaQuery.of(context).size.height * .10),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            TypeAheadFormField(
              textFieldConfiguration: TextFieldConfiguration(
                controller: _typeAheadController,
                decoration: InputDecoration(
                  labelText: 'کاربر',
                ),
              ),
              suggestionsCallback: (pattern) async {
                _preferences = await SharedPreferences.getInstance();
                GetUserInfoDto getUserInfoDto = new GetUserInfoDto(
                  apiToken: _preferences.getString('apiToken'),
                  searchText: pattern,
                );
                // _userBloc.add(
                //   GetAllUsersEvent(getUserInfoDto),
                // );

                return await _mourdakRepository.getUserInfo(getUserInfoDto);
              },
              itemBuilder: (context, suggestion) {
                return ListTile(
                    title: Text(
                  "${suggestion['firstName']} ${suggestion['lastName'] == null ? "" : suggestion['lastName']}",
                ));
              },
              transitionBuilder: (context, suggestionsBox, controller) {
                return suggestionsBox;
              },
              onSuggestionSelected: (suggestion) {
                this._typeAheadController.text =
                    "${suggestion['firstName']} ${suggestion['lastName']}";
                _selectedUser = suggestion['id'];
              },
              validator: (value) {
                if (value.isEmpty) {
                  return 'لطفا این فرم را پر کنید';
                }
              },
            ),
            new InputFieldArea(
              inputFormatter: [_currencyFormatter],
              onChanged: (_) {
                _loanVal = _currencyFormatter.currentNumber;
              },
              icon: Icons.monetization_on_sharp,
              controller: _loanValController,
              lable: 'مبلغ وام (ریال)',
              maxLength: 12,
              validator: (value) {
                if (value.isEmpty) {
                  return 'لطفا این فرم را پر کنید';
                }
                return null;
              },
              textInputType: TextInputType.number,
            ),

            // user bottom sheet ===================>
            // _buildUserButton(),
            // _selectedUserName != null
            //     ? _buildSelectedUser()
            //     : new Container(
            //         padding: EdgeInsets.all(15),
            //         child: new Text(
            //           'کاربری انتخاب نشده',
            //           style: new TextStyle(
            //             fontSize: 16,
            //           ),
            //         ),
            //       ),
            new InputFieldArea(
              icon: Icons.confirmation_number,
              controller: _installmentCount,
              lable: 'تعداد اقساط',
              maxLength: 2,
              validator: (value) {
                if (value.isEmpty) {
                  return 'لطفا این فرم را پر کنید';
                }
                return null;
              },
              textInputType: TextInputType.number,
            ),
            new InputFieldArea(
              icon: Icons.calendar_today,
              controller: _installmentMonthPeriod,
              lable: 'تعداد دوره ماهیانه اقساط',
              maxLength: 2,
              validator: (value) {
                if (value.isEmpty) {
                  return 'لطفا این فرم را پر کنید';
                }
                return null;
              },
              textInputType: TextInputType.number,
            ),
            new InputFieldArea(
              inputFormatter: [_currencyFormatter],
              onChanged: (_) {
                _installmentVal = _currencyFormatter.currentNumber;
              },
              icon: Icons.monetization_on_sharp,
              controller: _installmentValController,
              lable: 'مبلغ هر قسط (ریال)',
              maxLength: 12,
              validator: (value) {
                if (value.isEmpty) {
                  return 'لطفا این فرم را پر کنید';
                }
                return null;
              },
              textInputType: TextInputType.number,
            ),
            new LabeledCheckbox(
              label: 'پایان یافته',
              value: _isFinished,
              onChanged: (value) {
                setState(() {
                  _isFinished = value;
                });
              },
            ),
            _LoanDatePicker(),

            _submit(context),
          ],
        ),
      ),
    ));
  }

  Widget _buildUserButton() {
    return InkWell(
      onTap: () {
        _modalBottomSheetMenu();
      },
      child: Container(
        margin: EdgeInsets.only(top: 50.0, bottom: 60.0),
        width: 230.0,
        height: 40.0,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: maincolor,
        ),
        child: Center(
          child: Text(
            _typeAheadController.text != null
                ? _typeAheadController.text
                : "انتخاب کاربر",
            style: TextStyle(
              fontFamily: 'IRANSans',
              color: Colors.white,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }

  void _modalBottomSheetMenu() {
    showModalBottomSheet(
        context: context,
        builder: (builder) {
          return StatefulBuilder(builder: (BuildContext context,
              StateSetter setState /*You can rename this!*/) {
            return Container(
              height: 500.0,
              padding: EdgeInsets.all(15),
              color: Colors.transparent,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TypeAheadFormField(
                    textFieldConfiguration: TextFieldConfiguration(
                      controller: _typeAheadController,
                      decoration: InputDecoration(
                        labelText: 'کاربر',
                      ),
                    ),
                    suggestionsCallback: (pattern) async {
                      _preferences = await SharedPreferences.getInstance();
                      GetUserInfoDto getUserInfoDto = new GetUserInfoDto(
                        apiToken: _preferences.getString('apiToken'),
                        searchText: pattern,
                      );
                      // _userBloc.add(
                      //   GetAllUsersEvent(getUserInfoDto),
                      // );

                      return await _mourdakRepository
                          .getUserInfo(getUserInfoDto);
                    },
                    itemBuilder: (context, suggestion) {
                      return ListTile(
                          title: Text(
                        "${suggestion['firstName']} ${suggestion['lastName'] == null ? "" : suggestion['lastName']}",
                      ));
                    },
                    transitionBuilder: (context, suggestionsBox, controller) {
                      return suggestionsBox;
                    },
                    onSuggestionSelected: (suggestion) {
                      this._typeAheadController.text =
                          "${suggestion['firstName']} ${suggestion['lastName']}";
                      _selectedUser = suggestion['id'];
                    },
                    validator: (value) {
                      if (value.isEmpty) {
                        return 'لطفا این فرم را پر کنید';
                      }
                    },
                  ),
                  new FloatingActionButton(
                    backgroundColor: maincolor,
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: new Icon(Icons.done, color: Colors.white),
                  ),
                ],
              ),
            );
          });
        });
  }
}

class _LoanDatePicker extends StatefulWidget {
  @override
  TransactionDatePickerState createState() {
    return new TransactionDatePickerState();
  }
}

final TextEditingController dateTextController = TextEditingController();
PersianDatePickerWidget persianDatePicker;

class TransactionDatePickerState extends State<_LoanDatePicker> {
  // our text controller

  @override
  void initState() {
    /*Simple DatePicker*/
    persianDatePicker = PersianDatePicker(
      controller: dateTextController,
      // datetime: 'تاریخ دریافت',
    ).init();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        enableInteractiveSelection:
            false, // *** this is important to prevent user interactive selection ***
        onTap: () {
          FocusScope.of(context).requestFocus(
              new FocusNode()); // to prevent opening default keyboard
          showModalBottomSheet(
              context: context,
              builder: (BuildContext context) {
                return persianDatePicker;
              });
        },
        controller: dateTextController,
      ),
    );
  }
}

class _MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => const Size.fromHeight(50);

  @override
  Widget build(BuildContext context) {
    return new AppBar(
      elevation: 0,
      title: new Text(
        'افزودن وام',
        style: new TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
      ),
      backgroundColor: maincolor,
    );
  }
}
